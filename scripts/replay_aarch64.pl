#!/usr/bin/perl
use strict;
use warnings;
use Cwd qw(abs_path);
use Digest::SHA;
use File::Basename qw(dirname);
use File::Find;
use FindBin;
use File::Temp qw(tempdir);
use JSON::PP qw(decode_json);
use lib $FindBin::Bin;
use CppgmBatchWorker qw(run_command_capture);
use CppgmBackendFixture qw(read_bytes);
use Getopt::Long qw(GetOptions);

my $qemu;
GetOptions('qemu=s' => \$qemu) && @ARGV == 1 or die "usage: replay_aarch64.pl [--qemu path] bundle\n";
my $scratch = tempdir(CLEANUP => 1);
my $root = abs_path($ARGV[0]);
my @manifests;
find({no_chdir => 1, wanted => sub {
    push @manifests, $File::Find::name if m{/executions\.tsv$} && -f $_;
}}, $root);
@manifests or die "$root: no PA39 execution manifests\n";
my ($groups, $observations) = (0, 0);
for my $manifest (sort @manifests) {
    open(my $file, '<', $manifest) or die "$manifest: $!";
    my %verified;
    while (<$file>) {
        chomp;
        my ($digest, $expected, $level, $producers, $linker, $json) = split /\t/, $_, 6;
        my $cmd = defined $json ? decode_json($json) : {};
        defined $linker && $digest =~ /^[a-f0-9]{64}$/ && $expected =~ /^\d+$/ && $expected < 256
            or die "$manifest: malformed execution\n";
        my $guest = dirname($manifest) . "/$digest";
        if (!$verified{$digest}++) {
            open(my $image, '<:raw', $guest) or die "$guest: $!";
            Digest::SHA->new(256)->addfile($image)->hexdigest eq $digest or die "$guest: digest mismatch\n";
            chmod 0755, $guest or die "chmod $guest: $!";
        }
        my @runner = defined($qemu) ? ($qemu, '-cpu', 'cortex-a53') : ();
        unlink "$scratch/out", "$scratch/err";
        my $status = run_command_capture(cmd => [@runner, $guest, @{$cmd->{args} // []}], timeout => 30,
            stdout => "$scratch/out", stderr => "$scratch/err");
        $status == $expected && read_bytes("$scratch/out") eq ($cmd->{stdout} // '')
            or die "$manifest $level $producers $linker: status $status (expected $expected) or stdout differs\n";
        ++$observations;
    }
    ++$groups;
}
print "$observations guest executions passed across $groups fixtures\n";
