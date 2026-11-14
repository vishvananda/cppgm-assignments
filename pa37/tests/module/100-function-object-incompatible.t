target wasm32 1
declare function @before(%value : i64) -> i64 [object=implementation]
function @actual(%value : i32) -> i32 [object=implementation] {
  block ^entry:
    return i32 %value
}
function @observe() -> i32 {
  block ^entry:
    return i32 0
}
