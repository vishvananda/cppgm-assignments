target wasm32 1
declare global @view : i32 [binding=strong]
global @storage : i32 [binding=internal, object_root=yes] = 5
function @observe() -> i32 [binding=strong] {
  block ^entry:
    store typed i32 9, @view
    %value = load typed i32 @storage
    return i32 %value
}
alias object view = @storage
