# The loop reaches the dispatch with a state of two or three. Carrying the
# same state along a back edge does not introduce the zero state.
declare function @impossible_state() -> void

function @dispatch(%retry : i64) -> i32 {
  block ^entry:
    jump ^loop
  block ^loop:
    %state = phi u32 [^entry: 3, ^again: 2, ^bad: %state]
    switch %state, ^check, 0:^bad, 2:^done, 3:^check
  block ^check:
    branch %retry, ^again, ^done
  block ^again:
    jump ^loop
  block ^bad:
    call void @impossible_state()
    jump ^loop
  block ^done:
    %result = copy i32 %state
    return i32 %result
}
