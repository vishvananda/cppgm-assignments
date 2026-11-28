.functype scale (i64) -> (i64)
.import_module scale, arithmetic
.import_name scale, twice

.section .rodata.pair,"",@
.p2align 3
pair:
  .int64 11
  .int64 21
end_pair:
.size pair, end_pair - pair
.size end_pair, 0

.section .text.observe,"",@
.globl observe
observe:
  .functype observe () -> (i64)
  i64.const pair+8
  i64.load 0
  call scale
  end_function
