#!/usr/bin/env perl
# Build the Apple SDK interoperability matrix on Linux or directly on a Mac.
use strict;
use warnings;
use Digest::SHA qw(sha256_hex);
use File::Basename qw(basename dirname);
use File::Copy qw(copy);
use File::Path qw(make_path);
use File::Spec;
use File::Temp qw(tempdir);
use FindBin;
use Getopt::Long qw(GetOptions);
use JSON::PP;
use lib $FindBin::Bin;
use CppgmBatchWorker qw(write_file);
use CppgmBackendFixture qw(backend_tests backend_expectation fixture_units read_bytes);
use CppgmArm64MachO qw(apple_silicon run_tool execute_macho macho_link_inputs);

my $compiler = "$FindBin::Bin/../dev/cppgm";
GetOptions('compiler=s' => \$compiler) && @ARGV == 2 or die "usage: $0 [--compiler PATH] build|replay DIRECTORY\n";
my ($mode, $directory) = @ARGV;
$directory = File::Spec->rel2abs($directory);
$compiler = File::Spec->rel2abs($compiler);
my $dir = tempdir('cppgm-macho-replay-XXXXXX', TMPDIR => 1, CLEANUP => 1);
my $root = "$FindBin::Bin/../pa39";
my $clang = $ENV{CPPGM_AARCH64_CLANG} // 'clang++';
my $target = '--target=arm64-apple-macos11';
my $manifest = {objects => {}, programs => [], executables => {}};

sub digest { return sha256_hex(read_bytes($_[0])); }

sub build_fixture {
    my ($test, $expect) = @_;
    my $stem = basename($test, '.t');
    my @units = ($test, fixture_units($test, $expect));
    my @assembly;
    for my $file (@{$expect->{reference_assembly} // []}) {
        my $name = "$stem-witness-".scalar(@assembly).'.o';
        run_tool($dir, 0, $clang, $target, @{$expect->{reference_flags} // []}, '-c', dirname($test)."/$file", '-o', "$directory/$name");
        $manifest->{objects}{$name} = digest("$directory/$name");
        push @assembly, $name;
    }
    for my $level (@{$expect->{levels} // [0..3]}) {
        my %objects;
        for my $pair (['cppgm', $compiler], ['clang', $clang]) {
            my ($label, $tool) = @$pair;
            for my $i (0 .. $#units) {
                my $name = "$stem-O$level-$label-$i.o";
                run_tool($dir, 0, $tool, $target, "-O$level", @{$expect->{flags} // []},
                    ($expect->{hosted} ? () : '-fno-stack-protector'), '-x', 'c++', '-c', $units[$i], '-o', "$directory/$name");
                push @{$objects{$label}}, $name;
                $manifest->{objects}{$name} = digest("$directory/$name");
            }
        }
        my @cases = ($objects{cppgm}, $objects{clang});
        if (@units > 1 && $expect->{llvm_interop}) {
            push @cases, [$objects{cppgm}[0], @{$objects{clang}}[1 .. $#units]],
                         [$objects{clang}[0], @{$objects{cppgm}}[1 .. $#units]];
        }
        if ($expect->{source_link_flags}) {
            my $name = "$stem-O$level-combined.o";
            my @group = ($compiler, $target, "-O$level", @{$expect->{flags} // []},
                @{$expect->{source_link_flags}}, '-x', 'c++', @units);
            run_tool($dir, 0, @group, '-c', '-o', "$directory/$name");
            $manifest->{objects}{$name} = digest("$directory/$name");
            push @cases, [$name];
            my $exe = "$stem-O$level-source-lto";
            run_tool($dir, 0, @group, '-o', "$directory/$exe");
            $manifest->{executables}{$exe} = {sha256 => digest("$directory/$exe"), commands => $expect->{commands}};
        }
        for my $case (@cases) {
            my @names = (@$case, @assembly);
            my @paths = map { "$directory/$_" } @names;
            push @{$manifest->{programs}}, {inputs => \@names, commands => $expect->{commands}, archive_units => $expect->{archive_units}};
            @paths = macho_link_inputs($dir, $expect->{archive_units}, @paths);
            next if $expect->{hosted};
            if ($case == $objects{cppgm}) {
                my $name = "$stem-O$level";
                run_tool($dir, 0, $compiler, $target, @paths, '-o', "$dir/program");
                execute_macho($dir, $expect->{commands}, $clang);
                copy("$dir/program", "$directory/$name") or die "copy $name: $!\n";
                $manifest->{executables}{$name} = {sha256 => digest("$directory/$name"), commands => $expect->{commands}};
            }
            unless (apple_silicon()) {
                run_tool($dir, 0, $clang, $target, '-nostdlib', '-fuse-ld=lld', @paths, '-o', "$dir/program");
                execute_macho($dir, $expect->{commands}, $clang);
            }
        }
    }
}

if ($mode eq 'build') {
    make_path($directory);
    for my $test (backend_tests('arm', "$root/tests")) {
        my $expect = backend_expectation($test, 'arm');
        next if ($expect->{target} // '') eq 'aarch64-linux-gnu';
        build_fixture($test, $expect);
    }
    @{$manifest->{programs}} or die "no macOS controls discovered\n";
    write_file("$directory/manifest.json", JSON::PP->new->canonical->pretty->encode($manifest));
    printf "Packaged %d objects, %d course executables and %d Apple SDK link cases\n",
        scalar(keys %{$manifest->{objects}}), scalar(keys %{$manifest->{executables}}), scalar(@{$manifest->{programs}});
} elsif ($mode eq 'replay') {
    apple_silicon() or die "native replay requires Apple Silicon macOS\n";
    $manifest = JSON::PP->new->decode(read_bytes("$directory/manifest.json"));
    for my $name (sort keys %{$manifest->{objects}}) {
        digest("$directory/$name") eq $manifest->{objects}{$name} or die "$name: checksum mismatch\n";
    }
    for my $name (sort keys %{$manifest->{executables}}) {
        my $expected = $manifest->{executables}{$name};
        digest("$directory/$name") eq $expected->{sha256} or die "$name: checksum mismatch\n";
        copy("$directory/$name", "$dir/program") or die "copy $name: $!\n";
        chmod 0755, "$dir/program" or die "chmod $dir/program: $!\n";
        execute_macho($dir, $expected->{commands} // [{exit => $expected->{exit}}], $clang);
    }
    for my $program (@{$manifest->{programs}}) {
        my @inputs = map { "$directory/$_" } @{$program->{inputs}};
        @inputs = macho_link_inputs($dir, $program->{archive_units}, @inputs);
        run_tool($dir, 0, 'xcrun', '--sdk', 'macosx', 'clang++', '-arch', 'arm64', '-mmacosx-version-min=11.0',
            @inputs, '-o', "$dir/program");
        execute_macho($dir, $program->{commands} // [{exit => $program->{exit}}], $clang);
    }
    print "Native macOS replay passed\n";
} else {
    die "expected build or replay\n";
}
