target wasm32 1
global @a : i32 [object=shared, binding=strong] = 3
global @b : i32 [object=shared, binding=strong] = 5
function @observe() -> i32 {
  block ^entry:
    %value = load i32 @a
    return i32 %value
}
