# lowir.md "Object ABI Conventions": each class a host object's boundary
# states places the value where an equivalent form does. Each check calls
# through a pointer whose call signature, or a va_arg, states the other
# form, so a misplaced value fails; main returns the number of failed checks.

global @low : f64 = 0.0
global @wide = {
  i64 1
  i64 2
  i64 3
  i64 4
  i64 5
  i64 6
}

# x87: one long double, returned in st0 as an f80 result is.
function @x87_result(%v : f80) -> obj<16x16> [result_classes=x87, no_inline=yes] {
  slot $home : obj<16x16>
  block ^entry:
    %home = addr $home
    store f80 %v, %home
    return obj<16x16> $home
}

function @f80_result() -> f80 [no_inline=yes] {
  block ^entry:
    return f80 2.25L
}

# complex_x87: the real part in st0, the imaginary part in st1.
function @complex_result(%re : f80, %im : f80) -> obj<32x16> [result_classes=complex_x87, no_inline=yes] {
  slot $home : obj<32x16>
  block ^entry:
    %home = addr $home
    store f80 %re, %home
    %high = index i8 [projection=field] %home, 16
    store f80 %im, %high
    return obj<32x16> $home
}

# memory: returned through the hidden destination, as an indirect_result
# parameter's caller passes it.
function @memory_result(%a : i64, %b : i64) -> obj<16x8> [result_classes=memory, no_inline=yes] {
  slot $home : obj<16x8>
  block ^entry:
    %home = addr $home
    store i64 %a, %home
    %high = index i8 [projection=field] %home, 8
    store i64 %b, %high
    return obj<16x8> $home
}

# sse_sseup: the whole object in one XMM register, so the f64 after it
# takes the next one.
function @sseup_argument(%x : obj<16x16> [classes=sse_sseup], %y : f64) -> f64 [no_inline=yes] {
  slot $home : obj<16x16>
  block ^entry:
    %home = addr $home
    copyobj 16x16 %x, %home
    %first = load f64 %home
    store f64 %first, @low
    return f64 %y
}

function @sseup_result(%a : i64, %b : i64) -> obj<16x16> [result_classes=sse_sseup, no_inline=yes] {
  slot $home : obj<16x16>
  block ^entry:
    %home = addr $home
    store i64 %a, %home
    %high = index i8 [projection=field] %home, 8
    store i64 %b, %high
    return obj<16x16> $home
}

# Arguments past the fixed parameters: 1 when the values read are 0.5 and 7.
function @read_scalars(%n : i32) -> i32 [arity=variadic, no_inline=yes] {
  slot $list : obj<24x8>
  block ^entry:
    %list = addr $list
    va_start %list
    %d = va_arg f64 %list
    %i = va_arg i64 %list
    %d_ok = cmp eq f64 %d, 0.5
    %i_ok = cmp eq i64 %i, 7
    %both = binary and i1 %d_ok, %i_ok
    %result = convert zext i32 i1 %both
    return i32 %result
}

function @read_pair(%n : i32) -> i32 [arity=variadic, no_inline=yes] {
  slot $list : obj<24x8>
  slot $home : obj<16x8>
  block ^entry:
    %list = addr $list
    va_start %list
    %pair = va_arg obj<16x8> %list [classes=sse_integer]
    %home = addr $home
    copyobj 16x8 %pair, %home
    %d = load f64 %home
    %high = index i8 [projection=field] %home, 8
    %i = load i64 %high
    %d_ok = cmp eq f64 %d, 0.5
    %i_ok = cmp eq i64 %i, 7
    %both = binary and i1 %d_ok, %i_ok
    %result = convert zext i32 i1 %both
    return i32 %result
}

function @read_f80(%n : i32) -> i32 [arity=variadic, no_inline=yes] {
  slot $list : obj<24x8>
  block ^entry:
    %list = addr $list
    va_start %list
    %v = va_arg f80 %list
    %ok = cmp eq f80 %v, 1.25L
    %result = convert zext i32 i1 %ok
    return i32 %result
}

function @read_x87(%n : i32) -> i32 [arity=variadic, no_inline=yes] {
  slot $list : obj<24x8>
  slot $home : obj<16x16>
  block ^entry:
    %list = addr $list
    va_start %list
    %object = va_arg obj<16x16> %list [classes=x87]
    %home = addr $home
    copyobj 16x16 %object, %home
    %v = load f80 %home
    %ok = cmp eq f80 %v, 1.25L
    %result = convert zext i32 i1 %ok
    return i32 %result
}

# The sum of a 48-byte object's six fields, passed in memory.
function @read_memory(%n : i32) -> i64 [arity=variadic, no_inline=yes] {
  slot $list : obj<24x8>
  slot $home : obj<48x8>
  block ^entry:
    %list = addr $list
    va_start %list
    %object = va_arg obj<48x8> %list [classes=memory]
    %home = addr $home
    copyobj 48x8 %object, %home
    %f0 = load i64 %home
    %p1 = index i64 %home, 1
    %f1 = load i64 %p1
    %p5 = index i64 %home, 5
    %f5 = load i64 %p5
    %s1 = binary add i64 %f0, %f1
    %s2 = binary add i64 %s1, %f5
    return i64 %s2
}

# An i128 past the fixed parameters takes the next two GPRs, as two i64
# values do.
function @read_i128(%n : i32) -> i128 [arity=variadic, no_inline=yes] {
  slot $list : obj<24x8>
  block ^entry:
    %list = addr $list
    va_start %list
    %v = va_arg i128 %list
    return i128 %v
}

function @main() -> i32 [role=entry] {
  slot $out : obj<16x16>
  slot $complex : obj<32x16>
  slot $pair : obj<16x8>
  slot $quad : obj<16x16>
  slot $extended : obj<16x16>
  block ^entry:
    %x87p = addr @x87_result
    %r0 = call f80 %x87p(1.5L) as (%v : f80) -> f80
    %ok0 = cmp eq f80 %r0, 1.5L
    %e0 = select i32 %ok0, 0, 1

    %f80p = addr @f80_result
    %r1 = call obj<16x16> %f80p() as () -> obj<16x16> [result_classes=x87]
    %out = addr $out
    copyobj 16x16 %r1, %out
    %v1 = load f80 %out
    %ok1 = cmp eq f80 %v1, 2.25L
    %e1 = select i32 %ok1, 0, 1

    %r2 = call obj<32x16> @complex_result(0.5L, 4.0L)
    %complex = addr $complex
    copyobj 32x16 %r2, %complex
    %re = load f80 %complex
    %imp = index i8 [projection=field] %complex, 16
    %im = load f80 %imp
    %re_ok = cmp eq f80 %re, 0.5L
    %im_ok = cmp eq f80 %im, 4.0L
    %ok2 = binary and i1 %re_ok, %im_ok
    %e2 = select i32 %ok2, 0, 1

    %memp = addr @memory_result
    %pair = addr $pair
    call void %memp(%pair, 11, 12) as (%ret : ptr [pass=indirect_result], %a : i64, %b : i64) -> void
    %a3 = load i64 %pair
    %b3p = index i8 [projection=field] %pair, 8
    %b3 = load i64 %b3p
    %a3_ok = cmp eq i64 %a3, 11
    %b3_ok = cmp eq i64 %b3, 12
    %ok3 = binary and i1 %a3_ok, %b3_ok
    %e3 = select i32 %ok3, 0, 1

    %ssep = addr @sseup_argument
    %r4 = call f64 %ssep(1.5, 2.5) as (%a : f64, %b : f64) -> f64
    %first4 = load f64 @low
    %y4_ok = cmp eq f64 %r4, 2.5
    %x4_ok = cmp eq f64 %first4, 1.5
    %ok4 = binary and i1 %y4_ok, %x4_ok
    %e4 = select i32 %ok4, 0, 1

    %r5 = call obj<16x16> @sseup_result(21, 22)
    %quad = addr $quad
    copyobj 16x16 %r5, %quad
    %a5 = load i64 %quad
    %b5p = index i8 [projection=field] %quad, 8
    %b5 = load i64 %b5p
    %a5_ok = cmp eq i64 %a5, 21
    %b5_ok = cmp eq i64 %b5, 22
    %ok5 = binary and i1 %a5_ok, %b5_ok
    %e5 = select i32 %ok5, 0, 1

    store f64 0.5, %pair
    store i64 7, %b3p
    %pv = load obj<16x8> %pair
    %r6 = call i32 @read_scalars(1, %pv) [classes=1:sse_integer]
    %ok6 = cmp eq i32 %r6, 1
    %e6 = select i32 %ok6, 0, 1

    %r7 = call i32 @read_pair(1, 0.5, 7)
    %ok7 = cmp eq i32 %r7, 1
    %e7 = select i32 %ok7, 0, 1

    %extended = addr $extended
    store f80 1.25L, %extended
    %xv = load obj<16x16> %extended
    %r8 = call i32 @read_f80(1, %xv) [classes=1:x87]
    %ok8 = cmp eq i32 %r8, 1
    %e8 = select i32 %ok8, 0, 1

    %r9 = call i32 @read_x87(1, 1.25L)
    %ok9 = cmp eq i32 %r9, 1
    %e9 = select i32 %ok9, 0, 1

    %wv = load obj<48x8> @wide
    %r10 = call i64 @read_memory(1, %wv) [classes=1:memory]
    %ok10 = cmp eq i64 %r10, 9
    %e10 = select i32 %ok10, 0, 1

    %r11 = call i128 @read_i128(1, 5, 6)
    %expected = const i128 110680464442257309701
    %ok11 = cmp eq i128 %r11, %expected
    %e11 = select i32 %ok11, 0, 1

    %m1 = binary add i32 %e0, %e1
    %m2 = binary add i32 %m1, %e2
    %m3 = binary add i32 %m2, %e3
    %m4 = binary add i32 %m3, %e4
    %m5 = binary add i32 %m4, %e5
    %m6 = binary add i32 %m5, %e6
    %m7 = binary add i32 %m6, %e7
    %m8 = binary add i32 %m7, %e8
    %m9 = binary add i32 %m8, %e9
    %m10 = binary add i32 %m9, %e10
    %m11 = binary add i32 %m10, %e11
    return i32 %m11
}
