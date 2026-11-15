# A packed shift whose count vector is built from a constant takes the constant
# as an immediate count. A count of the lane width or more keeps its meaning:
# zero for a logical shift, the sign fill for an arithmetic one. @variable
# keeps its count operand.
function @logical(%value : v128) -> v128 {
  block ^entry:
    %count = vector fromi32 4
    %answer = vector psrlw %value, %count
    return v128 %answer
}
function @zero(%value : v128) -> v128 {
  block ^entry:
    %count = vector fromi64 64
    %answer = vector psllq %value, %count
    return v128 %answer
}
function @signed(%value : v128) -> v128 {
  block ^entry:
    %count = vector fromi32 -1
    %answer = vector psraw %value, %count
    return v128 %answer
}
function @variable(%value : v128, %count : v128) -> v128 {
  block ^entry:
    %answer = vector psrld %value, %count
    return v128 %answer
}
