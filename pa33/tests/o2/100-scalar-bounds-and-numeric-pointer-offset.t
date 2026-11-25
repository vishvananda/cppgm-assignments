# The input chooses between two known flag patterns. Both are within the
# bound and omit the high bits. A numeric address plus an even offset is even.
declare function @impossible_value() -> void

function @flags(%enabled : i64) -> i32 {
  block ^entry:
    %value = select i64 %enabled, 1, 0
    %set = binary or i64 %value, 2
    %too_much = cmp ugt i64 %set, 3
    %bad_bits = binary and i64 %set, 4294901760
    %bad = binary or i64 %too_much, %bad_bits
    branch %bad, ^reject, ^report
  block ^reject:
    call void @impossible_value()
    jump ^report
  block ^report:
    %result = convert trunc i32 i64 %set
    return i32 %result
}

function @address_bits() -> i32 {
  block ^entry:
    %address = index i8 256, -2401263026318606336
    %bits = copy i64 %address
    %odd = binary and i64 %bits, 1
    branch %odd, ^reject, ^report
  block ^reject:
    call void @impossible_value()
    jump ^report
  block ^report:
    return i32 8
}
