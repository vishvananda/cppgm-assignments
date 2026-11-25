set -eu
readelf -Wr "__OBJ1__" | grep -Eq 'R_X86_64_(PLT32|PC32).*__x86_indirect_thunk_'
echo external_indirect_branch_thunk 1
