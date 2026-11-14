target wasm32 1

declare global @forward : i32 [object=shared, binding=strong]
global @definition : i32 [object=shared, binding=strong] = 7
declare global @after : i32 [object=shared, binding=strong]
global @weak_first : i32 [object=preferred, binding=weak] = 11
global @strong_second : i32 [object=preferred, binding=strong] = 19
global @strong_first : i32 [object=other, binding=strong] = 23
global @weak_second : i32 [object=other, binding=weak] = 29

function @observe() -> i32 {
  block ^entry:
    %a = load i32 @forward
    store i32 13, @after
    %b = load i32 @definition
    %c = load i32 @weak_first
    %d = load i32 @weak_second
    %ab = binary add i32 %a, %b
    %cd = binary add i32 %c, %d
    %sum = binary add i32 %ab, %cd
    return i32 %sum
}
