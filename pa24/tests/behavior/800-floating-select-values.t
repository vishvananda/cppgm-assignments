# A select of floating values under each floating compare (a NaN on each
# side), under an integer condition, under a compare of another width, with
# literal values, with one value twice, with one test read by two selects,
# and with each value still read after the select.
global @nan_bits : i64 = 9221120237041090560

function @lt_f64(%x : f64, %y : f64, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp lt f64 %x, %y
    %r = select f64 %c, %a, %b
    return f64 %r
}

function @le_f64(%x : f64, %y : f64, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp le f64 %x, %y
    %r = select f64 %c, %a, %b
    return f64 %r
}

function @gt_f64(%x : f64, %y : f64, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp gt f64 %x, %y
    %r = select f64 %c, %a, %b
    return f64 %r
}

function @ge_f64(%x : f64, %y : f64, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp ge f64 %x, %y
    %r = select f64 %c, %a, %b
    return f64 %r
}

function @ult_f64(%x : f64, %y : f64, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp ult f64 %x, %y
    %r = select f64 %c, %a, %b
    return f64 %r
}

function @ule_f64(%x : f64, %y : f64, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp ule f64 %x, %y
    %r = select f64 %c, %a, %b
    return f64 %r
}

function @ugt_f64(%x : f64, %y : f64, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp ugt f64 %x, %y
    %r = select f64 %c, %a, %b
    return f64 %r
}

function @uge_f64(%x : f64, %y : f64, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp uge f64 %x, %y
    %r = select f64 %c, %a, %b
    return f64 %r
}

function @eq_f64(%x : f64, %y : f64, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp eq f64 %x, %y
    %r = select f64 %c, %a, %b
    return f64 %r
}

function @ne_f64(%x : f64, %y : f64, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp ne f64 %x, %y
    %r = select f64 %c, %a, %b
    return f64 %r
}

function @lt_f32(%x : f32, %y : f32, %a : f32, %b : f32) -> f32 [no_inline=yes] {
  block ^entry:
    %c = cmp lt f32 %x, %y
    %r = select f32 %c, %a, %b
    return f32 %r
}

function @le_f32(%x : f32, %y : f32, %a : f32, %b : f32) -> f32 [no_inline=yes] {
  block ^entry:
    %c = cmp le f32 %x, %y
    %r = select f32 %c, %a, %b
    return f32 %r
}

function @gt_f32(%x : f32, %y : f32, %a : f32, %b : f32) -> f32 [no_inline=yes] {
  block ^entry:
    %c = cmp gt f32 %x, %y
    %r = select f32 %c, %a, %b
    return f32 %r
}

function @ge_f32(%x : f32, %y : f32, %a : f32, %b : f32) -> f32 [no_inline=yes] {
  block ^entry:
    %c = cmp ge f32 %x, %y
    %r = select f32 %c, %a, %b
    return f32 %r
}

function @ult_f32(%x : f32, %y : f32, %a : f32, %b : f32) -> f32 [no_inline=yes] {
  block ^entry:
    %c = cmp ult f32 %x, %y
    %r = select f32 %c, %a, %b
    return f32 %r
}

function @ule_f32(%x : f32, %y : f32, %a : f32, %b : f32) -> f32 [no_inline=yes] {
  block ^entry:
    %c = cmp ule f32 %x, %y
    %r = select f32 %c, %a, %b
    return f32 %r
}

function @ugt_f32(%x : f32, %y : f32, %a : f32, %b : f32) -> f32 [no_inline=yes] {
  block ^entry:
    %c = cmp ugt f32 %x, %y
    %r = select f32 %c, %a, %b
    return f32 %r
}

function @uge_f32(%x : f32, %y : f32, %a : f32, %b : f32) -> f32 [no_inline=yes] {
  block ^entry:
    %c = cmp uge f32 %x, %y
    %r = select f32 %c, %a, %b
    return f32 %r
}

function @eq_f32(%x : f32, %y : f32, %a : f32, %b : f32) -> f32 [no_inline=yes] {
  block ^entry:
    %c = cmp eq f32 %x, %y
    %r = select f32 %c, %a, %b
    return f32 %r
}

function @ne_f32(%x : f32, %y : f32, %a : f32, %b : f32) -> f32 [no_inline=yes] {
  block ^entry:
    %c = cmp ne f32 %x, %y
    %r = select f32 %c, %a, %b
    return f32 %r
}

# The first value's choices over five operand pairs, as bits.
function @table_f64(%test : ptr, %nan : f64) -> i64 [no_inline=yes] {
  block ^entry:
    %r0 = call f64 %test(1.0, 2.0, 3.0, 5.0) as (%arg0 : f64, %arg1 : f64, %arg2 : f64, %arg3 : f64) -> f64
    %first0 = cmp eq f64 %r0, 3.0
    %bit0 = convert zext i64 i1 %first0
    %shifted0 = binary shl i64 0, 1
    %bits0 = binary or i64 %shifted0, %bit0
    %r1 = call f64 %test(2.0, 1.0, 3.0, 5.0) as (%arg0 : f64, %arg1 : f64, %arg2 : f64, %arg3 : f64) -> f64
    %first1 = cmp eq f64 %r1, 3.0
    %bit1 = convert zext i64 i1 %first1
    %shifted1 = binary shl i64 %bits0, 1
    %bits1 = binary or i64 %shifted1, %bit1
    %r2 = call f64 %test(1.0, 1.0, 3.0, 5.0) as (%arg0 : f64, %arg1 : f64, %arg2 : f64, %arg3 : f64) -> f64
    %first2 = cmp eq f64 %r2, 3.0
    %bit2 = convert zext i64 i1 %first2
    %shifted2 = binary shl i64 %bits1, 1
    %bits2 = binary or i64 %shifted2, %bit2
    %r3 = call f64 %test(%nan, 1.0, 3.0, 5.0) as (%arg0 : f64, %arg1 : f64, %arg2 : f64, %arg3 : f64) -> f64
    %first3 = cmp eq f64 %r3, 3.0
    %bit3 = convert zext i64 i1 %first3
    %shifted3 = binary shl i64 %bits2, 1
    %bits3 = binary or i64 %shifted3, %bit3
    %r4 = call f64 %test(1.0, %nan, 3.0, 5.0) as (%arg0 : f64, %arg1 : f64, %arg2 : f64, %arg3 : f64) -> f64
    %first4 = cmp eq f64 %r4, 3.0
    %bit4 = convert zext i64 i1 %first4
    %shifted4 = binary shl i64 %bits3, 1
    %bits4 = binary or i64 %shifted4, %bit4
    return i64 %bits4
}

# The first value's choices over five operand pairs, as bits.
function @table_f32(%test : ptr, %nan : f32) -> i64 [no_inline=yes] {
  block ^entry:
    %r0 = call f32 %test(1.0f, 2.0f, 3.0f, 5.0f) as (%arg0 : f32, %arg1 : f32, %arg2 : f32, %arg3 : f32) -> f32
    %first0 = cmp eq f32 %r0, 3.0f
    %bit0 = convert zext i64 i1 %first0
    %shifted0 = binary shl i64 0, 1
    %bits0 = binary or i64 %shifted0, %bit0
    %r1 = call f32 %test(2.0f, 1.0f, 3.0f, 5.0f) as (%arg0 : f32, %arg1 : f32, %arg2 : f32, %arg3 : f32) -> f32
    %first1 = cmp eq f32 %r1, 3.0f
    %bit1 = convert zext i64 i1 %first1
    %shifted1 = binary shl i64 %bits0, 1
    %bits1 = binary or i64 %shifted1, %bit1
    %r2 = call f32 %test(1.0f, 1.0f, 3.0f, 5.0f) as (%arg0 : f32, %arg1 : f32, %arg2 : f32, %arg3 : f32) -> f32
    %first2 = cmp eq f32 %r2, 3.0f
    %bit2 = convert zext i64 i1 %first2
    %shifted2 = binary shl i64 %bits1, 1
    %bits2 = binary or i64 %shifted2, %bit2
    %r3 = call f32 %test(%nan, 1.0f, 3.0f, 5.0f) as (%arg0 : f32, %arg1 : f32, %arg2 : f32, %arg3 : f32) -> f32
    %first3 = cmp eq f32 %r3, 3.0f
    %bit3 = convert zext i64 i1 %first3
    %shifted3 = binary shl i64 %bits2, 1
    %bits3 = binary or i64 %shifted3, %bit3
    %r4 = call f32 %test(1.0f, %nan, 3.0f, 5.0f) as (%arg0 : f32, %arg1 : f32, %arg2 : f32, %arg3 : f32) -> f32
    %first4 = cmp eq f32 %r4, 3.0f
    %bit4 = convert zext i64 i1 %first4
    %shifted4 = binary shl i64 %bits3, 1
    %bits4 = binary or i64 %shifted4, %bit4
    return i64 %bits4
}

function @by_flag(%flag : i64, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %r = select f64 %flag, %a, %b
    return f64 %r
}

function @by_narrow_test(%x : f32, %y : f32, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp lt f32 %x, %y
    %r = select f64 %c, %a, %b
    return f64 %r
}

function @by_integer_test(%i : i64, %j : i64, %a : f32, %b : f32) -> f32 [no_inline=yes] {
  block ^entry:
    %c = cmp lt i64 %i, %j
    %r = select f32 %c, %a, %b
    return f32 %r
}

function @literals(%x : f64, %y : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp lt f64 %x, %y
    %r = select f64 %c, 3.0, -0.0
    return f64 %r
}

function @one_value(%x : f64, %y : f64, %a : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp lt f64 %x, %y
    %r = select f64 %c, %a, %a
    return f64 %r
}

# 4 * (c ? a : b) + (c ? b : a)
function @two_readers(%x : f64, %y : f64, %a : f64, %b : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %c = cmp lt f64 %x, %y
    %r = select f64 %c, %a, %b
    %s = select f64 %c, %b, %a
    %r4 = binary mul f64 %r, 4.0
    %sum = binary add f64 %r4, %s
    return f64 %sum
}

# t >= lim ? t - lim : t
function @wrap(%t : f64, %lim : f64) -> f64 [no_inline=yes] {
  block ^entry:
    %d = binary sub f64 %t, %lim
    %c = cmp ge f64 %t, %lim
    %r = select f64 %c, %d, %t
    return f64 %r
}

# 16 * (c ? a : b) + 4 * a + b
function @values_read_after(%x : f32, %y : f32, %a : f32, %b : f32) -> f32 [no_inline=yes] {
  block ^entry:
    %c = cmp le f32 %x, %y
    %r = select f32 %c, %a, %b
    %r16 = binary mul f32 %r, 16.0f
    %a4 = binary mul f32 %a, 4.0f
    %s = binary add f32 %r16, %a4
    %sum = binary add f32 %s, %b
    return f32 %sum
}

# The sign of a zero the select chose.
function @zero_sign(%x : f64, %y : f64) -> i64 [no_inline=yes] {
  slot $cell : f64

  block ^entry:
    %r = call f64 @literals(%x, %y)
    %p = addr $cell
    store f64 %r, %p
    %bits = load i64 %p
    %sign = binary ushr i64 %bits, 63
    return i64 %sign
}

function @main() -> i32 [role=entry] {
  block ^entry:
    %cell = addr @nan_bits
    %nan = load f64 %cell
    %nan32 = convert fptrunc f32 f64 %nan
    %v1 = call i64 @table_f64(@lt_f64, %nan)
    %ok2 = cmp eq i64 %v1, 16
    branch %ok2, ^pass1, ^fail1

  block ^fail1:
    return i32 1

  block ^pass1:
    %v3 = call i64 @table_f64(@le_f64, %nan)
    %ok4 = cmp eq i64 %v3, 20
    branch %ok4, ^pass2, ^fail2

  block ^fail2:
    return i32 2

  block ^pass2:
    %v5 = call i64 @table_f64(@gt_f64, %nan)
    %ok6 = cmp eq i64 %v5, 8
    branch %ok6, ^pass3, ^fail3

  block ^fail3:
    return i32 3

  block ^pass3:
    %v7 = call i64 @table_f64(@ge_f64, %nan)
    %ok8 = cmp eq i64 %v7, 12
    branch %ok8, ^pass4, ^fail4

  block ^fail4:
    return i32 4

  block ^pass4:
    %v9 = call i64 @table_f64(@ult_f64, %nan)
    %ok10 = cmp eq i64 %v9, 19
    branch %ok10, ^pass5, ^fail5

  block ^fail5:
    return i32 5

  block ^pass5:
    %v11 = call i64 @table_f64(@ule_f64, %nan)
    %ok12 = cmp eq i64 %v11, 23
    branch %ok12, ^pass6, ^fail6

  block ^fail6:
    return i32 6

  block ^pass6:
    %v13 = call i64 @table_f64(@ugt_f64, %nan)
    %ok14 = cmp eq i64 %v13, 11
    branch %ok14, ^pass7, ^fail7

  block ^fail7:
    return i32 7

  block ^pass7:
    %v15 = call i64 @table_f64(@uge_f64, %nan)
    %ok16 = cmp eq i64 %v15, 15
    branch %ok16, ^pass8, ^fail8

  block ^fail8:
    return i32 8

  block ^pass8:
    %v17 = call i64 @table_f64(@eq_f64, %nan)
    %ok18 = cmp eq i64 %v17, 4
    branch %ok18, ^pass9, ^fail9

  block ^fail9:
    return i32 9

  block ^pass9:
    %v19 = call i64 @table_f64(@ne_f64, %nan)
    %ok20 = cmp eq i64 %v19, 27
    branch %ok20, ^pass10, ^fail10

  block ^fail10:
    return i32 10

  block ^pass10:
    %v21 = call i64 @table_f32(@lt_f32, %nan32)
    %ok22 = cmp eq i64 %v21, 16
    branch %ok22, ^pass11, ^fail11

  block ^fail11:
    return i32 11

  block ^pass11:
    %v23 = call i64 @table_f32(@le_f32, %nan32)
    %ok24 = cmp eq i64 %v23, 20
    branch %ok24, ^pass12, ^fail12

  block ^fail12:
    return i32 12

  block ^pass12:
    %v25 = call i64 @table_f32(@gt_f32, %nan32)
    %ok26 = cmp eq i64 %v25, 8
    branch %ok26, ^pass13, ^fail13

  block ^fail13:
    return i32 13

  block ^pass13:
    %v27 = call i64 @table_f32(@ge_f32, %nan32)
    %ok28 = cmp eq i64 %v27, 12
    branch %ok28, ^pass14, ^fail14

  block ^fail14:
    return i32 14

  block ^pass14:
    %v29 = call i64 @table_f32(@ult_f32, %nan32)
    %ok30 = cmp eq i64 %v29, 19
    branch %ok30, ^pass15, ^fail15

  block ^fail15:
    return i32 15

  block ^pass15:
    %v31 = call i64 @table_f32(@ule_f32, %nan32)
    %ok32 = cmp eq i64 %v31, 23
    branch %ok32, ^pass16, ^fail16

  block ^fail16:
    return i32 16

  block ^pass16:
    %v33 = call i64 @table_f32(@ugt_f32, %nan32)
    %ok34 = cmp eq i64 %v33, 11
    branch %ok34, ^pass17, ^fail17

  block ^fail17:
    return i32 17

  block ^pass17:
    %v35 = call i64 @table_f32(@uge_f32, %nan32)
    %ok36 = cmp eq i64 %v35, 15
    branch %ok36, ^pass18, ^fail18

  block ^fail18:
    return i32 18

  block ^pass18:
    %v37 = call i64 @table_f32(@eq_f32, %nan32)
    %ok38 = cmp eq i64 %v37, 4
    branch %ok38, ^pass19, ^fail19

  block ^fail19:
    return i32 19

  block ^pass19:
    %v39 = call i64 @table_f32(@ne_f32, %nan32)
    %ok40 = cmp eq i64 %v39, 27
    branch %ok40, ^pass20, ^fail20

  block ^fail20:
    return i32 20

  block ^pass20:
    %v41 = call f64 @by_flag(256, 3.0, 5.0)
    %ok42 = cmp eq f64 %v41, 3.0
    branch %ok42, ^pass21, ^fail21

  block ^fail21:
    return i32 21

  block ^pass21:
    %v43 = call f64 @by_flag(0, 3.0, 5.0)
    %ok44 = cmp eq f64 %v43, 5.0
    branch %ok44, ^pass22, ^fail22

  block ^fail22:
    return i32 22

  block ^pass22:
    %v45 = call f64 @by_narrow_test(1.0f, 2.0f, 3.0, 5.0)
    %ok46 = cmp eq f64 %v45, 3.0
    branch %ok46, ^pass23, ^fail23

  block ^fail23:
    return i32 23

  block ^pass23:
    %v47 = call f64 @by_narrow_test(%nan32, 2.0f, 3.0, 5.0)
    %ok48 = cmp eq f64 %v47, 5.0
    branch %ok48, ^pass24, ^fail24

  block ^fail24:
    return i32 24

  block ^pass24:
    %v49 = call f32 @by_integer_test(-1, 0, 3.0f, 5.0f)
    %ok50 = cmp eq f32 %v49, 3.0f
    branch %ok50, ^pass25, ^fail25

  block ^fail25:
    return i32 25

  block ^pass25:
    %v51 = call f32 @by_integer_test(0, -1, 3.0f, 5.0f)
    %ok52 = cmp eq f32 %v51, 5.0f
    branch %ok52, ^pass26, ^fail26

  block ^fail26:
    return i32 26

  block ^pass26:
    %v53 = call f64 @literals(1.0, 2.0)
    %ok54 = cmp eq f64 %v53, 3.0
    branch %ok54, ^pass27, ^fail27

  block ^fail27:
    return i32 27

  block ^pass27:
    %v55 = call i64 @zero_sign(1.0, 2.0)
    %ok56 = cmp eq i64 %v55, 0
    branch %ok56, ^pass28, ^fail28

  block ^fail28:
    return i32 28

  block ^pass28:
    %v57 = call i64 @zero_sign(%nan, 2.0)
    %ok58 = cmp eq i64 %v57, 1
    branch %ok58, ^pass29, ^fail29

  block ^fail29:
    return i32 29

  block ^pass29:
    %v59 = call f64 @one_value(1.0, 2.0, 7.0)
    %ok60 = cmp eq f64 %v59, 7.0
    branch %ok60, ^pass30, ^fail30

  block ^fail30:
    return i32 30

  block ^pass30:
    %v61 = call f64 @two_readers(1.0, 2.0, 3.0, 5.0)
    %ok62 = cmp eq f64 %v61, 17.0
    branch %ok62, ^pass31, ^fail31

  block ^fail31:
    return i32 31

  block ^pass31:
    %v63 = call f64 @two_readers(2.0, 1.0, 3.0, 5.0)
    %ok64 = cmp eq f64 %v63, 23.0
    branch %ok64, ^pass32, ^fail32

  block ^fail32:
    return i32 32

  block ^pass32:
    %v65 = call f64 @wrap(1.25, 1.0)
    %ok66 = cmp eq f64 %v65, 0.25
    branch %ok66, ^pass33, ^fail33

  block ^fail33:
    return i32 33

  block ^pass33:
    %v67 = call f64 @wrap(0.75, 1.0)
    %ok68 = cmp eq f64 %v67, 0.75
    branch %ok68, ^pass34, ^fail34

  block ^fail34:
    return i32 34

  block ^pass34:
    %v69 = call f32 @values_read_after(1.0f, 2.0f, 3.0f, 5.0f)
    %ok70 = cmp eq f32 %v69, 65.0f
    branch %ok70, ^pass35, ^fail35

  block ^fail35:
    return i32 35

  block ^pass35:
    %v71 = call f32 @values_read_after(2.0f, 1.0f, 3.0f, 5.0f)
    %ok72 = cmp eq f32 %v71, 97.0f
    branch %ok72, ^pass36, ^fail36

  block ^fail36:
    return i32 36

  block ^pass36:
    return i32 0
}
