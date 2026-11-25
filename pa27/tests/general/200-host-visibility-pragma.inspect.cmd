set -eu
readelf --wide --syms "__OBJ1__" | perl -ane '
    BEGIN {
        %want = (hidden_data => "HIDDEN", outer_hidden => "HIDDEN", hidden_call => "HIDDEN",
            inner_default => "DEFAULT", override_default => "DEFAULT", after_pop => "DEFAULT");
    }
    if (@F >= 8 && exists $want{$F[7]}) {
        die "$F[7]: wrong visibility $F[5]\n" if $F[5] ne $want{$F[7]};
        delete $want{$F[7]};
    }
    END { die "missing symbols " . join(", ", sort keys %want) . "\n" if %want; }
'
if [ "$(uname -m)" = "x86_64" ]; then
    readelf --wide --relocs "__OBJ1__" | perl -ane '
        BEGIN { %want = map { $_ => 1 } qw(hidden_data outer_hidden hidden_call); }
        if (@F >= 5 && exists $want{$F[4]}) {
            die "$F[4]: expected a PC-relative relocation, found $F[2]\n" if $F[2] ne "R_X86_64_PC32";
            $want{$F[4]} = 0;
        }
        END { die "missing PC-relative references\n" if grep { $_ } values %want; }
    '
fi
printf '%s\n' 'pragma_visibility 1'
