# One path stores to a field of a private zeroed object and the other does
# not; the address is computed again after the join. The object is promoted:
# the read takes 7 on one edge and the zero of the initialization on the
# other.
function @select(%condition : u8) -> u8 {
  slot $object : obj<8x4>

  block ^entry:
    %initial = addr $object
    zeroinit 8x4 %initial
    branch %condition, ^yes, ^no

  block ^yes:
    %yes_address = index i8 [projection=field] %initial, 4
    store u8 7, %yes_address
    jump ^merge

  block ^no:
    jump ^merge

  block ^merge:
    %base = addr $object
    %address = index i8 [projection=field] %base, 4
    %result = load u8 %address
    return u8 %result
}
