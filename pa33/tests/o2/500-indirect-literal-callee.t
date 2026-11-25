function @indirect_literal() -> void [linkage=c, binding=strong] {
  block ^entry:
    %callee = copy ptr 0
    call void %callee() as () -> void
    return void
}

function @main() -> i32 [role=entry, binding=strong, keep_alias=yes] {
  block ^entry:
    return i32 0
}
