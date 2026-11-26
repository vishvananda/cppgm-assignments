# CPPGM Programming Assignment 39 — AArch64 Linux and Apple Silicon backends

Implement the little-endian Armv8-A targets in the existing compiler after PA34 and PA37. The Linux profile has 64-bit pointers and long, 32-bit int, unsigned plain char and 32-bit unsigned wchar_t, binary128 long double, and 16-byte stack alignment. Use the Linux AAPCS64 calling convention and AAELF64 relocatable objects. On Linux, x18 is a temporary register unless `-ffixed-x18` or `-fsanitize=shadow-call-stack` reserves it. Use a distinct target profile (`aarch64` in version-one LowIR) selected before parsing. Keep architecture-specific instructions and their encoder under `dev/src/aarch64/`. The frontend and optimizer pass typed data directly to the selector. [AAPCS64](https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst) · [AAELF64](https://github.com/ARM-software/abi-aa/blob/main/aaelf64/aaelf64.rst)

### Work through the assignment

1. Select the target before parsing and give it its own data layout and LowIR
   target name. Start with leaf integer functions, then add branches, loads,
   stores and parallel copies on control-flow edges. Run the target and
   control fixtures as you work.
2. Make a caller compiled by your compiler work with a callee compiled by
   Clang, then reverse the roles. Work through the ABI fixtures for register
   and stack arguments, homogeneous floating records, variadic calls and
   indirect results. Add floating-point and NEON operations and check the
   signed and unsigned cases.
   Use the Linux container alignment for unnamed bit-fields, including
   the natural alignment of zero-width fields in packed records. On both
   Arm targets, a nonzero unnamed integer bit-field makes an otherwise
   floating-point union nonhomogeneous.
3. Extend PA25 and PA26's link and object support to both Arm targets. Run
   the link fixtures, then the hosted runtime fixtures for exceptions,
   cleanups, and thread-local storage.
4. Run the quality lane at the optimized levels. Apply PA33's shared LowIR
   optimizations before selection and reuse PA34's liveness and spill
   analyses where the target permits. Inspect the emitted code to find extra
   loads, spills and moves.

Complete the assignment by passing the PA39 suite, including mixed-object
and LowIR round-trip checks. The x86 Linux tools below can run the cross suite
and check both file formats. Run the native replay on Apple Silicon when you
have access to it.

### Required linking milestone

PA25 introduced `cppgm -c`, multiple translation units, symbol resolution, relocations and executable link mode. PA26 introduced objects a host linker can consume. PA39 extends both contracts to Arm. Use the same symbol-resolution and section-layout machinery across native targets. Implement the Arm instruction fixups, entry conventions and file formats in the target backend. [PA25 assignment boundary](../pa25/README.md#assignment-boundary) · [PA26 object contract](../pa26/README.md#output-format)

| Deliverable | How the assignment checks it |
| --- | --- |
| Resolve source, object and archive inputs. Select needed archive members, resolve cross-unit calls and data, and report undefined, duplicate and incompatible inputs. | Link mixed-producer objects in both directions, include an archive with an unused member, and exercise each diagnostic. |
| Write a Linux ELF executable and an Apple Silicon Mach-O executable in process. Honor each format's address, page, relocation and entry-point rules. Build macOS load commands, rebasing information and the ad-hoc code signature. | Inspect both images independently, run Linux images on Arm, verify every Mach-O code-signing page hash on x86 and run the signed image under dyld on Apple Silicon. |
| Produce objects that the platform toolchain can link against its system libraries. | Use LLD or Apple's linker as an independent consumer and exercise hosted exceptions and thread-local storage. |

Use the platform linker for hosted programs that link against system libraries.
On Linux, advertise the GNU attribute syntax so glibc leaves `__attribute__`
available when a C header precedes the C++ headers. ABI tags must survive that
include order so separately compiled callers and definitions agree. Supply
the signed and unsigned fixed-width type predefines for the target's data
model, including the limits and integer-constant spellings used by
`<stdint.h>`. GCC's `<limits.h>` reads `__SCHAR_WIDTH__` and
`__LONG_LONG_WIDTH__` for the C23 width macros. Clang's resource header
uses `__CHAR_BIT__` and `__LLONG_WIDTH__`. On Darwin, the exact 64-bit type is `long long` and the
maximum-width type is `long`. In GNU dialects, also define
`__GLIBCXX_TYPE_INT_N_0` as `__int128` and `__GLIBCXX_BITSIZE_INT_N_0` as 128,
as GCC does; libstdc++ reads them to treat `__int128` as an integer type. Unwind
ranges describe the code in each object even when another shared library
exports a function under the same name. A position-independent object with
public functions must link into a shared library. The platform linker also
checks that read-only objects containing addresses can be relocated before
their storage is protected.
Test both forms of a weak ELF import. Its address is null when the linker
finds no definition and names the linked definition when one is present.

### Compile and run

```sh
cppgm --target=aarch64-linux-gnu -O2 -c sum.cpp -o sum.o
cppgm --target=aarch64-linux-gnu sum.o main.o -o program
qemu-aarch64 -cpu cortex-a53 ./program
cppgm --target=aarch64-linux-gnu -S -emit-lowir -O2 main.cpp -o main.lowir
lowir2native --target=aarch64-linux-gnu main.lowir -o main
```

### AArch64 Linux assembly listings

Implement `cppgm --target=aarch64-linux-gnu -S` with ELF labels, section
directives and relocations that an independent assembler can resolve.
For PA29 assembly, select register and memory operands from the typed packet,
honor local register bindings and declared clobbers, and preserve each
`asm goto` destination. Assembly directives can use integer operands whose
value follows from a mask. Computed goto and static tables of label addresses
also work in ordinary `-c` output.

```sh
cppgm --target=aarch64-linux-gnu -O2 -S control.cpp -o control.s
clang --target=aarch64-linux-gnu -c control.s -o control.o
make -C pa39 check TEST=tests/control/300-inline-assembly-listing.t
make -C pa39 check TEST=tests/control/300-computed-goto.t
```

Freestanding C code can use `-mgeneral-regs-only` to suppress vectorization and
keep compiler-generated aggregate copies in general registers. Explicit SIMD
translation units use the regular AArch64 profile.

### Integrated AArch64 Linux assembly

Compile the supplied `.S` input directly to ELF with the integrated
assembler. Reuse PA29's macro, symbol and section rules. Preserve
`#` as an immediate prefix and emit four bytes for `.word`. Support
the register aliases, scalar and SIMD instructions, local branches,
external calls and address relocations in the control. Any assembler that observes
those rules can supply the separately compiled caller or callee.

Use the same assembler for file-scope and inline instructions in `-c` output. Keep macros
defined by an earlier file-scope declaration available to the inline
statement. Preserve branches across multi-instruction statements, numbered
local labels, and `asm goto` destinations. If an inline statement emits data
in a different section, place the data there and resume code emission in the
original section. Keep replacement instructions in subsection 1 outside
the function's fall-through code. Resolve the lengths in its data record
from the labels that delimit each instruction sequence. Resolve backward
label distances when a macro uses them for a repetition count or condition.
Check both source input and the serialized LowIR packet.

```sh
make -C pa39 check TEST=tests/control/300-integrated-assembly.t
make -C pa39 check TEST=tests/control/300-integrated-inline.t
```

### Size optimization and source LTO

Both Arm targets support the experimental `-Oz` size profile and full source LTO.
For full LTO, pass consecutive source files to `cppgm -flto=full` (or `-flto`).
Each file has its own preprocessor and file-local names. The optimizer sees
their definitions together and can inline across file boundaries. Objects and
archives before or after that source group participate in ordinary linking.
Keep a strong override of a weak definition in a separate object.

```sh
cppgm --target=aarch64-linux-gnu -Oz -flto main.cpp work.cpp -o program
cppgm --target=arm64-apple-macos11 -Oz -flto=full -c main.cpp work.cpp -o combined.o
```

The second command produces an arm64 Mach-O object that Apple’s SDK linker can
consume. The corresponding Linux command produces an AArch64 ELF object.
`-fno-lto` restores separate compilation. `-Oz` also applies to single-source
and serialized LowIR inputs.

### Build for Apple Silicon

Use `--target=arm64-apple-macos11` for the macOS 11 deployment profile. Its LowIR spelling is `arm64_macos`. The compiler selects the Apple calling convention and emits 64-bit arm64 Mach-O objects directly. Darwin has signed plain char and wchar_t, 8-byte long double, packed fixed stack arguments and a pointer va_list. On the stack, fixed scalar arguments and homogeneous floating records keep their natural sizes. A direct record in the general register class takes one or two whole eight-byte slots. The caller extends narrow register arguments to 32 bits. The x18 register is reserved, and non-leaf functions maintain a frame record in x29. The target supports GOT-relative PIC and Darwin thread-local variable descriptors. [Apple ARM64 ABI](https://developer.apple.com/documentation/xcode/writing-arm64-code-for-apple-platforms)

```sh
cppgm --target=arm64-apple-macos11 -O2 -c sum.cpp -o sum.o
cppgm --target=arm64-apple-macos11 main.cpp sum.o -o program
# Hosted libraries on a Mac, using the SDK toolchain
cppgm --target=arm64-apple-macos11 -O2 -c main.cpp -o main.o
xcrun clang++ -arch arm64 -mmacosx-version-min=11.0 main.o sum.o -o hosted-program
```

The course link accepts self-contained source and object inputs. Compile hosted translation units with `-c`, then use Apple’s SDK linker for libc++, exceptions and pthreads. On Linux, LLVM’s Mach-O LLD can independently link the self-contained fixtures. The selected output runs natively on Apple Silicon. You can build the compiler on x86-64 or AArch64 Linux and select the Apple target explicitly.

```sh
# On x86 Linux, build and hash the macOS interoperability objects.
perl scripts/replay_arm64_macos.pl build obj/pa39-macho
# On an Apple Silicon Mac with the same directory and the Xcode tools.
perl scripts/replay_arm64_macos.pl replay obj/pa39-macho
```

The cross test executes SDK-free fixtures at their linked Mach-O addresses under a small Linux entry stub. Native replay links the exact objects against Apple's SDK, checks the signatures and runs the executables under dyld, including pthread and C++ exception fixtures.

### Test from x86 Linux

Install Clang, LLD, LLVM's object tools and the Linux user emulator
`qemu-aarch64`. These are enough for the freestanding integer and control
fixtures. For the hosted and binary128 fixtures, also install the AArch64
libc, libstdc++ and libgcc cross-development packages. For example, on
Ubuntu 26.04 use the following packages.

```sh
sudo apt install clang-22 lld-22 llvm-22 qemu-user \
  libgcc-14-dev-arm64-cross libstdc++-14-dev-arm64-cross libc6-dev-arm64-cross
```

From the repository root, run the full opt-in suite, the quality lane, or
one fixture.

```sh
make test-pa39
make -C pa39 test-quality
make -C pa39 check TEST=tests/control/300-mixed-loop.t
```

Set `CPPGM_AARCH64_CLANG`, `CPPGM_AARCH64_LLD`,
`CPPGM_AARCH64_OBJDUMP`, `CPPGM_AARCH64_READOBJ`, `CPPGM_AARCH64_AR`
and `CPPGM_AARCH64_QEMU` when the tools use suffixed names or live outside
your PATH. Set `CPPGM_AARCH64_SDK_ROOT` if your cross SDK is installed
outside the standard Debian layout under `/`. Use
`CPPGM_AARCH64_BUILTINS` to select its libgcc archive.

The checker builds at O0 through O3, inspects object files, checks the LowIR
round trip and runs the linked programs under QEMU. For mixed-object fixtures
it exchanges the caller and callee with Clang. LLD provides an independent
consumer of the same ELF objects.

A pointer to a member function is two words aligned to eight bytes. On
Linux it can start in an odd-numbered argument register. When passed on
the stack, including through `...` on Apple Silicon, it starts at the
next eight-byte-aligned slot. A true `__int128` keeps its 16-byte
alignment. The member-function-pointer ABI fixture checks fixed,
stacked and variadic arguments across both compilers.

### Code quality

Use the Arm quality lane as you used PA34's native backend quality tests.
See [PA34](../pa34/README.md).
The tests check results and cap instruction count, memory traffic, stack
accesses or code size for selected functions. Choose your instruction
sequence and register assignments to meet those budgets.

- Keep leaf arithmetic and vector values in registers. Check that moves
  between register banks are needed and that spilled floating values can
  be loaded directly into floating-point registers.
- For division by a constant, compare the hardware divider with a widening
  multiply and a shift. Check signed rounding and the cost of loading the
  constants. A remainder can reuse the quotient.
- For adjacent array accesses, see whether a value from one iteration can
  serve the next. Check the zero-trip path and an update through an aliased
  pointer before relying on a loop-carried value.
- Preserve signed zero and unordered comparisons when choosing scalar or
  vector floating-point instructions. Compare mixed-object results before
  measuring speed.
- For nested loops over contiguous floating-point arrays, check whether the
  inner loop has independent lanes before expanding its iterations. Where
  the arrays can overlap, preserve the order in which each value is read
  and updated.
- For loops with separate integer and floating-point exit tests, check
  which values cross the backedge and which each exit uses. Changing the
  loop layout can remove copies while preserving the order of the tests.
- For a loop that updates a pointer used by cleanup code, check what the
  cleanup reads when an exception is thrown before and after the update.
- For a scalar floating-point multiply followed by an add, `-ffp-contract=fast`
  permits rounding the result once on either Arm target. `-ffast-math` also
  grants this permission. Use `-ffp-contract=off` when the intermediate rounding
  matters. Compare source and LowIR object builds with the same contraction
  option on the `cppgm -c` command.

Use the quality lane on x86 while developing. Use Arm hardware for
wall-clock performance comparisons.

### Replay on Arm

To save the exact guests that passed on the cross host:

```sh
CPPGM_AARCH64_ARTIFACTS="$PWD/obj/pa39-guests" make test-pa39
```

Copy that directory to Linux AArch64 and run
`perl scripts/replay_aarch64.pl obj/pa39-guests`. Each manifest records the
SHA-256, exit status, optimization level, producers and linker. Native replay
checks the digest and status for every recorded execution.

### Writing a fixture

Use PA37's backend fixture layout. The main source is `NAME.t`, additional
translation units sit beside it as `NAME.t.1`, `NAME.t.2`, and the target
sidecar is `NAME.arm-expect`. Like PA37's `.wasm-expect`, it names the units
to compile, any compiler flags, and the observable result of running the program.
For example, the Apple calling-convention control uses the following fields.

```json
{
  "source": true,
  "target": "arm64-apple-macos11",
  "units": ["400-apple-calling-convention.t.1"],
  "llvm_interop": true,
  "commands": [{"exit": 39, "stdout": ""}]
}
```

`llvm_interop` exchanges independently compiled objects with Clang in both
directions. Each command may also specify `args`. Use PA37’s `reference_assembly` for an independent assembly unit,
`archive_units` for archive linking, and `reject_link` for an expected link failure.
The `quality.levels` and `quality.functions` fields publish the bounds for each
named function; Clang's code for the fixture meets them too. `quality.own_functions`
holds bounds for your compiler's code alone, where the rule is not one Clang follows. Keep expected output and exit status in the sidecar. Run one fixture with
`make check TEST=tests/abi/400-apple-calling-convention.t` in `pa39/`.
