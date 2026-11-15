#ifndef __ASSEMBLER__
#error assembler mode is required
#endif
#ifdef __cplusplus
#error assembly must use the C preprocessor environment
#endif
#ifndef __wasm__
#error this source requires Wasm
#endif
#define PTR i32
.globl observe
.globaltype state, PTR
.section .globals,"",@
state:
.section .text,"",@
# Constructor order follows the section priority, not the source order.
second:
  .functype second () -> ()
  global.get state
  PTR.const 35
  PTR.add
  global.set state
  end_function
first:
  .functype first () -> ()
  PTR.const 7
  global.set state
  end_function
observe:
  .functype observe () -> (PTR)
  .local PTR
  global.get state
  local.tee 0
  end_function
.section .init_array.2,"",@
.p2align 2
.int32 second
.section .init_array.1,"",@
.p2align 2
.int32 first
