# Some SDK headers give errno a direct thread-local declaration. The object
# symbol can differ from the LowIR name used for the declaration.
declare global @error_cell : i32 [storage=thread_local, linkage=c, binding=strong, object=errno]
declare function @sin(%angle : f64) -> f64 [linkage=c, binding=strong, object=sin]

function @read_named(%angle : f64) -> i32 [binding=strong, no_inline=yes] {
  block ^entry:
    store typed i32 1, @error_cell
    %sine = call f64 @sin(%angle)
    %error = load typed i32 @error_cell
    return i32 %error
}

function @read_named_byte(%angle : f64) -> u8 [binding=strong, no_inline=yes] {
  block ^entry:
    store typed i32 0, @error_cell
    %sine = call f64 @sin(%angle)
    %error = load u8 @error_cell
    return u8 %error
}

function @read_opaque_byte(%cell : ptr, %angle : f64) -> u8 [binding=strong, no_inline=yes] {
  block ^entry:
    %before = load u8 %cell
    %sine = call f64 @sin(%angle)
    %after = load u8 %cell
    %change = binary sub u8 %after, %before
    return u8 %change
}
