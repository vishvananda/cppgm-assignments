package CppgmArm64MachO;

use strict;
use warnings;
use Digest::SHA qw(sha256);
use Exporter 'import';
use File::Basename qw(dirname);
use File::Compare qw(compare);
use POSIX qw(uname);
use CppgmBackendFixture qw(read_bytes fixture_units);
use CppgmBatchWorker qw(run_command_capture write_file);

our @EXPORT_OK = qw(apple_silicon run_tool execute_macho check_apple_fixture macho_link_inputs);

sub apple_silicon { return $^O eq 'darwin' && (uname())[4] eq 'arm64'; }

sub run_tool {
    my ($dir, $expected, @command) = @_;
    my ($out, $err) = ("$dir/stdout", "$dir/stderr");
    unlink $out, $err;
    my $status = run_command_capture(cmd => \@command, timeout => 90, stdout => $out, stderr => $err);
    die "@command: expected $expected, got $status\n", read_bytes($out), read_bytes($err)
        unless $status == $expected;
    return read_bytes($out);
}

sub verify_signature {
    my ($image, $start, $size) = @_;
    my $blob = substr($image, $start, $size);
    my ($magic, $length, $count) = unpack('N3', $blob);
    die "invalid embedded signature\n" unless $magic == 0xfade0cc0 &&
        $length <= length($blob) && 12 + 8 * $count <= $length;
    for my $index (0 .. $count - 1) {
        my ($kind, $offset) = unpack('NN', substr($blob, 12 + 8 * $index, 8));
        next if $kind != 0;
        my $cd = substr($blob, $offset, $length - $offset);
        my ($magic, $bytes, undef, undef, $hashes, undef, undef, $slots, $limit) = unpack('N9', $cd);
        my ($width, $algorithm, undef, $shift) = unpack('C4', substr($cd, 36, 4));
        die "invalid primary SHA-256 code directory\n" unless $magic == 0xfade0c02 && $width == 32 &&
            $algorithm == 2 && $limit == $start && $shift < 32 && $bytes <= length($cd);
        my $page = 1 << $shift;
        die "invalid code signature slots\n" unless $slots == int(($limit + $page - 1) / $page) &&
            $hashes + $slots * $width <= $bytes;
        for my $slot (0 .. $slots - 1) {
            my $begin = $slot * $page;
            my $size = $limit - $begin < $page ? $limit - $begin : $page;
            die "Mach-O code signature mismatch on page $slot\n"
                unless sha256(substr($image, $begin, $size)) eq substr($cd, $hashes + $slot * $width, $width);
        }
        return;
    }
    die "missing primary code directory\n";
}

sub macho_image {
    my ($path) = @_;
    my $image = read_bytes($path);
    my ($magic, $cpu, undef, $kind, $count) = unpack('V5', $image);
    die "expected an arm64 Mach-O executable: $path\n"
        unless $magic == 0xfeedfacf && $cpu == 0x100000c && $kind == 2;
    my ($entry, $text_base, $signed, @segments, @initializers);
    my $offset = 32;
    for (1 .. $count) {
        my ($cmd, $bytes) = unpack('VV', substr($image, $offset, 8));
        die "$path: invalid load command\n" unless $bytes >= 8 && $offset + $bytes <= length($image);
        my $data = substr($image, $offset, $bytes);
        if ($cmd == 0x19) {  # LC_SEGMENT_64
            my ($name, $address, $memory, $start, $length, undef, $protection, $sections) =
                unpack('x8 Z16 Q<4 V3', $data);
            $text_base = $address - $start if $name eq '__TEXT';
            push @segments, [$address, $memory, $start, $length, $protection]
                unless $name eq '__LINKEDIT' || $name eq '__PAGEZERO';
            die "$path: invalid section count\n" if 72 + $sections * 80 > $bytes;
            for my $i (0 .. $sections - 1) {
                my ($size, $file, $flags) = unpack('x40 Q< V x12 V', substr($data, 72 + 80 * $i, 80));
                my $type = $flags & 255;
                next unless $type == 9 || $type == 0x16; # initializer pointers / image offsets
                my $width = $type == 9 ? 8 : 4;
                die "$path: invalid initializer table\n" if $file + $size > length($image) || $size % $width;
                for my $value (unpack($width == 8 ? 'Q<*' : 'V*', substr($image, $file, $size))) {
                    push @initializers, [$type, $value];
                }
            }
        } elsif ($cmd == 0x80000028) { # LC_MAIN
            ($entry) = unpack('x8 Q<', $data);
        } elsif ($cmd == 0x1d) { # LC_CODE_SIGNATURE
            verify_signature($image, unpack('x8 VV', $data));
            $signed = 1;
        }
        $offset += $bytes;
    }
    die "$path: missing text, entry point or code signature\n" unless defined($entry) && defined($text_base) && $signed;
    return ($entry + $text_base, $text_base, \@segments, \@initializers);
}

sub execute_macho {
    my ($dir, $commands, $clang) = @_;
    my $program = "$dir/program";
    my ($main, $text, $segments, $initializers) = macho_image($program);
    my @runner;
    if (apple_silicon()) {
        run_tool($dir, 0, 'codesign', '--verify', '--strict', $program);
        @runner = ($program);
    } else {
        # Preserve the Mach-O addresses and bytes. Linux supplies a minimal process entry.
        my (@asm, @addresses);
        (my $quoted = $program) =~ s/(["\\])/\\$1/g;
        for my $i (0 .. $#$segments) {
            my ($addr, $memory, $start, $size, $prot) = @{$segments->[$i]};
            my $flags = $prot & 2 ? 'aw' : $prot & 4 ? 'ax' : 'a';
            push @asm, ".section .guest$i,\"$flags\",%progbits", ".incbin \"$quoted\",$start,$size", '.space '.($memory-$size);
            push @addresses, sprintf('--section-start=.guest%d=0x%x', $i, $addr);
        }
        push @asm, '.text', '.globl _start', '_start:';
        for my $init (@$initializers) {
            my ($kind, $value) = @$init;
            push @asm, sprintf('ldr x16, =0x%x', $kind == 9 ? $value : $text + $value), 'blr x16';
        }
        push @asm, 'ldr x0, [sp]', 'add x1, sp, #8', 'add x2, x1, x0, lsl #3', 'add x2, x2, #8',
            sprintf('ldr x16, =0x%x', $main), 'blr x16', 'mov x8, #93', 'svc #0';
        write_file("$dir/launch.S", join("\n", @asm)."\n");
        run_tool($dir, 0, $clang, '--target=aarch64-linux-gnu', '-c', "$dir/launch.S", '-o', "$dir/launch.o");
        run_tool($dir, 0, $ENV{CPPGM_AARCH64_LLD} // 'ld.lld', '-static', '-e', '_start', @addresses,
            "$dir/launch.o", '-o', "$dir/linux-launch");
        @runner = ($ENV{CPPGM_AARCH64_QEMU} // 'qemu-aarch64', '-cpu', 'max', "$dir/linux-launch");
    }
    for my $cmd (@$commands) {
        my $out = run_tool($dir, $cmd->{exit}, @runner, @{$cmd->{args} // []});
        die "$program: guest stdout differs\n" unless $out eq ($cmd->{stdout} // '');
    }
}

sub macho_link_inputs {
    my ($dir, $archive, $primary, @units) = @_;
    return ($primary, @units) unless $archive && @units;
    my $path = "$dir/units.a";
    unlink $path;
    my @ar = apple_silicon() ? ('xcrun', 'ar') : ($ENV{CPPGM_AARCH64_AR} // 'llvm-ar', '--format=darwin');
    run_tool($dir, 0, @ar, 'rcs', $path, @units);
    return ($primary, $path);
}

sub check_apple_fixture {
    my ($compiler, $test, $dir, $expect) = @_;
    my ($suffix) = $compiler =~ /(-ref|-self)\z/;
    my $opt = dirname($compiler).'/lowiropt'.($suffix // '');
    my $backend = dirname($compiler).'/lowir2native'.($suffix // '');
    my $clang = $ENV{CPPGM_AARCH64_CLANG} // 'clang++';
    my $target = '--target=arm64-apple-macos11';
    my @inputs = ($test, fixture_units($test, $expect));
    my @link = apple_silicon() ? () : ('-nostdlib');
    for my $level (@{$expect->{levels} // [0..3]}) {
        my @flags = ($target, "-O$level", @{$expect->{flags} // []});
        my (@cppgm, @clang, @raw);
        my $relocation_seen = 0;
        for my $i (0 .. $#inputs) {
            my $src = $inputs[$i];
            push @cppgm, "$dir/cppgm-$i.o";
            push @clang, "$dir/clang-$i.o";
            for my $pair ([$compiler, $cppgm[-1]], [$clang, $clang[-1]]) {
                run_tool($dir, 0, $pair->[0], @flags, '-x', 'c++', '-c', $src, '-o', $pair->[1]);
                my $header = run_tool($dir, 0, $ENV{CPPGM_AARCH64_READOBJ} // 'llvm-readobj',
                    '--file-headers', '--relocations', $pair->[1]);
                $relocation_seen ||= $expect->{relocation} && index($header, $expect->{relocation}) >= 0;
                die "$src: expected Mach-O arm64\n" unless $header =~ /Mach-O arm64/;
            }
            for my $optimized (0, 1) {
                my @emit = $optimized ? ("-O$level", '-S', '-emit-lowir') : ('-O0', '--emit-lowir', '-g0',
                    ($level ? '-D__OPTIMIZE__=1' : ()), ($level eq 'z' ? '-D__OPTIMIZE_SIZE__=1' : ()));
                run_tool($dir, 0, $compiler, $target, @emit, @{$expect->{flags} // []}, '-x', 'c++', $src, '-o', "$dir/unit.lowir");
                my $ir = "$dir/unit-$i-$optimized.lowir";
                run_tool($dir, 0, $opt, '-O0', "$dir/unit.lowir", '-o', $ir);
                die "$src: lost Darwin layout\n" unless read_bytes($ir) =~ /\barm64_macos\b/;
                push @raw, $ir unless $optimized;
                run_tool($dir, 0, $compiler, @flags, ($optimized ? '-fno-lowir-passes' : ()), '-c', $ir, '-o', "$dir/round.o");
                die "$src: O$level object differs after LowIR round trip\n" if compare($cppgm[-1], "$dir/round.o");
            }
        }
        die "$test: missing $expect->{relocation} relocation\n" if $expect->{relocation} && !$relocation_seen;
        my @cases = ([$compiler, @cppgm], [$clang, @clang]);
        if ($expect->{source_link_flags}) {
            my @group = ($compiler, @flags, @{$expect->{source_link_flags}}, '-x', 'c++', @inputs);
            run_tool($dir, 0, @group, @link, '-o', "$dir/program");
            execute_macho($dir, $expect->{commands}, $clang);
            run_tool($dir, 0, @group, '-c', '-o', "$dir/combined.o");
            push @cases, [$clang, "$dir/combined.o"];
        }
        if (@inputs > 1 && $expect->{llvm_interop}) {
            push @cases, [$compiler, $clang[0], @cppgm[1 .. $#cppgm]], [$compiler, $cppgm[0], @clang[1 .. $#clang]];
        }
        for my $case (@cases) {
            my ($tool, @objs) = @$case;
            @objs = macho_link_inputs($dir, $expect->{archive_units}, @objs);
            my @driver = $tool eq $clang && !apple_silicon() ? ('-fuse-ld=lld') : ();
            run_tool($dir, 0, $tool, $target, @driver, @link, @objs, '-o', "$dir/program");
            execute_macho($dir, $expect->{commands}, $clang);
        }
        my @backend_inputs = macho_link_inputs($dir, $expect->{archive_units}, $raw[0], @clang[1 .. $#clang]);
        run_tool($dir, 0, $backend, $target, "-O$level", @link, @backend_inputs, '-o', "$dir/program");
        execute_macho($dir, $expect->{commands}, $clang);
    }
}

1;
