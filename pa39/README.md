## CPPGM Programming Assignment 39 — AArch64 Linux and Apple Silicon backends (experimental)

Implement the little-endian Armv8-A targets in the existing compiler after PA34 and PA37. The Linux profile has 64-bit pointers and long, 32-bit int, unsigned plain char and 32-bit unsigned wchar_t, binary128 long double, and 16-byte stack alignment. Use the Linux AAPCS64 calling convention and AAELF64 relocatable objects. Use a distinct target profile (`aarch64` in version-one LowIR) selected before parsing. Keep architecture-specific instructions and their encoder under `dev/src/aarch64/`. The frontend and optimizer pass typed data directly to the selector. [AAPCS64](https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst) · [AAELF64](https://github.com/ARM-software/abi-aa/blob/main/aaelf64/aaelf64.rst)

### Required linking milestone

PA25 introduced `cppgm -c`, multiple translation units, symbol resolution, relocations and executable link mode. PA26 introduced objects a host linker can consume. PA39 extends both contracts to Arm. Use the same symbol-resolution and section-layout machinery across native targets. Implement the Arm instruction fixups, entry conventions and file formats in the target backend. [PA25 assignment boundary](../pa25/README.md#assignment-boundary) · [PA26 object contract](../pa26/README.md#output-format)

| Deliverable | How the assignment checks it |
| --- | --- |
| Resolve source, object and archive inputs. Select needed archive members, resolve cross-unit calls and data, and report undefined, duplicate and incompatible inputs. | Link mixed-producer objects in both directions, include an archive with an unused member, and exercise each diagnostic. |
| Write a Linux ELF executable and an Apple Silicon Mach-O executable in process. Honor each format's address, page, relocation and entry-point rules. Build macOS load commands, rebasing information and the ad-hoc code signature. | Inspect both images independently, run Linux images on Arm, verify every Mach-O code-signing page hash on x86 and run the signed image under dyld on Apple Silicon. |
| Produce objects that the platform toolchain can link against its system libraries. | Use LLD or Apple's linker as an independent consumer and exercise hosted exceptions and thread-local storage. |

The Apple SDK link for hosted programs belongs to the platform interoperability test. A full system-library linker, including arbitrary dylib imports and symbol binding, would need its own assignment contract.

### Compile and run

```sh
cppgm --target=aarch64-linux-gnu -O2 -c sum.cpp -o sum.o
cppgm --target=aarch64-linux-gnu sum.o main.o -o program
qemu-aarch64 -cpu cortex-a53 ./program
cppgm --target=aarch64-linux-gnu -S -emit-lowir -O2 main.cpp -o main.lowir
lowir2native --target=aarch64-linux-gnu main.lowir -o main
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

Use Clang, LLD and llvm-readobj with the AArch64 target enabled and the `qemu-aarch64` Linux user emulator. The first verified configuration uses LLVM 22.1.2 and QEMU 10.2.1. Static tests need no target sysroot. The runner accepts the paths in `CPPGM_AARCH64_CLANG`, `CPPGM_AARCH64_LLD`, `CPPGM_AARCH64_READOBJ` and `CPPGM_AARCH64_QEMU`. Run `make test-pa39` from the root or `make check TEST=tests/control/300-mixed-loop.t` here. This assignment is opt-in.

Each fixture declares its expected exit status. The checker compiles at O0 through O3, inspects the object format, tests LowIR serialization, and executes the linked code. Mixed-object fixtures exchange caller and callee between cppgm and Clang. The checked-in entry stub lets LLD link the same objects independently. A full Clang build supplies a third observation. Code quality checks should bound work, memory traffic and size in named functions. Collect runtime measurements on AArch64 hardware.

### Implementation coverage

The fixtures cover integer, floating-point and NEON code, switch lowering, independent callers and callees, baseline atomics, archive linking, typed exceptions, cleanup, and hosted thread-local storage. Linux thread-local accesses use the local-exec model for direct objects and initial-exec GOT offsets for PIC. TLS programs require a hosted linker and runtime.

### Cross-tool setup and native replay

The reference lane uses LLVM 22.1.2, QEMU user-mode 10.2.1 (Cortex-A53),
GCC 14.3 AArch64 builtins and the GNU/Linux AArch64 C++ static runtime.
On Ubuntu 26.04 install `clang-22 lld-22 llvm-22 qemu-user
libgcc-14-dev-arm64-cross libstdc++-14-dev-arm64-cross libc6-dev-arm64-cross`.
Use the suffixed LLVM tool names in the checker variables if your PATH lacks
the unsuffixed commands. `CPPGM_AARCH64_OBJDUMP` selects llvm-objdump and
`CPPGM_AARCH64_AR` selects llvm-ar. The libgcc and hosted unwinding controls
use `CPPGM_AARCH64_BUILTINS` and `CPPGM_AARCH64_SDK_ROOT`. These default
to the GCC 14 Arm cross archive and the installed Debian-style sysroot layout
under `/`. Integer and control-flow fixtures use only the LLVM tools and QEMU.

The mixed ABI controls also cover homogeneous four-float records, indirect
aggregate results, variadic GP and vector save areas, i128 arithmetic and
binary128 helper calls. The link controls check GOT addressing, lazy archive
member selection, and DWARF unwinding through a cppgm frame. The memory lane
checks acquire/release, exclusive updates and compare-exchange. At O1 through
O3 the integer leaf kernel must execute entirely in registers.

To save the exact guests that passed on the cross host:

```sh
CPPGM_AARCH64_ARTIFACTS="$PWD/obj/pa39-guests" make test-pa39
```

Copy that directory to Linux AArch64 and run
`perl scripts/replay_aarch64.pl obj/pa39-guests`. Each manifest records the
SHA-256, exit status, optimization level, producers and linker. Native replay
checks the digest and status for every recorded execution.

At optimized levels the `transform` loop, including its setup and scalar tail, permits 160
instructions, 12 loads or stores, and eight stack loads or stores. At O3, LLVM 22.1.2
emits 35, four and zero for the same source. Both objects run the same odd-sized
input. The separate vector leaf has zero memory traffic. These budgets track
generated code on x86 while native runs measure execution time.

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
named function. Keep expected output and exit status in the sidecar. Run one fixture with
`make check TEST=tests/abi/400-apple-calling-convention.t` in `pa39/`.
