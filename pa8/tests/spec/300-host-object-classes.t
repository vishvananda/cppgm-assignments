# The classes of host objects (lowir.md "Object ABI Conventions"): x87 and
# complex x87 results, SSEUP halves of 16-byte SSE values, memory for
# results and for objects larger than 16 bytes, and the classes of arguments
# to `...` and of va_arg results.
declare function @extended() -> obj<16x16> [result_classes=x87]
declare function @complex(%x : obj<32x16> [classes=memory]) -> obj<32x16> [result_classes=complex_x87]
declare function @quad(%x : obj<16x16> [classes=sse_sseup]) -> obj<16x16> [result_classes=sse_sseup]
declare function @lanes(%x : v128 [classes=sse_sseup]) -> v128 [result_classes=sse_sseup]
declare function @wide(%x : obj<32x32> [classes=memory]) -> obj<32x32> [result_classes=memory]
declare function @take(%count : i32) -> void [arity=variadic]
function @pass(%pair : obj<16x8> [classes=sse_integer], %extended : obj<16x16> [classes=memory], %big : obj<48x8> [classes=memory]) -> void {
  block ^entry:
    call void @take(3, %pair, %extended, %big) [classes=1:sse_integer, classes=2:x87, classes=3:memory]
    return void
}
function @read(%count : i32) -> void [arity=variadic] {
  slot $list : obj<24x8>
  block ^entry:
    %list = addr $list
    va_start %list
    %pair = va_arg obj<16x8> %list [classes=sse_integer]
    %extended = va_arg obj<16x16> %list [classes=x87]
    %value = va_arg f80 %list
    %wide = va_arg i128 %list
    %big = va_arg obj<48x8> %list [classes=memory]
    return void
}
