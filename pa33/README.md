## CPPGM Programming Assignment 33 (`lowiropt`)

### Overview

PA33 adds the first explicit optimization stage to the compiler. The new tool,
`lowiropt`, reads PA8 LowIR text, applies a deterministic optimization
pipeline selected by `-O0`, `-O1`, `-O2`, or `-O3`, and writes LowIR text.

The same LowIR optimizer is also reached from `cppgm` when source programs
are compiled with `--emit-lowir -O1`, `--emit-lowir -O2`,
`--emit-lowir -O3`, or through the ordinary compile/link driver at an
optimization level.

### How PA33 Is Specified

This README separates three kinds of statement, and the course suite is
built the same way.

- The **contract** is what every implementation must do: the command line,
  the LowIR it reads and writes, the behaviour it must preserve, and the
  object path that must accept its output.  Command Line, Output Format,
  Error Handling and Validation Modes are the contract.
- The **quality bar** is what the output must reach on the course fixtures:
  the outcome and the size envelope each fixture states in its
  `x.ref.expect` sidecar, and the lowering floor.  The Quality Bar section
  is normative.
- The **design notes** discuss algorithms, proofs and tradeoffs. They are
  advice, not additional requirements. A different optimizer that meets the
  bar is correct; a course fixture never compares its output shape with the
  reference implementation's.

Run `make test` from this assignment directory to check the course contract.
See [Testing and references](../TESTING_AND_REFERENCES.md) for selecting tests.

### Prerequisites

You should complete PA32 before starting this assignment.

The kernel quality checks require Python 3, GCC and Valgrind's Cachegrind on
Linux x86-64, in addition to the ordinary course tools.

You will reuse:

- the PA8 LowIR syntax and semantics
- the PA10 through PA32 source-to-LowIR lowering pipeline
- the PA24 native backend, PA25 driver, PA9 ABI naming, and PA26 host-runtime path
- the PA32 hosted compiler driver surface

### Starter Kit

The starter kit supplies:

- `pa33/Makefile`
- `pa33/lowiropt.cpp`, linked to the editable `dev/lowiropt.cpp`
- a student-editable `dev/lowiropt.cpp` starter scaffold
- shared compiler support under `dev/src/`
- test directories under `pa33/tests/`
- harness scripts under `pa33/scripts/`
- checked-in `.ref` and `.ref.exit_status` files for the tests

The expected implementation work is in `dev/lowiropt.cpp` and shared optimizer
or driver support under `dev/src/`, especially the LowIR optimizer and
optimization-level plumbing. Reuse your PA8 LowIR reader/writer and later
driver implementation; the supplied harness does not implement these passes.

Use `lowiropt-ref` to inspect example output.
The harness checks the contract sidecars and quality envelopes.

### Command Line

`lowiropt` accepts exactly one optimization level, one output path, and one or
more LowIR input files:

```sh
lowiropt -O0 -o <outfile> <lowirfile>...
lowiropt -O1 -o <outfile> <lowirfile>...
lowiropt -O2 -o <outfile> <lowirfile>...
lowiropt -O3 -o <outfile> <lowirfile>...
```

`--help` and `-h` print usage information and exit successfully.

PA33 also requires the source driver to route these options through the same
optimizer:

```sh
cppgm --emit-lowir -g0 -O1 -o <outfile> <srcfile>...
cppgm --emit-lowir -g0 -O2 -o <outfile> <srcfile>...
cppgm --emit-lowir -g0 -O3 -o <outfile> <srcfile>...
cppgm --emit-lowir -gline-tables-only -O1 -o <outfile> <srcfile>...
cppgm --emit-lowir -gline-tables-only -O2 -o <outfile> <srcfile>...
cppgm --emit-lowir -gline-tables-only -O3 -o <outfile> <srcfile>...
```

The ordinary `cppgm -c` and link-driver paths must also accept `-O0`, `-O1`,
`-O2`, and `-O3` and use the same LowIR optimization level before object
generation. As with GCC and Clang, omitting `-O` selects `-O0`; optimization
must be requested explicitly.
Compile mode must also accept serialized LowIR text as an input:

```sh
cppgm -c -O0 -o <objfile> <lowirfile>
cppgm -c -O1 -o <objfile> <lowirfile>
cppgm -c -O2 -o <objfile> <lowirfile>
cppgm -c -O3 -o <objfile> <lowirfile>
```

This LowIR object input mode parses LowIR text, runs the same object-prep and
optimization path used by source object compilation, and writes the same
host-compatible relocatable object format.

### Output Format

`lowiropt` writes LowIR text to `<outfile>`. The output must remain valid LowIR
and must preserve the behavior of every defined input program.

The optimizer works on the same LowIR program representation that the object
path consumes. It may use typed internal data structures, but optimized output
must serialize back to valid LowIR, and object generation at a chosen
optimization level must not require extra semantic facts unavailable from that
optimized LowIR text.

This LowIR/object boundary is required in PA33. A correct compile path
may keep LowIR in memory for speed, but it must not pass private frontend or
semantic side data around the serialized LowIR representation. If object
emission needs a fact after optimization, that fact must either be represented
in LowIR or derived again by the object-lowering layer from LowIR. The direct
`cppgm -c` source object and the object produced by `--emit-lowir -O0`
followed by `cppgm -c -O<level>` on that LowIR file should therefore match
for the same source, flags, and optimization level.

This durability rule includes PA27 global section placement. A token-safe GNU
section attribute is serialized as global `section=<name>` metadata and must
survive `-O0` through `-O3`. The replayed object must keep the global in the
same named ELF section and keep relocations originating in that section aimed
at the same symbols; direct/replayed byte equality alone is not the feature
definition.

PA33 adds one source attribute, GNU `cold` (also `__cold__` and
`[[gnu::cold]]`): the function is unlikely to run. The C++ lowering states
it as `cold=yes` on the function's declarations and definition (see
`../pa8/lowir.md`, "Facts The C++ Lowering States"), and `__has_attribute`
answers 1 for `cold` and `__cold__`. The flag is a hint. A call of a cold
function, and the path that reaches it, are rarely executed; the cold
function itself is optimized for size. `tests/driver/o0` compares the
stated fact, and `tests/driver/o2` bounds what the optimizer does with it.

Your output must be deterministic and follow the [LowIR format](../pa8/lowir.md).
Optimization may change instructions and control flow while preserving their
meaning, including initialization, destruction, volatile accesses and cleanup.
`-O0` preserves semantic content without optimization. At higher levels, the
fixture expectations define the required simplifications and size bounds; the
choice and order of passes are yours.

### Error Handling

The tool must fail with a nonzero exit status when:

- no optimization level is provided
- `-o` is missing or has no following path
- there are no input files
- an input file cannot be read
- the input is not valid LowIR
- the output file cannot be written

For failure cases, diagnostics only need to be useful to a developer; exact
diagnostic text is not part of the grading contract. The contents of the
output file after a failed run are undefined.

### Quality Bar

The levels have this contract.  `-O0` parses the input program, preserves all
semantic content, and writes the canonical LowIR dump without running
optimizing transforms.  `-O1`, `-O2` and `-O3` each write valid LowIR that
preserves the behaviour of every defined input program; each higher level
may do everything the lower one does and more.  What the levels do is
your design.

For each LowIR or `--emit-lowir` driver fixture `x.t`, the course checks:

- the tool's exit status agrees with `x.ref.exit_status`;
- a successful output passes the LowIR structural validator;
- the output meets every predicate in its `x.ref.expect`
  (`../scripts/expect_ir.pl`);
- the output lowers through the object path at `-O0`
  (`cppgm -c -O0 x.lowir`) whenever the input does.  `make test` sets
  `CPPGM_LOWER_CHECK_APP` so the harness runs that floor; an optimizer's
  output is not correct until the backend accepts it;
- the optimized program behaves as the input's: both are built through the
  reference backend (`lowir2native-ref -O0`) and run, and the optimized one
  must exit the same way and print the same output (`make test` sets
  `CPPGM_LOWIR_BEHAVIOR_APP`).  An entry without parameters runs as
  written.  Otherwise a generated driver is the entry: it calls a
  parameterized entry with fixed scalar arguments or, when the fixture has
  no entry, every function of external binding whose parameters and result
  are scalars, and returns the sum of their results.  A helper the fixture
  declares and nothing defines gets a generated provider that returns zero,
  and when its declaration allows unwinding both programs also run with a
  provider that throws, so the handlers run too.  An `x.driver.lowir` beside
  a fixture replaces the generated driver and providers: it is appended as
  written, its `@main` is the entry, and the fixture's own `@main` is renamed
  `@__behavior_entry`. Use a driver sidecar to choose terminating inputs and
  check meaningful results when the default arguments are unsuitable.
  The lane's summary line says how many inputs ran,
  how, and why the others did not (a pointer parameter or result, a helper
  no provider can define, a program that does not finish); an input the
  reference backend cannot build fails the lane.

An `x.ref.expect` sidecar has two kinds of line.  Outcome lines state what
the fixture is about in terms of the LowIR it reads and writes:
`none(call @callee) in @caller` for a call that must be inlined,
`count(load) <= 1 in ^body` for a load that must be hoisted,
`none(phi) in ^merge` for a choice that must collapse.  Budget lines bound
the output's size: `instructions <= N`, `blocks <= N`, `count(call)`,
`count(load)`, `count(store)`, `count(phi)`, and `instructions <= N in
@function`. Each sidecar states the required bounds and outcomes, with room
for alternative implementations. The adjacent `x.ref` is an informational example; matching its
instruction sequence is not required.

A fixture's header comment names the outcome its sidecar asks for. A
function that the header calls a control is checked by execution and by
upper bounds only.

An outcome line without a scope counts the whole file. `none(phi)` there
means that every merge of values in every function is gone: a two-way merge
of pure values became a `select`
(`tests/o1/500-form-select-with-effect-guard.t`), or the merge block was
duplicated into its predecessors.

A line scoped to a block (`in @f ^body`) counts the block of that name in
your output. When a pass duplicates or unrolls a block, give the copies new
names and leave the original name on the block that still runs one pass at a
time.

The adjacent array update fixture exercises reuse between iterations. If
the loop writes either element, use the value the next iteration would
actually load. Check reads and writes through other pointers before reusing
a value, and keep the initial load on the path that enters the loop. Try
the positive, zero-trip and aliasing cases with `make check`.

A scope names a function by its LowIR name. Most driver-lane sidecars name
`extern "C"` functions. The others name a C++ function that is not
overloaded, as the supplied references spell it; `../pa8/lowir.md` does not
fix that spelling, so with a front end that spells the name differently the
bound has no effect.

Some sidecars hold only a loose envelope that the unoptimized input already
meets (`600-uniform-local-fill`, `500-conditional-vector-reductions`,
`500-lane-planning`, `600-packed-loop-invariants`). They check behavior and
guard against growth; no transformation is required.

A source fixture in a driver lane is also run: the emitted LowIR is built
into a program through the object path and compared with the source built
at the lane's level (`CPPGM_BEHAVIOR_CHECK_APP`, set by `make test`); both
must print the same output and exit the same way.  A source that does not
build at that level is skipped.

To evaluate one sidecar by hand:

```sh
$ perl ../scripts/expect_ir.pl tests/o1/x.my tests/o1/x.ref.expect
```

`make test-kernels` adds six dynamic work checks: bounded search, aliased and
disjoint field updates, narrow arithmetic, state crossing a cold call and
conditionally updated floating state, plus adjacent updates with an invariant
factor.
They use one host-built scalar oracle and driver, and compare startup-subtracted
Cachegrind instruction counts against the host GCC run at the level in the
`.quality` file (`-std=c++11 -O<level> -g0 -fno-lto`). Each `.quality` file
publishes its limit; the supplied frontend and unoptimized backend isolate
your LowIR work. A scalar solution meets every limit: no kernel needs vector
instructions. The ordinary course suite includes these checks. See
[improvements.md](improvements.md) for their edge cases and measurement method.

Library-call rewrites must preserve side effects and use an ABI provided by
the target runtime. Keeping independent calls is valid; tests judge behavior
and linkability rather than requiring a combined helper call.

#### Fixture families

The paragraphs below say what groups of course fixtures require. The exact
bounds are in each fixture's sidecar.

The `tests/driver` fixtures use facts that the C++ lowering of earlier
assignments states (`../pa8/lowir.md`, "Facts The C++ Lowering States").
`alias=exclusive_result` on a result parameter (PA12): a store into the
result's first `object_bytes` bytes changes nothing that another name can
read, so loads and `repeatable` calls on other storage stay valid, and field
copies into the result can combine. `repeatable=yes` (PA28): an equal call
may be reused while the memory it reads is unchanged. `return=nonnull` and
`noalias_result=yes` (PA28): a null test of the result is constant, and a
store through the result leaves earlier loads valid. `object_bytes=N` with
`N` greater than zero ("Instruction Facts"): the pointer is not null, and
`copy nonnull` keeps that fact after inlining. If your `tests/driver/o0`
output lacks one of these facts, the fixtures that use it fail for that
reason.

An object of at most 16 bytes whose eightbytes are all INTEGER may cross a
function boundary as one integer value: `i64` up to 8 bytes, `i128` from 9
to 16 bytes (`../pa8/lowir.md`, "Object ABI Conventions").
`400-scalar-aggregate-copies` allows no `copyobj` and
`500-packed-floating-bits` allows no store in `@floats`; this form reaches
both. `600-source-returned-object-copy` accepts this form or one `copyobj`.
Returning a staged object must preserve any stores to it after the copy.
Use both objects' access facts before forwarding the return to the source.

No course fixture requires a particular admission cap or pass order. The
fixtures about inlining state outcomes that a range of policies reach. A
small leaf goes inline on an ordinary path, and a single-use internal
function goes into its caller. A callee is measured after it is simplified:
the inline fixtures with long runs of identical stores are not size tests,
because the stores are removable. A callee that has grown by inlining is
judged at its current size (`500-final-callee-inline-cost` bounds the
caller). A large `binding=weak` helper is shared with other translation
units, and `400-weak-worker-growth` bounds its caller. An upper bound on a
function removed by optimization still holds.

A call of a `cold=yes` function marks its block as rare, like a block that
reaches a `return=noreturn` call; a `likely` or `unlikely` prediction marks
one target of its branch as rare. A call on a rare path may stay a call or
go inline: the bounds of `400-cold-call-sites` and
`500-predicted-cold-call-inlining` leave room for one copy of each callee.
An ordinary caller still inlines a small callee.

A `select` or `switch` whose condition is a join of constants is already
decided on each incoming edge. The tagged-value fixtures
(`500-constant-phi-*`, `500-optional-payload-select`) expect the tag, the
dispatch and the storage the tag guarded to disappear. Volatile reads, an
edge where the tag is not a constant and values computed after the join keep
their place. Take each constant at the tag's width before testing it.

A switch whose arms only return constants, or one base address plus constant
offsets, can read its result from read-only data after one range test (see
"Result tables for switches" in the [design notes](design-notes.md)). A
short chain of selects meets the same bounds of `400-return-switch-tables`.
Add no data read where every case returns one value, and keep a default
path's effects.

The sparse-dispatch fixture (`500-sparse-full-key-dispatch`) bounds the
size of `dispatch`. An ordinary switch, a bounded comparison tree and a
guarded table are all valid. If you use part of the key to index a table,
prove the index is in bounds and confirm the entire key before taking a
case. The test includes misses that have the same low bits as real cases.

The repeated-query fixture (`500-share-query-miss-path`) gives several
calls the same inputs except for the tested key. Test the common key on
entry without a predicate call. A proven miss can skip the entire chain.
On a possible match, keep callbacks and exceptions in their original
order. A short comparison chain and a membership test both fit the
published bounds. Only share reads whose values and effects can be proved.

The O3 bit-recurrence fixtures bound repeated shift/XOR work across several
word widths and constants. `k` steps with one constant are linear over bits
(see "Library math and representation" in the design notes): the result is
`x >> k` combined by XOR with a function of the low `k` bits alone, and that
function fits in read-only data indexed by those bits. The size bounds leave
room for one table or for two smaller ones; a form that still spends four
instructions on each step does not fit. The bounds are static instruction
counts: in `500-source-bit-recurrences` a table read meets them, and so do a
loop left rolled and the four unrolled steps of `update_nibble`; eight
unrolled steps for each byte of `update_word` do not. The behavior drivers
exercise every byte input, wider seeds and cases that invalidate a shortcut.

An object returned by value is a read of its storage, not an escape of its
address. Preserve actual address captures, pointer returns, volatile reads
and physical frame observations when combining field copies.

The guarded-publication fixture (`600-guarded-record-publication`) asks
`publish` to write the result without a whole-object staging copy. One
approach writes the final fields directly on the fast arm and initializes
the local record on the arm that passes its address. Preserve the final
writer of every byte, updates made by the call, and the result read after
the branch. The partially overwritten record is a control. Preserve its
unwritten bytes even if you leave its copy in place.

The private-snapshot fixture (`600-private-snapshot-unwind`) asks
`inspect` to avoid an extra whole-object copy. Reading the needed fields
from a proven private snapshot or passing the saved fields to a closed
internal callee both fit the bounds. The saved values must survive writes
through an alias to the original object and remain available during
unwinding. Keep every observable cleanup and any externally visible
calling convention. The repeated-query and private-snapshot outcome checks
run in the Linux x86-64 course lane.

The object-transfer fixtures use equivalent value-copy and whole-object
memory forms. Preserve when each snapshot is taken while meeting their size
bounds. Boolean-storage fixtures also read through byte types: preserve
arbitrary byte writes, escaped storage and volatile accesses. Counter fixtures
include nonnegative loops, negative starts and wrapping counters; any arithmetic
simplification must preserve all of them.

Coupled loop values can also bound each other. Meet the bounded-search and
averaging fixtures' arithmetic bounds while preserving signed rounding,
overflow, every entry seed and computations observed before a guard.

When a short loop has a second bound, check whether it has room for every
iteration before choosing a fully unrolled path. Use a comparison that also
works near the signed limit. Check the empty range, the short tail and the
values and stores that reach the exit from each path.

When every packed use of an induction value truncates it, consider keeping
the packed counter at the narrower width. Check wraps at that width and keep
the full-width value wherever addresses, exit conditions or scalar iterations
observe it.

Boolean conditions may pass through selected zero/one values and integer
retypes. Meet their quality bounds while preserving actual narrowing of
arbitrary integers; a nonzero value can become zero when narrowed.

Meet the conditional-store fixtures' branch and store bounds while preserving
the selected values, cursor updates and empty-input behavior. Keep alias reads,
callbacks, volatile accesses and potentially trapping work correctly ordered
and conditional.

Large-object fixtures combine indexed payloads, recurrent scalar fields and
whole-object snapshots. Meet their bounds while preserving every copied byte
and the time each snapshot is taken. Keep volatile accesses and overlapping
field views observable.

Private-allocation fixtures include pointers loaded from older objects,
published addresses and opaque callees. Remove repeated reads only when their
memory cannot change; an allocation's freshness alone does not establish that
its address stays private.

Recursive-dispatch fixtures bound redundant call layers around loop work.
Preserve recursive exits, argument effects, unwinding and the stated code-size
bounds; the tests do not prescribe a particular call-graph algorithm.

Private fields accessed through signed and unsigned views of one width should
remain eligible for scalar replacement. Preserve bit patterns, each reader's
interpretation, Boolean conversions, true overlaps and observable accesses.

Whole-vector values stored in private aggregates can remain whole through
copies and zero initialization. Use typed access and escape facts to avoid
scalar memory round trips; preserve observable writes and volatile accesses.
If a loop transformation exposes fixed vector fields, check the aggregate
again. A pointer stored into its own aggregate can become dead after its
last reader disappears. Preserve self-references that can still be observed.
Unrolling a short outer loop can expose constant indices in an inner loop.
Check the cost of the resulting code and the values it keeps live across
the remaining loops.
Packed shifts whose count becomes constant may use immediate operations,
with oversized logical counts producing zero and arithmetic counts retaining
sign fill. Equivalent implementations satisfy the same behavior and bounds.

### Design Notes (Non-Normative)

The fixtures are small; the optimizer's real input is PA35's self-build of
the whole compiler, where functions are large, calls sit inside loops and
most bodies have cleanups. A few principles matter there more than any one
pass:

- Run the passes over each function repeatedly, to a fixed point or a
  budget, rather than once over the program. Inlining exposes constants that
  folding removes, which exposes branches that simplification removes, which
  shrinks callers below the inlining threshold.
- Count what every admission rule excludes. A rule that skips a function
  for its size, its exception handling or a call in a loop costs nothing on
  the fixtures and may exclude most of a real program; know the fraction.
- Keep facts that cost nothing to keep. `typed`, `nowrap`, `exact` and `inbounds` come
  from the lowering (`../pa8/lowir.md`, "Instruction Facts"); an optimizer
  that preserves them through copies and drops them where it speculates can
  use `typed` to keep a value in a register across a store of another type.
  An inbounds element address compares equal to null exactly when its base
  does; plain wrapping addresses require their original comparison. Preserve
  this distinction through address merging and conditional speculation.
  Functions with persistent code addresses can still forward private storage
  across ordinary internal joins. Addressed entries retain their memory state
  and cannot acquire phi inputs from indirect edges.
  Equal loop-carried values may depend on each other through several joins.
  Prove equality by matching their incoming edges and external values.
  Equal literal values may use different spellings. Preserve distinct seeds,
  updates and predecessor choices. Bound the proof work.
  When a packed integer load supplies only one byte-aligned floating field,
  reading that field directly can avoid unpacking work. Preserve snapshot
  boundaries, volatile and atomic access widths, and the exact bits of floating
  fields. A reinterpreted field does not inherit the wider load's alias type.
- When an optimization makes the output slower because the backend lowers
  the result badly, fix the backend. Withholding the optimization leaves both
  problems in place, and the rule that withholds it has to be found and
  undone once the backend improves.
- Know what blocks inlining in real code. A callee that contains exception
  instructions is the common case (any destructible local and a call), and
  LowIR's handler edges are implicit (see PA21's handout). An
  optimizer must track the handler stack or prove the copied regions no
  longer needed. Every normal and exceptional path must leave balanced state.
  An `eh_try` landing that pops its own record with `eh_end` needs a
  targetless `eh_cleanup` to retain that record on entry, as specified in
  [LowIR's exception-handling contract](../pa8/lowir.md#exception-instructions).
- An ellipsis alone does not require a separate call frame. A small function
  that never inspects its unnamed arguments can be substituted like a fixed
  argument function, preserving every argument's evaluation and cleanup.
  `va_start` and `va_arg` require a separate proof about the argument area.
- A block that calls a `cold=yes` function is rare, like a block that reaches
  a `return=noreturn` call. A cold callee larger than its call is usually
  better left a call, and a cold function gains little from copies of its
  callees. A small cold callee may go inline; keep its path rare afterwards,
  for example with an `unlikely` prediction on the branch into the block.
- A function that only forwards a call and returns its result may not need a
  separate call at each use. Preserve argument order, conversions, object
  materialization and cleanup when composing such boundaries.
- For library math rewrites, use the effective call boundary. A direct
  call with an explicit boundary can have effects beyond the result and
  `errno`, including reads and writes of floating-point state. Preserve
  reads of `errno` after a call, including direct symbol references and
  reads of its object representation through a pointer.
  When merging trigonometric calls, preserve the error each call can
  set if a store or another call may change the error number between
  them. Check every path through a control-flow join.
  For a fixed-exponent `pow` or `powf`, prove that the replacement arithmetic
  preserves the required error behavior, or leave a library call for inputs
  that can raise a range or pole error. Evaluate the arithmetic only on a
  path where it is safe.
- A write fully replaced through the same address before any possible read
  need not reach memory. Address identity can prove this even when an array
  index is dynamic. Preserve alias reads, volatile and atomic accesses,
  callbacks, exceptional paths and bytes a partial write does not replace.
- A complete constant-byte fill can determine later integer reads through
  varying indices. Preserve other writes and observations; the object-content
  fixtures include pointer merges, partial fills and escapes. No particular
  propagation pass is required.
- A conditional choice between fields can sometimes use one indexed address
  and one read. Prove the bit test and byte offsets, preserve which address
  is accessed, and keep volatile reads and memory dependencies observable.
  Account for element scale, negative offsets and unaligned fields without
  adding redundant address work.
- Cases sharing one destination may describe an interval. Preserve widths,
  signed boundaries, holes, default behavior and guarded effects when exposing
  that choice to simplification or predication.
- Combining independent operations can expose new loop-invariant work.
  Recheck affected loops without moving reads or trapping work onto paths
  where they did not execute, or changing floating-point evaluation order.
- Keep the optimizer's own work bounded. PA35 compiles the whole compiler
  at `-O3` with this optimizer; [the design notes](design-notes.md) describe
  how to avoid repeating work.

The sidecars state observable outcomes and output-size limits. Consult the
[design notes](design-notes.md) for the reasoning behind possible approaches.

### Further improvements

Once the course checks pass, investigate work that repeats on hot paths. The
design notes cover newer examples: keeping table lookups and object fields in
registers, simplifying library math, specializing calls, unrolling bounded
searches, and computing independent values in vector lanes. These are useful
directions for experiments; they add no named-pass requirement to this
assignment. Vectorization and interchange remain optional.

Independent scalar values carried around the same loop can also share
vector lanes. Look for matching updates and account for packing at entry,
extraction at exit, and any extra shuffles inside the loop. Keep the
operation order within each lane and compare the cost with the scalar
version for the selected target.

Packed integers may contain fields a later reader never uses. Track the
possible bits through masks, conversions and shifts before simplifying a
slice. Preserve clipping at the original width, shared readers and effects
whose result bits are discarded; avoid duplicating shared computations.

For each experiment, first write a small behavior test with runtime inputs.
Include the cases that invalidate the proposed shortcut: aliasing and overlap,
zero iterations and short tails, an early exit, calls and exception paths,
negative values, NaNs and signed zero where relevant. Run optimized LowIR
through the reference backend at `-O0` to check the optimizer independently,
then check the source and serialized-LowIR object paths together. A good
optimizer can retain a guarded scalar path when a proof fails.

Judge the benefit by work removed or by a generous size bound, and measure
larger workloads as described in PA34's design notes. A shorter dump alone may
increase register pressure or delay a division. Keep compile cost and code
growth in the comparison. See [the improvement exercises](improvements.md)
for supplied inputs, scalar oracles and optional measurement commands.

### Validation Modes

Successful outputs must pass the LowIR structural validator, the fixture’s
`.ref.expect` predicates, the object-lowering check and, for inputs with
an entry function, the execution check through the reference backend.
Source-driver cases also compare execution before and after LowIR
serialization. Failed cases are checked by exit status. See Quality Bar
for the sidecar syntax.

### Testing

From this assignment directory, run:

```sh
make test
```

Before moving on, run `make test-report-through-pa33` from the repository root.

`make test` runs:

- `tests/o0`
- `tests/o1`
- `tests/o2`
- `tests/o3`
- `tests/driver/o0`
- `tests/driver/o1`
- `tests/driver/o2`
- `tests/driver/o3`
- `tests/host/o1`
- `tests/host/o2`
- `tests/object-roundtrip`


These directories are organized by tool mode and validation mode, not by N3485
source-language clauses.

- `tests/o0` runs `lowiropt -O0` on handwritten LowIR.
- `tests/o1` runs `lowiropt -O1` on handwritten LowIR.
- `tests/o2` runs `lowiropt -O2` on handwritten LowIR.
- `tests/o3` runs `lowiropt -O3` on handwritten LowIR.
- `tests/driver/o0` runs `cppgm --emit-lowir -g0 -O0` on source programs
  whose boundary facts come from attributes that PA27-PA30 introduce (GNU
  `noinline`, `pure` and `const`, `[[noreturn]]`) and from PA33's GNU `cold`:
  the C++ lowering's own output, compared as PA10-PA23 compare theirs, facts
  included.
- `tests/driver/o1` runs `cppgm --emit-lowir -g0 -O1` on source programs.
- `tests/driver/o2` runs `cppgm --emit-lowir -g0 -O2` on source programs.
- `tests/driver/o3` runs `cppgm --emit-lowir -g0 -O3` on source programs.
- `tests/host/o1` and `tests/host/o2` build host-compatible objects at their level,
  link them with the host compiler and check program output and exit status.
  They cover nested catches and shared normal/handler continuations after
  optimization; PA26 retains the
  corresponding unoptimized EH coverage. These `.t` anchors use `.t.N`
  companion sources (`.t.N.lowir` for handwritten LowIR) and the ordinary
  host-link result sidecars.
  Equivalent ABI entries can share retained code after inlining without losing
  their names or cross-unit availability. The footprint check permits either
  entry to hold the body, aliases or forwarding entries; it does not prescribe
  instructions. Keep the equivalence proof independent of inline profitability
  and preserve it through LowIR serialization.
  An adjacent `.flags` file may select additional driver options, including
  the disabled-strict-aliasing case's `-O2 -fno-strict-aliasing`.
- `tests/kernels` supplies the six required dynamic quality checks described
  above. `make test-kernels` runs these independently.
- `tests/improvements` supplies optional vector, memory traversal and scheduling
  experiments. `make test-improvements` checks their behavior and reports work
  without a speed threshold; see [improvements.md](improvements.md).
- `tests/object-roundtrip` compares direct `cppgm -c` output against an
  object produced by `cppgm --emit-lowir -O0`, then `lowiropt -O0`, then
  `cppgm -c` on the rewritten LowIR file. This checks that object emission
  can be reconstructed from serialized LowIR instead of from hidden frontend
  side data, and that `lowiropt` reads and writes every fact a host object's
  LowIR states. These tests may be standalone `.cpp` files or symlinks to existing
  `.t` harness cases; a selected `.t` test expands to its numbered `.t.1`,
  `.t.2`, ... source files when those sidecars exist. The harness checks
  no-debug objects at `-O0`, `-O1`, `-O2`, and `-O3`. A
  GNU-section reducer additionally checks the global-section and relocation
  relationships in both objects rather than relying only on byte equality. A
  `default-no-optimization` case also checks that omitting `-O` matches
  explicit `-O0`. A parameter-object-extent case additionally makes O3 object
  shape depend on a source-produced member-object boundary, so byte equality
  checks compiler-object and textual LowIR transport of that fact.
  Equivalent function entries mixed with global definitions must also remain
  stable across the two paths.

Run the debug metadata preservation lanes with:

```sh
make test-debuginfo
```

This also runs `tests/object-roundtrip` in debuginfo mode, comparing direct
`cppgm -c` output against LowIR-input `cppgm -c` output with
`-gline-tables-only` at `-O0`, `-O1`, `-O2`, and `-O3`.

`make test-debuginfo` runs:

- `tests/debuginfo/o1`
- `tests/debuginfo/o2`
- `tests/debuginfo/o3`
- `tests/debuginfo/driver/o1`
- `tests/debuginfo/driver/o2`
- `tests/debuginfo/driver/o3`

The direct debug-info tests run `lowiropt -O*` over LowIR containing
`!dbg(...)` metadata. The driver debug-info tests run
`cppgm --emit-lowir -gline-tables-only -O*` and check that source locations
survive the source-to-LowIR optimizer path: the locations of
`../pa8/lowir.md` "Debug Locations", which each surviving, moved or copied
instruction keeps.

For each LowIR `.t` test, the harness records the tool exit status and compares the
generated output against the oracle for that test directory. Failed reference
cases are judged by exit status; successful reference cases are judged by the
directory's LowIR validation mode. Outside `tests/driver/o0`, the comparison
validates the facts of `../pa8/lowir.md` "Facts The C++ Lowering States" but
does not compare them: an optimizer may add a fact it proves, such as
`unwind=no` on a function whose body cannot throw, or drop one.

### Out Of Scope

PA33 does not require:

- input programs to arrive in SSA form
- PRE that requires critical-edge splitting, speculative trapping operations,
  or an unbounded insertion/fixed-point schedule
- alias-driven aggressive dead-store elimination
- partial unrolling, peeling, vectorization, or loop transformations beyond
  the bounded transformations needed by the fixture expectations; optional
  experiments are described in [improvements.md](improvements.md)
- machine-IR scheduling or register-allocation optimization
- unbounded interprocedural cloning, externally observable ABI changes,
  semantic body merging, or indirect-call specialization
- size-specific `-Os` or `-Oz` behavior

### After PA33

Later optimization tests build on this assignment by optimizing after LowIR has
already been lowered to machine IR. PA33 focuses on the LowIR optimization
pipeline and the `lowiropt` contract and quality checks.

### Assembly preservation

PA29's user assembly remains opaque through optimization. Preserve declared
memory/state effects, evaluated operands, ties, early writes, live values and
all outgoing/addressed control-flow edges. Do not reinterpret instruction
strings as arithmetic or infer undeclared effects. PA34's normal
`test-assembly` lane reuses the PA29 native/roundtrip controls at O3 after both
optimizer milestones, with independent result files for parallel reports.

### Optional typed library lane

`make test-lowir-library` runs the O1–O3 optimized library checks outside
the normal report. See [the library contract](../pa27/lowir-library.md).
