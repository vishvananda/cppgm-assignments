# %b is computed before the try and read in the loop and after it. ^head
# is reached from ^caught as well as from the end of ^guarded, so %b stays
# before the call that enters ^caught.
declare function @may_throw(%x : i64) -> i64
declare function @note(%x : i64) -> void [unwind=no]

function @f(%a : i64, %n : i64) -> i64 {
  block ^entry:
    %b = binary add i64 %a, 65
    %warm = cmp ne i64 %n, 0
    branch %warm, ^noted, ^guarded

  block ^noted:
    call void @note(%n)
    jump ^guarded

  block ^guarded:
    eh_try ^caught
    %r = call i64 @may_throw(%a)
    eh_end
    jump ^head

  block ^caught:
    %e = exception i64
    jump ^head

  block ^head:
    %i = phi i64 [^guarded: 0, ^caught: 0, ^body: %i2]
    %s = phi i64 [^guarded: %r, ^caught: %e, ^body: %s2]
    %more = cmp ult i64 %i, %n
    branch %more, ^body, ^exit

  block ^body:
    %s2 = binary add i64 %s, %b
    %i2 = binary add i64 %i, 1
    jump ^head

  block ^exit:
    %out = binary xor i64 %s, %b
    return i64 %out
}
