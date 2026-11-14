function @f(%c : i64, %a : f80, %b : f80) -> f80 {
  block ^entry:
    %v = select f80 %c, %a, %b
    return f80 %v
}
