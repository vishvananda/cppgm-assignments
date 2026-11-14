# C non-local control saves this activation, even when a tiny body would
# otherwise be an ordinary/once/late inline candidate. Names with C++ linkage
# do not acquire this runtime property from their spelling.
declare function @setjmp(%environment : ptr) -> i32 [linkage=c, binding=strong]
declare function @getcontext(%environment : ptr) -> i32 [linkage=c, binding=strong]
declare function @cpp_setjmp(%environment : ptr) -> i32 [object=setjmp]
function @save(%environment : ptr) -> i32 {
  block ^entry:
    %v = call i32 @setjmp(%environment)
    %adjusted = binary add i32 %v, 3
    return i32 %adjusted
}
function @context(%environment : ptr) -> i32 {
  block ^entry:
    %v = call i32 @getcontext(%environment)
    %adjusted = binary add i32 %v, 3
    return i32 %adjusted
}
function @ordinary(%environment : ptr) -> i32 {
  block ^entry:
    %v = call i32 @cpp_setjmp(%environment)
    %adjusted = binary add i32 %v, 3
    return i32 %adjusted
}
function @main(%environment : ptr) -> i32 [role=entry] {
  block ^entry:
    %a = call i32 @save(%environment)
    %b = call i32 @context(%environment)
    %c = call i32 @ordinary(%environment)
    %ab = binary add i32 %a, %b
    %result = binary add i32 %ab, %c
    return i32 %result
}
