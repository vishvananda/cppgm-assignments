target wasm32 1

function @observe() -> i64 {
  block ^entry:
    %before = memory_size
    %query = memory_grow 0
    %previous = memory_grow 1
    %unused = memory_grow 1
    %after = memory_size
    %expected = binary add u32 %before, 2
    %failed = memory_grow 4294967295
    %unchanged = memory_size
    %a = cmp eq u32 %before, %query
    %b = cmp eq u32 %before, %previous
    %c = cmp eq u32 %after, %expected
    %d = cmp eq u32 %failed, 4294967295
    %e = cmp eq u32 %after, %unchanged
    %ab = binary and i64 %a, %b
    %cd = binary and i64 %c, %d
    %abcd = binary and i64 %ab, %cd
    %all = binary and i64 %abcd, %e
    return i64 %all
}
