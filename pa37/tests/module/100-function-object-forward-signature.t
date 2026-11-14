target wasm32 1
declare function @opaque [object=provided, binding=strong]
declare function @typed(%value : i32) -> i32 [object=provided, binding=weak]
global @handle : ptr = addr @opaque
function @observe() -> i32 {
  block ^entry:
    %function = load ptr @handle
    %result = call i32 %function(11) as (%value : i32) -> i32
    return i32 %result
}
