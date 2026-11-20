set -eu
set -- "__OBJ1__"
depfile=${1%.*}.d
perl -0777 -ne '
    s/\\\n[ \t]*/ /g;
    my ($header) = /^dependency-test\.o:[ \t]+\S+\.t\.1[ \t]+(\S+\/local\.h)[ \t]*$/m;
    die "missing make rule or phony header rule\n"
        unless defined($header) && /^\Q$header\E:\s*$/m;
    print "dependency_file_and_phony_header 1\n";
' -- "$depfile"
rm -- "$depfile"
