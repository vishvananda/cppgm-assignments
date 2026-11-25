assembly @pointer_value att none 14 0 7 2 {
  operand u32 -1 0 2 0 0 {
    alternative 1 0 -1 {
      group (rax:0)
    }
  }
  operand ptr 1 -1 1 0 0 {
    alternative 4 0 -1 {
      range 0 0 0 0 4294967295 0
    }
  }
  text "movl $"
  use 1 1 0 0
  text ", "
  use 0 0 0 0
}

function @immediate_address() -> u32 [linkage=c, binding=strong] {
  slot $result : u32

  block ^entry:
    %result = addr $result
    asm @pointer_value(%result, 512)
    %value = load u32 $result
    return u32 %value
}
