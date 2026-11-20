set -eu
readelf --wide --syms "__OBJ1__" | perl -ane '
    BEGIN {
        %want = (ordinary_value => "HIDDEN", internal_fun => "INTERNAL", exported_fun => "DEFAULT",
            protected_value => "PROTECTED", exported_inline => "DEFAULT", hidden_inline => "HIDDEN",
            _ZN3API5valueE => "DEFAULT", _ZN3API11out_of_lineEv => "DEFAULT",
            _ZN7VariantIiE5valueEv => "DEFAULT", _ZN7VariantIlE5valueEv => "DEFAULT",
            _ZN6SharedIiE12inline_valueEv => "DEFAULT", _ZN6SharedIiE6Nested12inline_valueEv => "DEFAULT");
    }
    if (@F >= 8 && exists $want{$F[7]}) {
        die "$F[7]: wrong visibility $F[5]\n" if $F[5] ne $want{$F[7]};
        delete $want{$F[7]};
    }
    END {
        die "missing symbols " . join(", ", sort keys %want) . "\n" if %want;
        print "symbol_visibility 1\n";
    }
'
