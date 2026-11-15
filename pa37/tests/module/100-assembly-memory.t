#define PTR i32
.globl observe
.functype source () -> (PTR)
.functype destination () -> (PTR)
.functype checksum () -> (PTR)
copy:
  .functype copy (PTR, PTR, PTR) -> (PTR)
  local.get 2
  if
    local.get 0
    local.get 1
    local.get 2
    memory.copy 0, 0
  end_if
  local.get 0
  end_function
observe:
  .functype observe () -> (PTR)
  # Zero-length memcpy may take a pointer beyond the memory's bounds.
  PTR.const -1
  PTR.const -1
  PTR.const 0
  call copy
  drop
  call destination
  call source
  PTR.const 4
  call copy
  drop
  call checksum
  end_function
.section .custom_section.target_features,"",@
.int8 1
.int8 43
.int8 11
.ascii "bulk-memory"
