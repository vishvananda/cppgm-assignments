# Test only the selected bits of an ordinary load, including interior and high windows.
# The entry also sets one bit at a time, inside each window and next to it.
function @high(%p : ptr) -> i32 [no_inline=yes] {
  block ^entry:
    %v = load i64 %p
    %mask = binary and i64 %v, 9223372036854775808
    %b = cmp ne i64 %mask, 0
    branch %b, ^yes, ^no
  block ^yes:
    return i32 1
  block ^no:
    return i32 0
}
function @interior(%p : ptr) -> i32 [no_inline=yes] {
  block ^entry:
    %v = load i64 %p
    %mask = binary and i64 %v, 141836999983104
    %b = cmp ne i64 %mask, 0
    branch %b, ^yes, ^no
  block ^yes:
    return i32 1
  block ^no:
    return i32 0
}
function @wide_holes(%p : ptr) -> i32 [no_inline=yes] {
  block ^entry:
    %v = load i64 %p
    %mask = binary and i64 %v, 65537
    %b = cmp ne i64 %mask, 0
    branch %b, ^yes, ^no
  block ^yes:
    return i32 1
  block ^no:
    return i32 0
}
function @word_high(%p : ptr) -> i32 [no_inline=yes] {
  block ^entry:
    %v = load i64 %p
    %mask = binary and i64 %v, 2147483648
    %b = cmp ne i64 %mask, 0
    branch %b, ^yes, ^no
  block ^yes:
    return i32 1
  block ^no:
    return i32 0
}
function @main() -> i64 [role=entry] {
  slot $data : i64
  block ^entry:
    %p = addr $data
    store i64 -1, %p
    %a0 = call i32 @high(%p)
    %b0 = cmp ne i32 %a0, 1
    %a1 = call i32 @interior(%p)
    %b1 = cmp ne i32 %a1, 1
    %a2 = call i32 @wide_holes(%p)
    %b2 = cmp ne i32 %a2, 1
    %a3 = call i32 @word_high(%p)
    %b3 = cmp ne i32 %a3, 1
    store i64 0, %p
    %z0 = call i32 @high(%p)
    %z1 = call i32 @interior(%p)
    %z2 = call i32 @wide_holes(%p)
    %z3 = call i32 @word_high(%p)
    store i64 -9223372036854775808, %p
    %high_bit63 = call i32 @high(%p)
    %c0 = cmp ne i32 %high_bit63, 1
    %word_bit63 = call i32 @word_high(%p)
    store i64 36028797018963968, %p
    %high_bit55 = call i32 @high(%p)
    store i64 1099511627776, %p
    %interior_bit40 = call i32 @interior(%p)
    %c1 = cmp ne i32 %interior_bit40, 1
    store i64 140737488355328, %p
    %interior_bit47 = call i32 @interior(%p)
    %c2 = cmp ne i32 %interior_bit47, 1
    store i64 281474976710656, %p
    %interior_bit48 = call i32 @interior(%p)
    store i64 549755813888, %p
    %interior_bit39 = call i32 @interior(%p)
    %word_bit39 = call i32 @word_high(%p)
    store i64 65536, %p
    %holes_bit16 = call i32 @wide_holes(%p)
    %c3 = cmp ne i32 %holes_bit16, 1
    store i64 256, %p
    %holes_bit8 = call i32 @wide_holes(%p)
    store i64 2147483648, %p
    %word_bit31 = call i32 @word_high(%p)
    %c4 = cmp ne i32 %word_bit31, 1
    store i64 8388608, %p
    %word_bit23 = call i32 @word_high(%p)
    %r0 = binary or i32 %b0, %b1
    %r1 = binary or i32 %r0, %b2
    %r2 = binary or i32 %r1, %b3
    %r3 = binary or i32 %r2, %z0
    %r4 = binary or i32 %r3, %z1
    %r5 = binary or i32 %r4, %z2
    %r6 = binary or i32 %r5, %z3
    %s0 = binary or i32 %r6, %c0
    %s1 = binary or i32 %s0, %c1
    %s2 = binary or i32 %s1, %c2
    %s3 = binary or i32 %s2, %c3
    %s4 = binary or i32 %s3, %c4
    %s5 = binary or i32 %s4, %word_bit63
    %s6 = binary or i32 %s5, %high_bit55
    %s7 = binary or i32 %s6, %interior_bit48
    %s8 = binary or i32 %s7, %interior_bit39
    %s9 = binary or i32 %s8, %word_bit39
    %s10 = binary or i32 %s9, %holes_bit8
    %s11 = binary or i32 %s10, %word_bit23
    return i64 %s11
}
