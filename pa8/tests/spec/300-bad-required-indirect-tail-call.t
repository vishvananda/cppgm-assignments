function @transfer(%frame : ptr) -> void {
  block ^entry:
    %0 = load ptr %frame
    call tail void %0(%frame) as (%arg0 : ptr) -> void
    call void %0(%frame) as (%arg0 : ptr) -> void
    return void
}
