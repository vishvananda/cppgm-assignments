set -eu
if nm "__OBJ1__" | grep -Eq '[[:space:]](rsp|sp)$'; then
    exit 1
fi
echo stack_pointer_has_no_storage 1
