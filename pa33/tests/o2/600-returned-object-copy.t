global @published : ptr = 0

function @capture(%p : ptr) -> void [no_inline=yes] {
  block ^entry:
    store ptr %p, @published
    return void
}

# Returning the value does not publish its local storage's address.
function @returned_value(%source : ptr) -> obj<8x4> [no_inline=yes] {
  slot $out : obj<8x4>
  block ^entry:
    %destination = addr $out
    %a = load u32 %source
    %next = index u32 %source, 1
    %b = load u32 %next
    store u32 %a, %destination
    %high = index i8 %destination, 4
    store u32 %b, %high
    return obj<8x4> $out
}

# A captured address remains exposed even when the object is returned.
function @captured_value(%source : ptr) -> obj<8x4> [no_inline=yes] {
  slot $out : obj<8x4>
  block ^entry:
    %destination = addr $out
    call void @capture(%destination)
    %a = load u32 %source
    %next = index u32 %source, 1
    %b = load u32 %next
    store u32 %a, %destination
    %high = index i8 %destination, 4
    store u32 %b, %high
    return obj<8x4> $out
}

function @returned_address(%source : ptr) -> ptr [no_inline=yes] {
  slot $out : obj<8x4>
  block ^entry:
    %destination = addr $out
    %a = load u32 %source
    %next = index u32 %source, 1
    %b = load u32 %next
    store u32 %a, %destination
    %high = index i8 %destination, 4
    store u32 %b, %high
    return ptr %destination
}

function @volatile_value(%source : ptr) -> obj<8x4> [no_inline=yes] {
  slot $out : obj<8x4>
  block ^entry:
    %destination = addr $out
    %a = load volatile u32 %source
    %next = index u32 %source, 1
    %b = load volatile u32 %next
    store u32 %a, %destination
    %high = index i8 %destination, 4
    store u32 %b, %high
    return obj<8x4> $out
}

function @observed_frame(%source : ptr) -> obj<8x4> [no_inline=yes] {
  slot $out : obj<8x4>
  block ^entry:
    %frame = frame_address
    call void @capture(%frame)
    %destination = addr $out
    %a = load u32 %source
    %next = index u32 %source, 1
    %b = load u32 %next
    store u32 %a, %destination
    %high = index i8 %destination, 4
    store u32 %b, %high
    return obj<8x4> $out
}

function @main() -> i32 [role=entry] {
  slot $source : obj<8x4>
  slot $copy : obj<8x4>

  block ^entry:
    %s = addr $source
    store u32 17, %s
    %s1 = index u32 %s, 1
    store u32 29, %s1
    %c = addr $copy
    %c1 = index u32 %c, 1
    %v1 = call obj<8x4> @returned_value(%s)
    store obj<8x4> %v1, %c
    %a1 = load u32 %c
    %b1 = load u32 %c1
    %v2 = call obj<8x4> @captured_value(%s)
    store obj<8x4> %v2, %c
    %a2 = load u32 %c
    %b2 = load u32 %c1
    %v3 = call obj<8x4> @volatile_value(%s)
    store obj<8x4> %v3, %c
    %a3 = load u32 %c
    %b3 = load u32 %c1
    %v4 = call obj<8x4> @observed_frame(%s)
    store obj<8x4> %v4, %c
    %a4 = load u32 %c
    %b4 = load u32 %c1
    %a12 = binary add u32 %a1, %a2
    %a34 = binary add u32 %a3, %a4
    %as = binary add u32 %a12, %a34
    %b12 = binary add u32 %b1, %b2
    %b34 = binary add u32 %b3, %b4
    %bs = binary add u32 %b12, %b34
    %da = binary xor u32 %as, 68
    %db = binary xor u32 %bs, 116
    %all = binary or u32 %da, %db
    %bad = cmp ne u32 %all, 0
    %out = convert zext i32 i1 %bad
    return i32 %out
}
