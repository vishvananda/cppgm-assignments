#!/usr/bin/perl
# Run self-checking source fixtures through the native driver.
# Each program must exit successfully and write no stdout, both when built
# directly, through object link paths, and through the supplied LowIR backend.
use strict;
use warnings;
use File::Temp qw(tempdir);
use FindBin;
use Getopt::Long qw(GetOptions);
use lib $FindBin::Bin;
use CppgmBatchWorker qw(app_args_for collect_tests read_word_list resolve_host_command run_command_capture source_args_for);

my $levels = '1,2,3';
die "Usage: check_cppgm_native_programs.pl [--levels=0,2] <cppgm> <test-or-directory> [lowir2native]\n"
	unless GetOptions('levels=s' => \$levels) && $levels =~ /\A[0-3](?:,[0-3])*\z/ && (@ARGV == 2 || @ARGV == 3);
my ($app, $root, $backend) = @ARGV;
# An explicitly named C source exercises the driver's filename inference.
my @tests = -f $root && $root =~ /\.c$/ ? collect_tests($root, qr/\.c$/) : collect_tests($root, qr/\.t$/);
die "No native driver tests found under $root\n" if !@tests;
my @host = resolve_host_command($ENV{CPPGM_HOST_CXX} // $ENV{CXX} // '',
	'g++', 'clang++', 'c++');
die "Unable to resolve host C++ link driver\n" if !@host;
my $checks = 0;
my @routes = qw(direct object native);
push @routes, 'lowir' if defined $backend;
for my $test (@tests)
{
	(my $base = $test) =~ s/\.(?:t|c)$//;
	my @source_args = source_args_for($test);
	my @flags = (app_args_for($app), @source_args ? @source_args : read_word_list("$base.flags"));
	my $directory = tempdir('cppgm-native-program-XXXXXX', TMPDIR => 1, CLEANUP => 1);
	my $stdout = "$directory/stdout";
	my $stderr = "$directory/stderr";
	for my $level (map { "-O$_" } split /,/, $levels)
	{
		for my $route (@routes)
		{
			my $program = "$directory/$route.program";
			my $object = "$directory/$route" . ($route eq 'object' ? '.obj' : '.o');
			my $lowir = "$directory/$route.lowir";
			my @linker = $route eq 'native' ? @host : ($app, $level, @flags);
			unlink($program, $object, $lowir);
			my @commands = $route eq 'lowir'
				? ([$app, '--emit-lowir', $level, @flags, '-o', $lowir, $test],
				   [$backend, $level, '-o', $program, $lowir])
				: $route eq 'direct'
				? ([$app, $level, @flags, '-o', $program, $test])
				: ([$app, $level, @flags, '-c', '-o', $object, $test],
				   [@linker, '-o', $program, $object]);
			for my $command (@commands)
			{
				my $status = run_command_capture(cmd => $command,
					stdout => $stdout, stderr => $stderr, timeout => 60);
				if ($status != 0)
				{
					open(my $log, '<', $stderr) or die "Cannot read $stderr: $!\n";
					local $/;
					die "$test $level $route: compilation/link failed\n" . <$log>;
				}
			}
			die "$test $level $route: no executable produced\n" if !-x $program;
			my $status = run_command_capture(cmd => [$program],
				stdout => $stdout, stderr => $stderr, timeout => 10);
			die "$test $level $route: program failed (status $status)\n" if $status != 0;
			die "$test $level $route: unexpected program stdout\n" if -s $stdout;
			++$checks;
		}
	}
}
print "native driver programs: PASS ($checks/$checks)\n" unless $ENV{CPPGM_REPORT_QUIET};
