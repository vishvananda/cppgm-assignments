# One-past addresses preserve the byte distance from both local objects.
# A signed displacement and runtime index retain their original frame base.
# The two calls use different stack positions to exercise realignment.
function @check_distance(%begin : ptr, %end : ptr, %size : i64) -> i64 {
  block ^entry:
    %expected = index inbounds i8 %begin, %size
    %same = cmp eq ptr %expected, %end
    return i64 %same
}

function @check_objects(%spacing : ptr, %position : i64) -> i32 {
  slot $aligned : obj<64x64>
  slot $array : obj<16x8>

  block ^entry:
    %aligned_base = addr $aligned
    %aligned_end = index inbounds i8 %aligned_base, 64
    %aligned_begin = addr $aligned
    %aligned_correct = call i64 @check_distance(%aligned_begin, %aligned_end, 64)
    branch %aligned_correct, ^ordinary, ^bad

  block ^ordinary:
    %base = addr $array
    %end = index inbounds i8 %base, 16
    %begin = addr $array
    %correct = call i64 @check_distance(%begin, %end, 16)
    branch %correct, ^indexed, ^bad

  block ^indexed:
    %origin = addr $aligned
    %shifted = index i8 %origin, -1
    %indexed = index i8 %shifted, %position
    %expected = addr $aligned
    %same = call i64 @check_distance(%expected, %indexed, 0)
    branch %same, ^good, ^bad

  block ^good:
    return i32 0

  block ^bad:
    return i32 1
}

function @main() -> i32 [role=entry] {
  block ^entry:
    %first_space = stack_alloc 16
    %first = call i32 @check_objects(%first_space, 1)
    %spacing = stack_alloc 16
    %second = call i32 @check_objects(%spacing, 1)
    %failed = binary or i32 %first, %second
    return i32 %failed
}
