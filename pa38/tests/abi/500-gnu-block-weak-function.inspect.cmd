set -eu
readelf --wide --syms "__OBJ1__" | perl -ane '
    BEGIN { %want = map { $_ => 1 } qw(optional_driver available_driver); }
    if (@F >= 8 && delete $want{$F[7]}) {
        die "$F[7]: expected WEAK HIDDEN UND, got @F[4..6]\n" unless "@F[4..6]" eq "WEAK HIDDEN UND";
    }
    END {
        die "missing symbols " . join(", ", sort keys %want) . "\n" if %want;
        print "weak_hidden_functions 2\n";
    }
'
