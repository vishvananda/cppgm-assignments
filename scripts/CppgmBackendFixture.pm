package CppgmBackendFixture;

use strict;
use warnings;
use Exporter 'import';
use File::Basename qw(dirname);
use File::Spec;
use JSON::PP qw(decode_json);
use CppgmBatchWorker qw(collect_tests);

our @EXPORT_OK = qw(backend_tests backend_expectation fixture_units read_bytes check_bounds);

sub read_bytes {
    my ($path) = @_;
    open(my $file, '<:raw', $path) or die "read $path: $!\n";
    local $/;
    return <$file> // '';
}

sub sidecar {
    my ($test, $target) = @_;
    $test =~ s/\.t\z/.$target-expect/ or die "expected a .t input: $test\n";
    return $test;
}

sub backend_tests {
    my ($target, @paths) = @_;
    return grep { -f sidecar($_, $target) } map { collect_tests($_, qr/\.t\z/) } @paths;
}

sub backend_expectation {
    my ($test, $target) = @_;
    return decode_json(read_bytes(sidecar($test, $target)));
}

sub fixture_units {
    my ($test, $expect) = @_;
    return map { File::Spec->catfile(dirname($test), $_) } @{$expect->{units} // []};
}

sub check_bounds {
    my ($actual, $bounds, $where, $backend) = @_;
    for my $metric (sort keys %$bounds) {
        die "Unknown $backend quality metric $metric\n" unless exists $actual->{$metric};
        my $limit = $bounds->{$metric};
        die "Invalid $backend quality bound $metric\n" unless defined($limit) && $limit =~ /^\d+$/;
        die "$where $metric $actual->{$metric} exceeds $limit\n" if $actual->{$metric} > $limit;
    }
}

1;
