## CPPGM Programming Assignment 38 (`cppgm++ --emit-lowir -x c`)

### Overview

This optional assignment adds C input to the existing compiler. It uses the
same LowIR boundary as PA10 through PA23: a `.t` source file is parsed and
analyzed once, then lowered to the PA8 LowIR model. Both output backends use
those typed facts. A C input must not be translated into C++ or passed to an
external C compiler.

PA38 is experimental and is excluded from the normal C++ test report. It does
not change the required C++ assignments or their language rules.

### Prerequisites

Complete the source frontend, typed LowIR lowering and hosted-header work
through PA30. PA37 is needed for the additional Wasm test target.

### Driver and output

The assignment's test mode is:

```sh
cppgm++ --emit-lowir -O0 -x c -std=c17 -o output.lowir input.t
```

`-std=gnu17` selects the GNU extension dialect. It also accepts discarding
immediate object-pointer qualifiers and conditional character/string escapes
such as `\%` (whose value is `%`), as hosted GNU C libraries require. This does
not make differently qualified types compatible or allow unrelated pointer
conversions, nested qualifier removal, or removal of atomic qualification.
Strict `-std=c17` retains its qualifier and escape diagnostics. The input language and target
are separate choices. `-x c++` continues to select C++; a language and standard
that disagree must be diagnosed. The existing `.c` handling is unchanged unless
C is selected explicitly.

The output is ordinary [PA8 LowIR](../pa8/lowir.md). Preserve target sizes,
alignment, function signatures, object names, qualifiers and conversions. C
functions and objects use their C ABI names. A C++ `extern "C"` declaration
continues to have C++ syntax and semantics; language linkage does not select C.

### Initial C profile

The first fixture set covers these parts of the C17 input profile:

- C keywords, preprocessing tokens, feature macros and C++ keywords used as
  ordinary C identifiers; `_Bool`, `_Static_assert`, `_Alignas`, `_Alignof`
  and `_Noreturn` use their C meanings.
- Procedural scalar and pointer expressions, control flow, prototype-based
  function declarations, calls, callbacks and variadic argument promotions;
  declarations without prototypes use default argument promotions and compatible
  later prototypes retain their parameter checks. C17 identifier-list (K&R)
  definitions retain each parameter's declared object type while their public
  signature uses default argument promotions; declarations and earlier/later
  prototypes must remain compatible.
- Implicit conversions between object pointers and qualified `void*`, without
  discarding pointee qualifiers; integral initialization of enumeration objects.
- GNU C pointer extensions used by hosted libraries: implicit conversions
  between function pointers and `void*`, and between pointers to corresponding
  signed/unsigned integer types (including the three character types).
  Pointer-sign conversions preserve the address and accept qualification
  differences as LLVM does. They do not make the pointed-to types compatible
  for `_Generic` or `__builtin_types_compatible_p`.
- `_Generic` selections preserve the selected expression's type and value
  category. The control and unselected associations are not evaluated.
- C character and string literal types, including the compatible integer
  types of wide, UTF-16 and UTF-32 literals. Comparisons and logical operators
  produce `int`. Assignment, comma, conditional and prefix increment results
  do not become C++ lvalues.
- Separate tag and ordinary identifier namespaces, including typedefs that
  reuse a tag spelling for an unrelated type; struct and enum tags, typedefs,
  aggregate initialization, C member and array
  designators, member access,
  function parameters and results, C object linkage and tentative definitions.
- C compound literals of scalar, pointer, record and array types, including
  array-bound deduction and designators. Each occurrence denotes an lvalue;
  block-scope objects survive the full expression and file-scope objects have
  static storage with constant initialization.
- One-dimensional block-scope variable-length arrays with automatic or
  register storage. Evaluate each bound once at its declaration, retain that
  extent for `sizeof`, and release the storage on every scope exit, including
  `break`, `continue`, `return` and `goto`. A jump or switch case must not enter
  a runtime array's scope past its declaration. Preserve element alignment and
  explicit alignment requests. Array decay and pointers formed by `&array`
  use the actual saved extent.
- Hosted C header declarations and their builtin operations through the
  existing hosted environment, including PA30's GNU startup-function attributes.

This is an initial profile, not a claim of complete C17 conformance. Use
`(void)` for a prototype with no parameters; an empty `()` declares a function
without a prototype. Variably modified typedefs, pointer declarations,
parameters and type-ids, multidimensional runtime arrays, and positional
continuation after a nested designator remain outside this fixture set. Diagnose
these unsupported forms. Extend the profile and its tests together. Do not silently
apply a C++ rule where a supported C construct has a different meaning.

Share preprocessing, declarator parsing, type storage, ABI classification,
optimization and backend machinery with the C++ path. Record the source
language explicitly. Retain semantic facts through lowering rather than
reclassifying rendered source or LowIR text.

### Tests and reference tools

The directory and test commands follow the other LowIR frontend assignments:

```sh
make
make test
make check TEST=tests/general/100-language-facts.t
make run INPUT=tests/general/100-language-facts.t
make ref-test
```

`tests/general/*.t` inputs produce LowIR and are compared with the checked-in
reference outputs. A `.c-standard` sidecar selects `c17` or `gnu17` for an
individual fixture; controls use the same convention. Rejected inputs have the usual failure-status reference.
An adjacent `.t.1` adds another translation unit, as in the earlier source
assignments. `tests/controls/*.t` state an expected program result and run the
generated LowIR through the supplied native backend. There is no second C
compiler or compiler-to-compiler comparison in this assignment's test lane.

`make test-wasm` runs the same source inputs through PA37's Wasm checker and
their `.wasm-expect` result sidecars. It requires the pinned Wasm tools and SDK.
From the repository root, `make test-pa38` selects this assignment explicitly;
`make test-c` and `make test-c-wasm` are convenience aliases.
