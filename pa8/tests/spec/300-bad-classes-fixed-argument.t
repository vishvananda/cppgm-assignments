declare function @take(%count : i32) -> void [arity=variadic]
function @pass(%pair : obj<16x8>) -> void {
  block ^entry:
    call void @take(1, %pair) [classes=0:sse_integer]
    return void
}
