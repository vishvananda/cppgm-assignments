target wasm32 1

global @bytes [storage=readonly] = {
  i8 65
  i8 66
  i8 67
  i8 0
}
function @observe(%index : i32) -> i32 {
  block ^entry:
    %base = addr @bytes
    %middle = index inbounds i8 %base, 1
    %element = index inbounds i8 %middle, %index
    %byte = load u8 %element
    %result = convert zext i32 u8 %byte
    return i32 %result
}
