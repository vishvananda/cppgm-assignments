set -eu
objdump -d "__OBJ1__" | grep -Eq '[[:space:]]pause([[:space:]]|$)'
objdump -d "__OBJ1__" | grep -Eq '[[:space:]]lfence([[:space:]]|$)'
if objdump -d "__OBJ1__" | grep -Eq '[[:space:]](callq?|jmpq?)[[:space:]]+\*'; then
    exit 1
fi
echo inline_indirect_branch_thunk 1
