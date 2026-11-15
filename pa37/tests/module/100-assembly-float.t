.globl observe
observe:
  .functype observe () -> (i32)
  f64.const 0x1p4
  f64.sqrt
  f64.const 10.5
  f64.mul
  i32.trunc_f64_s
  end_function
