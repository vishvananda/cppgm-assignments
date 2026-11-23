# Publish final bytes without a staging copy. The partial overwrite is a control.
function @fallback(%in : ptr [pass=by_address, object_bytes=32], %out : ptr) -> void [no_inline=yes] {
  block ^entry:
    copyobj 32x8 %in, %out
    %last = index i8 %out, 24
    %old = load i64 %last
    %updated = binary add i64 %old, 1
    store i64 %updated, %last
    return void
}

function @publish(%out : ptr, %lo : u32, %hi : u32, %last : i64, %slow : i1) -> i64 [no_inline=yes] {
  slot $record : obj<32x8>
  block ^entry:
    %in = addr $record
    %high = index i8 %in, 4
    %middle0 = index i8 %in, 8
    %middle1 = index i8 %in, 16
    %end = index i8 %in, 24
    store i64 -1, %in
    store i64 37, %middle1
    store i64 19, %middle0
    store i64 %last, %end
    store u32 %lo, %in
    store u32 %hi, %high
    branch unlikely %slow, ^addressed, ^direct
  block ^direct:
    copyobj 32x8 %in, %out
    jump ^finish
  block ^addressed:
    call void @fallback(%in, %out)
    jump ^finish
  block ^finish:
    %at = index i8 %out, 24
    %result = load i64 %at
    %shift = binary add i64 %result, 3
    return i64 %shift
}

function @partial(%out : ptr, %slow : i1) -> void [no_inline=yes] {
  slot $record : obj<32x8>
  block ^entry:
    %in = addr $record
    %middle0 = index i8 %in, 8
    %middle1 = index i8 %in, 16
    %end = index i8 %in, 24
    store i64 4294967296, %in
    store u32 17, %in
    store i64 23, %middle0
    store i64 41, %middle1
    store i64 0, %end
    branch unlikely %slow, ^addressed, ^direct
  block ^direct:
    copyobj 32x8 %in, %out
    return void
  block ^addressed:
    call void @fallback(%in, %out)
    return void
}

function @main() -> i32 [role=entry] {
  slot $result : obj<40x8>
  block ^entry:
    %p = addr $result
    %m0 = index i8 %p, 8
    %m1 = index i8 %p, 16
    %guard = index i8 %p, 32
    store i64 97, %guard
    %fast = call i64 @publish(%p, 7, 2, 11, 0)
    %fast_head = load i64 %p
    %slow = call i64 @publish(%p, 13, 3, 23, 1)
    %slow_head = load i64 %p
    %middle0 = load i64 %m0
    %middle1 = load i64 %m1
    call void @partial(%p, 0)
    %partial = load i64 %p
    %guard_value = load i64 %guard
    %bad0 = cmp ne i64 %fast, 14
    %bad1 = cmp ne i64 %fast_head, 8589934599
    %bad2 = cmp ne i64 %slow, 27
    %bad3 = cmp ne i64 %slow_head, 12884901901
    %bad4 = cmp ne i64 %middle0, 19
    %bad5 = cmp ne i64 %middle1, 37
    %bad6 = cmp ne i64 %partial, 4294967313
    %bad7 = cmp ne i64 %guard_value, 97
    %r0 = binary or i32 %bad0, %bad1
    %r1 = binary or i32 %bad2, %bad3
    %r2 = binary or i32 %bad4, %bad5
    %r3 = binary or i32 %bad6, %bad7
    %r4 = binary or i32 %r0, %r1
    %r5 = binary or i32 %r2, %r3
    %bad = binary or i32 %r4, %r5
    return i32 %bad
}
