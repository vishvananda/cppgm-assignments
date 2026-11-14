target wasm32 1
function @observe(u64 %pages) -> u32 {
  block ^entry:
    %old = memory_grow %pages
    return u32 %old
}
