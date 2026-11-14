target wasm32 1

declare function @before(%value : i32) -> i32 [object=implementation, binding=strong]
global @handle : ptr = addr @before
function @actual(%value : i32) -> i32 [object=implementation, binding=strong] {
  block ^entry:
    %answer = binary add i32 %value, 3
    return i32 %answer
}
declare function @after(%value : i32) -> i32 [object=implementation, binding=strong]
function @weak() -> i32 [object=choice, binding=weak, replaceable=yes] {
  block ^entry:
    return i32 1
}
function @strong() -> i32 [object=choice, binding=strong] {
  block ^entry:
    return i32 17
}
function @observe() -> i32 {
  block ^entry:
    %a = call i32 @before(7)
    %f = load ptr @handle
    %b = call i32 %f(9) as (%value : i32) -> i32
    %c = call i32 @after(11)
    %d = call i32 @weak()
    %same = cmp eq ptr @before, @after
    %e = convert trunc i32 i64 %same
    %ab = binary add i32 %a, %b
    %cd = binary add i32 %c, %d
    %abcd = binary add i32 %ab, %cd
    %all = binary add i32 %abcd, %e
    return i32 %all
}
