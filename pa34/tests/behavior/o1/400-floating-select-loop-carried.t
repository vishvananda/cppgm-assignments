# Both outcomes of a floating choice feed the next loop iteration.
function @choice(%base : f64, %threshold : f64, %step : f64) -> f64 {
  block ^entry:
    jump ^loop
  block ^loop:
    %state = phi f64 [^entry: %base, ^next: %chosen]
    %index = phi i64 [^entry: 0, ^next: %inc]
    %raw = binary add f64 %state, %step
    %test = cmp lt f64 %raw, %threshold
    %chosen = select f64 %test, %threshold, %raw
    %inc = binary add i64 %index, 1
    %again = cmp lt i64 %inc, 2
    branch %again, ^next, ^done
  block ^next:
    jump ^loop
  block ^done:
    return f64 %chosen
}
function @main() -> i32 [role=entry] {
  block ^entry:
    %r = call f64 @choice(2.0, 1.0, 3.0)
    %s = call f64 @choice(2.0, 10.0, -1.0)
    %unexpected_r = cmp ne f64 %r, 8.0
    %unexpected_s = cmp ne f64 %s, 10.0
    %bad = binary or i1 %unexpected_r, %unexpected_s
    %result = convert zext i32 i1 %bad
    return i32 %result
}
