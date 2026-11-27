declare function @asm_sqrt_double(%value : f64, %offset : ptr) -> f64
assembly @sqrt_double_body intel read 1 0 0 0 {
 text "// A comment before the first instruction\nsqrtsd xmm0, xmm0 // scalar register input\naddsd xmm0, qword ptr [rdi]\nret"
}
assembly_function @asm_sqrt_double {
 block ^entry:
  asm @sqrt_double_body()
  unreachable
}
declare function @asm_sqrt_float(%value : ptr) -> f32
assembly @sqrt_float_body att read 1 0 0 0 {
 text "sqrtss (%rdi), %xmm0 // scalar memory input\nret"
}
assembly_function @asm_sqrt_float {
 block ^entry:
  asm @sqrt_float_body()
  unreachable
}
declare function @asm_x87_sum(%value : ptr, %result : ptr) -> void
assembly @x87_sum_body intel readwrite 1 0 0 0 {
 text "fnstcw word ptr [rsp - 2]\nfldcw word ptr [rsp - 2]\nfld qword ptr [rdi]\nfld1\nfxch st(1)\nfadd st(0), st(1)\nfrndint\nfstp qword ptr [rsi]\nfstp st(0)\nret"
}
assembly_function @asm_x87_sum {
 block ^entry:
  asm @x87_sum_body()
  unreachable
}
declare function @asm_comment_text() -> ptr
assembly @comment_text_body intel read 1 0 0 0 {
 text "lea rax, [rip + 1f]\nret\n1: .asciz \"// yes\" // Preserve the slashes in the string."
}
assembly_function @asm_comment_text {
 block ^entry:
  asm @comment_text_body()
  unreachable
}
