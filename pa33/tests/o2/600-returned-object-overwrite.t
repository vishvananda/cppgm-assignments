# Read the updated field when returning the staged object.
function @update(%before : f80, %after : f80) -> obj<16x16> [no_inline=yes] {
  slot $original : obj<16x16>
  slot $staging : obj<16x16>

  block ^entry:
    %first = addr $original
    store typed f80 %before, %first
    %result = addr $staging
    copyobj 16x16 %first, %result
    store typed f80 %after, %result
    return obj<16x16> $staging
}

function @main() -> i32 [role=entry] {
  slot $value : obj<16x16>

  block ^entry:
    %updated = call obj<16x16> @update(2.0L, 5.0L)
    copyobj 16x16 %updated, $value
    %base = addr $value
    %actual = load typed f80 %base
    %wrong = cmp ne f80 %actual, 5.0L
    %status = convert zext i32 u8 %wrong
    return i32 %status
}
