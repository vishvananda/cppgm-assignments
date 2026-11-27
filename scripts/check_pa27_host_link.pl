#!/usr/bin/perl

use strict;
use warnings;
use File::Temp qw(tempdir);
use FindBin;
use lib $FindBin::Bin;
use CppgmBatchWorker qw(collect_tests run_command_capture);

my $selection = qr/hosted-link-[^.]+\.t$/;
if (@ARGV && $ARGV[0] eq '--list')
{
	shift @ARGV;
	print "$_\n" for map { collect_tests($_, $selection) } @ARGV;
	exit 0;
}

die "Usage: check_pa27_host_link.pl <cppgm> <test-or-directory>\n" if @ARGV != 2;
my ($app, $root) = @ARGV;
my @tests = collect_tests($root, $selection);
die "No PA27 hosted link controls found under $root\n" if !@tests;

for my $test (@tests)
{
	my $directory = tempdir('pa27-host-link-XXXXXX', TMPDIR => 1, CLEANUP => 1);
	my $program = "$directory/hosted program";
	my $object = "$directory/provider.o";
	my $unit = "$test.1";
	my $run = sub {
		my ($expect_failure, @command) = @_;
		my $status = run_command_capture(cmd => \@command, stdout => "$directory/stdout",
			stderr => "$directory/stderr", timeout => 30);
		if (($status != 0) != $expect_failure)
		{
			open(my $log, '<', "$directory/stderr") or die "Cannot read link diagnostic: $!\n";
			local $/;
			die "$test: unexpected status $status from @command\n" . <$log>;
		}
	};

	$run->(0, $app, '-x', 'c++', '-pthread', $test, $unit, '-o', $program);
	$run->(0, $program);
	$run->(0, $app, '-x', 'c++', '-c', $unit, '-o', $object);
	$run->(0, $app, '-x', 'c++', '-pthread', $test, $object, '-o', $program);
	$run->(0, $program);
	$run->(0, 'ar', 'rcs', "$directory/libpa27_provider.a", $object);
	my $map_option = $^O eq 'darwin' ? '-map' : '-Map';
	my $map = "$directory/link map";
	$run->(0, $app, '-x', 'c++', '-pthread', $test, '-L', $directory, '-lpa27_provider',
		'-Xlinker', $map_option, '-Xlinker', $map, '-o', $program);
	die "$test: host linker did not write a map\n" if !-s $map;
	$run->(0, $program);
	$run->(1, $app, '-x', 'c++', '-pthread', $test, '-o', "$directory/unresolved");
	die "$test: failed link left an executable\n" if -e "$directory/unresolved";
}

print "PA27 hosted link: PASS (" . scalar(@tests) . "/" . scalar(@tests) . ")\n"
	unless $ENV{CPPGM_REPORT_QUIET};
