#!/usr/bin/perl
use strict;
use warnings;
use File::Temp qw(tempdir);
use FindBin;
use Text::ParseWords qw(shellwords);
use lib $FindBin::Bin;
use CppgmBackendFixture qw(backend_tests backend_expectation fixture_units read_bytes);
use CppgmBatchWorker qw(run_command_capture);

if (@ARGV && $ARGV[0] eq '--list')
{
	shift @ARGV;
	print "$_\n" for backend_tests('i386', @ARGV);
	exit 0;
}
die "Usage: check_i386.pl <cppgm> <fixture>\n" if @ARGV != 2;
my ($compiler, $test) = @ARGV;
my $expect = backend_expectation($test, 'i386');
my $directory = tempdir('cppgm-i386-XXXXXX', TMPDIR => 1, CLEANUP => 1);
my $stdout = "$directory/stdout";
my $stderr = "$directory/stderr";
my $linker = $ENV{CPPGM_I386_LD} // 'ld';
my @runner = shellwords($ENV{CPPGM_I386_RUNNER} // '');

sub run
{
	my ($expected, @args) = @_;
	my %outcome;
	my $status = run_command_capture(cmd => \@args, stdout => $stdout, stderr => $stderr,
		timeout => 30, outcome => \%outcome);
	die "@args: expected exit $expected, got $status\n" . read_bytes($stderr)
		if $status != $expected || $outcome{signal} || $outcome{timed_out};
	return read_bytes($stdout);
}

my @objects;
for my $source ($test, fixture_units($test, $expect))
{
	my $object = "$directory/" . scalar(@objects) . ".o";
	my @language = $source =~ /\.c\z/ ? () : ('-x', 'assembler-with-cpp');
	run(0, $compiler, '--target=i386-linux-gnu', @{$expect->{flags} // []}, @language, '-c', $source, '-o', $object);
	push @objects, $object;
}
if ($expect->{shared_link})
{
	run(0, $linker, '-m', 'elf_i386', '-shared', '--no-undefined', '-z', 'text',
		'-o', "$directory/shared.so", @objects);
}
my $program = "$directory/program";
run(0, $linker, '-m', 'elf_i386', '-static', '-o', $program, @objects);
for my $command (@{$expect->{commands}})
{
	my $output = run($command->{exit}, @runner, $program, @{$command->{args} // []});
	die "$test: guest stdout differs\n" if $output ne ($command->{stdout} // '');
}
print "i386 control passed\n";
