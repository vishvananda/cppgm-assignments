declare function @unexpected() -> void

function @bit_switch(%value : i32) -> i32 {
  block ^entry:
    %masked = binary and i32 %value, 2
    switch %masked, ^other, 0:^zero, 2:^one

  block ^zero:
    return i32 11

  block ^one:
    return i32 27

  block ^other:
    call void @unexpected()
    return i32 0
}

function @known_sign(%left : u16, %right : u16) -> i64 {
  block ^entry:
    %a = convert zext i32 u16 %left
    %b = convert zext i32 u16 %right
    %sum = binary add i32 %a, %b
    %wide = convert sext i64 i32 %sum
    %test = cmp ge i64 %wide, 0
    return i64 %test
}

function @known_nonzero(%value : i32) -> i64 {
  block ^entry:
    %truth = cmp eq i32 %value, 0
    %narrow = convert trunc i32 i64 %truth
    %biased = binary add i32 %narrow, 2
    %masked = binary and i32 %biased, 3
    %test = cmp ne i32 %masked, 0
    return i64 %test
}

function @main() -> i32 [role=entry] {
  block ^entry:
    return i32 0
}
