# CPPGM Programming Assignment 40 — i386 Linux backend (experimental)

Add the 32-bit x86 Linux target after PA29, PA33, PA34, and PA38. The
target uses little-endian ELF32 and the i386 System V ABI. The
assignment covers the freestanding integer C and assembly needed by Linux's
32-bit compatibility vDSO and real-mode boot code. Select the target with `--target=i386-linux-gnu` or `-m32`. Use the same data
layout for type checking, LowIR, and object emission. Pointers, `int`,
and `long` are four bytes. `long long` and `double` are eight bytes
with four-byte scalar alignment. `long double` stores an 80-bit x87
value in 12 bytes with four-byte alignment.

### Work through the assignment

1. Emit ELF32 relocatable objects with the integrated x86 assembler. Use
   the existing section, symbol and relocation records. Encode the
   implicit addends in the relocated fields of SHT_REL sections. Check
   absolute addresses and calls with an independent ELF i386 linker.
2. Use the existing C frontend and LowIR pipeline. Configure x86
   selection, register allocation, spill slots, and frame layout for
   the i386 register set and ABI. Start with integer leaf functions
   and stack arguments. Add calls, callee saves, 64-bit integer
   operations, variadic arguments, and aggregate passing. Verify calls
   across separately compiled objects in both directions. GCC's
   `-mregparm=3` passes eligible scalar arguments in EAX, EDX, and ECX.
   Variadic calls use stack arguments. Use the same classifier to assign
   arguments at a call site and at function entry. Check the stack boundary
   independently of the number of bytes used for an argument.
3. Emit position-independent ELF32 calls and data references. Link the
   Linux compat vDSO with its own linker script and check for text and
   dynamic relocations. Keep the shared LowIR optimization passes and
   use the existing x86 analyses for liveness and placement.
4. Add the `-m16` code mode for kernel boot. C keeps the i386 data model
   and uses 32-bit stack operations and calls with real-mode instruction
   prefixes. The boot setup build uses `-mregparm=3` and
   `-mpreferred-stack-boundary=2`. The compat vDSO uses stack arguments,
   position-independent code and `-mpreferred-stack-boundary=3`. Reuse PA29's
   assembly representation for `.code16`, `.code32`, and `.code64`
   transitions. Link the setup code and real-mode
   objects with the same ELF32 writer and linker used for `-m32`.
   Compile the setup code with `-Os` so it fits the kernel's 32 KiB limit.

### Run the checks

`make -C pa40 test` runs the controls with the existing Perl harness.
The controls link with an ELF i386 linker and check process exit status
and stdout. Use `CPPGM_I386_LD=ld.lld` to select LLD. On a system without
native i386 execution, set `CPPGM_I386_RUNNER=qemu-i386`.
Use `make -C pa40 check TEST=tests/assembly/100-i386-relocations.t` to
work on an individual fixture.

For the full build, use a Linux x86-64 configuration with
`CONFIG_IA32_EMULATION=y`, `CONFIG_X86_16BIT=y` and
`CONFIG_ACPI_SLEEP=y`. Build `bzImage` and `modules` in a fresh output
directory with `CC='cppgm -fintegrated-as'` for every target object.
Host build tools and the external ELF linker can come from the platform
toolchain. Boot the resulting `bzImage` into userspace under QEMU and
verify a 32-bit program can use the compat vDSO. Compare
`__vdso_clock_gettime64` with the clock system call and check that
`__vdso_gettimeofday` returns a microsecond field below one million.
