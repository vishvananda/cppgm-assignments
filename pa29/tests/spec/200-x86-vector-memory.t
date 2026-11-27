declare function @asm_vector_forms(%destination : ptr, %source : ptr) -> void
assembly @vector_forms_body intel readwrite 1 0 0 0 {
 text "movntss dword ptr [rdi], xmm12\nmovntsd qword ptr [rdi + 8], xmm12\nvmovntdqa xmm7, xmmword ptr [rsi]\nvmovntdqa ymm10, ymmword ptr [rsi + 32]\nvmovntdqa zmm28, zmmword ptr [rsi + 64]\nvmovsh xmm29{k3}, word ptr [rsi + 16]\nvmovsh xmm29{k3}{z}, word ptr [rsi + 18]\nvfmaddss xmm0, xmm1, xmm2, xmm3\nvfmaddsd xmm9, xmm10, qword ptr [rsi], xmm12\nvfmaddsd xmm9, xmm10, xmm11, qword ptr [rsi]\nret"
}
assembly_function @asm_vector_forms {
 block ^entry:
  asm @vector_forms_body()
  unreachable
}
declare function @asm_enclave_instruction() -> void
assembly @enclave_body att none 1 0 0 0 { text "enclu\nret" }
assembly_function @asm_enclave_instruction {
 block ^entry:
  asm @enclave_body()
  unreachable
}
declare function @asm_copy_fill(%destination : ptr, %source : ptr) -> void
assembly @copy_fill_body intel readwrite 1 0 0 0 {
 text "mov ecx, 4\nrep movsb [rdi], [rsi]\nmov al, 33\nmov ecx, 3\nrep stosb byte ptr [rdi], al\nret"
}
assembly_function @asm_copy_fill {
 block ^entry:
  asm @copy_fill_body()
  unreachable
}
declare function @asm_copy_qwords(%destination : ptr, %source : ptr) -> void
assembly @copy_qwords_body att readwrite 1 0 0 0 { text "movl $2, %ecx\nrep movsq (%rsi), (%rdi)\nret" }
assembly_function @asm_copy_qwords {
 block ^entry:
  asm @copy_qwords_body()
  unreachable
}
