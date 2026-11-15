# The tag is 7 on one edge and %input on the other. The known edge goes
# straight to its case; the other edge still dispatches. %computed is defined
# after the join and is used by the cases: it stays correct on both paths.
function @select(%condition : u8, %input : u8) -> i64 {
  block ^entry:
    branch %condition, ^known, ^unknown

  block ^known:
    jump ^dispatch

  block ^unknown:
    jump ^dispatch

  block ^dispatch:
    %tag = phi u8 [^known: 7, ^unknown: %input]
    %selector = convert zext i64 u8 %tag
    %computed = binary add i64 %selector, 100
    switch %selector, ^fallback, 7:^hit, 9:^other

  block ^hit:
    %result = binary add i64 %computed, 3
    return i64 %result

  block ^other:
    return i64 19

  block ^fallback:
    return i64 23
}
