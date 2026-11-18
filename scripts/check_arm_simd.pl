#!/usr/bin/perl
use strict;
use warnings;
use Cwd qw(abs_path);
use File::Temp qw(tempdir);
use FindBin;
use Getopt::Long qw(GetOptions);
use lib $FindBin::Bin;
use CppgmWasmBenchmark qw(workload_names oracle_cases);

my $root = abs_path("$FindBin::Bin/..");
my $compiler = "$root/dev/cppgm";
my $objdump = 'llvm-objdump';
my $qemu;
GetOptions('compiler=s' => \$compiler, 'objdump=s' => \$objdump, 'qemu=s' => \$qemu)
    && !@ARGV or die "usage: check_arm_simd.pl [--compiler path] [--objdump path] [--qemu path]\n";
my @runner = defined($qemu) ? ($qemu, '-cpu', 'cortex-a53') : ();
my $tmp = tempdir(CLEANUP => 1);
my $target = '--target=aarch64-linux-gnu';

# Use the PA37 workload and its independent Perl oracle, including edge seeds.
open my $driver, '>', "$tmp/main.cpp" or die $!;
print {$driver} <<'CPP';
extern "C" void prepare(unsigned);
extern "C" unsigned run(unsigned, unsigned, unsigned);
struct Case { unsigned kind, repeats, seed, expected; };
static const Case cases[] = {
CPP
my @cases = oracle_cases();
for my $case (@cases) {
    print {$driver} '    {', join(', ', map { $_ . 'u' } @$case), "},\n";
}
print {$driver} <<'CPP';
};
int main() {
    for (unsigned i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        const Case& c = cases[i];
        prepare(c.seed);
        if (run(c.kind, c.repeats, c.seed) != c.expected) return i + 1;
    }
    return 0;
}
CPP
close $driver or die $!;

sub checked {
    system(@_) == 0 or die "command failed (status $?): @_\n";
}
checked($compiler, $target, '-O0', '-c', "$tmp/main.cpp", '-o', "$tmp/main.o");
for my $level (0, 3) {
    for my $simd (0, 1) {
        my $object = "$tmp/kernels.o";
        checked($compiler, $target, "-O$level", '-fno-strict-aliasing', "-DCPPGM_BENCH_SIMD=$simd",
            '-c', "$root/pa37/benchmarks/kernels.cpp", '-o', $object);
        if ($simd && $level == 3) {
            open my $dump, '-|', $objdump, '-d', '--disassemble-symbols=_ZL15transform_wordsj', $object or die $!;
            my @vector = grep { /\bv\d+\.4s\b/ } <$dump>;
            close $dump or die "$objdump failed\n";
            @vector or die "optimized transform_words contains no four-lane NEON instructions\n";
        }
        checked($compiler, $target, "$tmp/main.o", $object, '-o', "$tmp/guest");
        my $status = system(@runner, "$tmp/guest");
        if ($status != 0) {
            my $index = ($status >> 8) - 1;
            die "Arm guest failed (status $status)\n" if ($status & 127) || $index < 0 || $index > $#cases;
            my ($kind, $repeats, $seed, $expected) = @{$cases[$index]};
            my @names = workload_names();
            die "Arm -O$level SIMD=$simd: $names[$kind], repeats=$repeats seed=$seed expected=$expected\n";
        }
        printf "Arm -O%d CPPGM_BENCH_SIMD=%d passed all %d PA37 oracle cases\n", $level, $simd, scalar @cases;
    }
}
