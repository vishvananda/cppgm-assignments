## CPPGM Programming Assignment 16 (`cppgm --emit-lowir`)

### Overview

PA16 extends PA15's first practical metaprogramming slice into a full language-level
constant-evaluation milestone. Its job is to make `constexpr` semantics a first-class part
of the compiler rather than leaving constant evaluation as only the small pragmatic subset
needed by PA15 template arguments and `static_assert`.

To complete PA16, implement these goals:

- `constexpr` function evaluation
- `constexpr` constructors, member functions, and variables
- constant initialization and object-valued constant evaluation
- a reusable constant-expression engine for both ordinary source semantics and later
  template machinery

PA16 still produces LowIR. It does not introduce a new output format.

### Prerequisites

You should complete Programming Assignment 15 before starting this assignment.

You will want to reuse:

- the preprocessing and tokenization pipeline from PA1-PA4
- the PA5 AST as the syntax boundary
- the PA6-PA7 semantic foundation
- the PA10-PA15 LowIR lowering path
- the PA8 LowIR contract
- the PA15 metaprogramming and integral constant-expression machinery

### Starter Kit

The starter kit contains:

- a `cppgm.cpp` assignment entry point, linked to the editable compiler source
  in `../dev/cppgm.cpp`
- the standard assignment `Makefile` and harness scripts
- the grammar for this assignment, `pa16.gram` (no HTML explorer ships for
  PA16)
- a checked-in local test suite under `tests/`

Extend the `cppgm` implementation you built in earlier assignments; the
initial scaffold is not reinstalled at this milestone.

Use the supplied reference tools to inspect example output. Tests compare
your compiler with the checked-in contract references.

### Input / Command-Line Arguments

The PA16 invocation is the unoptimized LowIR mode:

    $ cppgm --emit-lowir -O0 -o <outfile> <srcfile1> <srcfile2> ... <srcfileN>

Behaviour is undefined unless the command-line arguments match that shape, with
the same source-file ordering and `-o` relaxations as the earlier source-to-LowIR
milestones. Preserve the earlier dump modes. Native driver behavior and optimized
LowIR output are not required in PA16.

### C++20 immediate functions and constant initialization

In C++20 mode, `consteval` declares an immediate function or constructor.
Its potentially evaluated invocations outside an immediate function context
must be constant expressions, including implicit user conversions. Analyze
these invocations with the shared typed constant evaluator, and pass their
complete values to lowering. This applies to scalar, object, reference and
void results at every optimization level. Calls inside an immediate function
are evaluated as part of its enclosing invocation. Immediate function addresses
can be used inside these evaluations, but cannot escape into a constant result
or runtime code. Redeclarations must repeat the same specifier. `consteval`
cannot declare a variable, destructor, allocation or deallocation function.
The existing constexpr virtual-call limitation remains; C++23 `if consteval`
and immediate-function escalation are outside this profile.

`constinit` requires constant initialization and static or thread storage.
It does not add `const`, make a mutable variable usable in constant expressions,
or require a literal class type. PA30's hosted `__constinit` extension uses
the same rules. Both new words remain identifiers in C++11–17;
`__cpp_consteval` is `201811L` and `__cpp_constinit` is `201907L` in C++20.
Immediate lambda call operators compose with PA20's closure rules.

### Fixed template arguments in function bodies

A nondependent constant expression used as a template argument in a retained
function-template body has its fixed value at definition time. A local alias
for that specialization is nondependent, so its member types do not require
`typename`. Body-local expressions need no shared expression key to establish
this fact; arguments that name template parameters remain dependent.

### Defaulted constructors and constant values

For defaulted scalar constructors, this course follows CWG 1360 and its adopted
resolution in `doc/cwg/paper-p2448r2.txt` (under the repository root).
Scalar members without initializers do not disqualify the defaulted constructor
from constant evaluation. Value-initialization zero-initializes those members
before invoking the constructor. Default-initialization can leave them
indeterminate; a required constant object or an indeterminate read still fails
constant evaluation. Keep constructor eligibility separate from the initialized
values of each actual object.

In C++20, a constexpr constructor may also leave a trivially
default-initialized member indeterminate. Track that state during
evaluation. A later assignment can initialize it before a read, and a
transient object's unread member may stay indeterminate. A required
constant object still needs initialized values for its subobjects. See
N4861 `[dcl.constexpr]` and `[expr.const]`.

In C++14 and later, a defaulted union copy or move in a constant expression
copies the source's active member. A defaulted assignment may change which
member of the destination is active. The old member ends its lifetime, and
the copy does not read any inactive member. See N4659 `[class.copy.assign]`
and N4861 `[class.copy.assign]`.

When a defaulted copy or move constructor initializes an array member,
apply the selected constructor to each class element in order. This also
applies to elements of a multidimensional member array. See
`[class.copy.ctor]` in the [C++17 draft](../doc/n4659.pdf).

### Constant initialization of nonliteral objects

A constexpr member function's enclosing class need not be a literal type
(CWG 1684; see `doc/cwg/cwg-1684.txt` under the repository root). Its own
parameter and result types still satisfy the constexpr rules. Calling it
does not make an ordinary object's stored values constant expressions.

A static object's constexpr constructor can initialize nonliteral base and
member subobjects, including array elements, before dynamic initialization.
The subobjects share the initialized variable's storage identity. This does
not permit nonliteral initializer temporaries in constant expressions or
constexpr variables of nonliteral type.

### Unknown references and persistent constant objects

Apply adopted P2280R4 when a constant evaluation passes an unknown reference
or uses `this` for implicit or explicit member access. The referred object's
type and subobject layout are known even when its stored values are not.
A constexpr member returning a fixed property can be called through that
reference; reading an unknown member value, an ordinary pointer value or a
non-constexpr reference-producing call still fails. An unspecified object's
address cannot escape as the result of a constant expression.

Under CWG 2126, a const literal temporary whose lifetime a usable reference
extends can supply its nonmutable values. Keep the temporary's identity,
including pointers to itself or its subobjects, when publishing constant
storage. Other local objects do not gain static lifetime from that publication.

### Output Format

On success, `cppgm` shall write LowIR text to `<outfile>` and exit
`EXIT_SUCCESS`.

The authoritative LowIR definition is `../pa8/lowir.md`. PA16 extends the PA15 lowering
surface only by making more of the C++ source language lower into the already-defined LowIR
family.

LowIR top-level declaration/definition order is a presentation convention, not
a dependency order. Reference outputs and canonical dumps use the order defined
in `../pa8/lowir.md`: `declare global`, `declare function`, `global`, then
`function`, but the relaxed LowIR comparison canonicalizes top-level entries
before comparison. Your output must still be repeatable for the same
inputs; `../pa8/lowir.md` defines the canonical reference presentation and
notes where internal LowIR symbol names are only a presentation tie-breaker.
Your output must also preserve order-sensitive LowIR regions when they are present: instruction order inside
blocks, item order inside structured globals, vtable slot order, and action
order inside generated initialization, finalization, constructor, destructor,
and cleanup bodies.

The test harness checks that the generated LowIR is well formed and matches the
checked-in `.ref` files after canonicalizing presentation details that are not
part of the assignment contract: the names of temporaries, slots, blocks and
parameters, the order of slot declarations and of top-level entries, and the
spelling of literals (`../pa8/lowir.md`, "What The Comparison Absorbs And What
It Enforces", is the one list). Exact textual LowIR matching is not a PA16
grading requirement, but every instruction of a body must match the
reference's after that canonicalization, in its order.

### Error Handling

If an error occurs during preprocessing, tokenization, parsing, semantic analysis, or LowIR
generation, `cppgm` shall `EXIT_FAILURE`.

The output file is not required to be meaningful on failure.
Diagnostics are not part of the grading contract.

### Standard Output / Error

Standard output and standard error are ignored for automated testing of `cppgm`.

You are free to use them for debugging, tracing, or diagnostic messages.

### Testing

PA16 tests live under `tests/`. The suite is split by test role:

- `tests/spec/` contains N3485/spec-anchored constant-evaluation tests. Each
  provided C++ language test in this directory starts with a leading comment of the
  form `// N3485 focus: 7.1.5 [dcl.constexpr] ...` or another exact governing
  clause so a reviewer can find the text in `../doc/n3485.txt`.
- `tests/general/` contains broader constexpr cross-feature and realistic
  constant-evaluation examples that are useful for PA16 but are not one-rule
  spec probes.

The `make test` target runs both directories through the LowIR validator. For
successful tests, the validator checks the reference LowIR and your generated
LowIR for basic structural correctness, then compares the canonicalized LowIR
against the checked-in reference. For rejected tests, the exit status is the
checked result; exact diagnostic text is not checked.

Self-checking controls in `tests/controls/` state their expected outcome in
their leading comment (`expect exit N` or `expect reject`) or in an
`x.expect` sidecar. `make test` compiles each with your
`cppgm --emit-lowir -O0`, builds the LowIR with the supplied
`lowir2native-ref -O0` and requires the stated exit status (and the output in
`x.stdout`, when present), or requires your frontend to reject the program.
The LowIR text of a control is not compared. `make test-controls` runs only
the controls; `make check TEST=tests/controls/<name>.t` runs one.

### PA16 Syntax Boundary

The authoritative source syntax is the shared `cppgm` source grammar, exposed
for this assignment as `pa16.gram`. The grammar defines accepted syntax only;
the PA16 semantic and lowering requirements are defined by the Assignment
Boundary and Out Of Scope sections below.

### Optional Student Test Ideas

When adding your own tests, useful PA16 themes include C++11 `constexpr`
declaration validity, literal type requirements, constant initialization, core
constant-expression rejection, pointer/reference constant evaluation, and
aggregate/object-valued constant evaluation.

### Assignment Boundary

PA16 owns full `constexpr` / constant-evaluation semantics over the implemented language
surface inherited from PA15, including:

- full constant-expression evaluation for the implemented expression/type subset
- `constexpr` functions
- `constexpr` constructors and member functions
- `constexpr` variables and constant initialization
- floating-point `constexpr` evaluation over the implemented scalar language surface
- `noexcept` constant expressions over the supported call/expression subset
- object-valued, pointer-valued, and reference-valued constant evaluation where the earlier
  language/object-model milestones already define the underlying semantics
- reuse of the constant evaluator for ordinary language semantics, template arguments, and
  `static_assert`

Floating constant evaluation uses the target precision of each operation:
binary32 for `float`, binary64 for `double`, and x87 extended for `long double`.
Static initialization and runtime arithmetic use the same precision, as defined
for their LowIR types in [the LowIR contract](../pa8/lowir.md).

The intent is no longer a pragmatic subset. By the end of PA16, `constexpr` should be a
complete compiler-owned semantic layer for the supported language profile, not a
collection of special cases.

More concretely, over the already-implemented language subset, PA16 should cover the full
C++11 `constexpr` forms that later template and library code expect:

- scalar, floating, `nullptr`, and enum constant expressions
- unary, arithmetic, comparison, bitwise, logical, conditional, cast, `sizeof`,
  `alignof`, `sizeof...`, and `noexcept` constant expressions where those operators are
  already part of the supported language surface
- `constexpr` free-function calls, including recursive calls and default arguments
- `constexpr` constructors, including member-initializer lists and base/member
  initialization for literal class types; access checks performed while
  evaluating those initializers use the constructor's class context, so a
  derived constructor may invoke an accessible protected base constructor
- `constexpr` member-function calls on constant objects
- `constexpr` function templates and `constexpr` member functions of class
  templates, including dependent return and parameter types: the literal-type
  requirements are checked on the template's declaration, and a
  specialization whose instantiated types are not literal is still a valid
  function, only not `constexpr` (7.1.5p6)
- constant object values, not just integral scalars:
  - aggregate/class values
  - array values
  - nested aggregate/array values
- member access on constant objects via `.`
- array and string-literal element access via `[]`
- `constexpr` variables whose initializers must be fully evaluated at compile time
- an automatic nonvolatile array of trivial scalar elements whose complete
  initializer is known at compile time is initialized from readonly constant
  data with one object copy at any number of dimensions; an entirely zero-byte
  representation uses a direct bulk zero. Each automatic array still has
  distinct storage
- reference-valued constant evaluation and `const T &` / reference parameter passing where
  the implemented object model already defines the underlying semantics
- reference initialization consumes the typed list's temporary or directly
  bound element, including direct braces and aggregate reference members.
  Array temporaries retain an explicit prefix and omitted zero tails during
  evaluation; reads preserve their full bounds and identities. Omitted
  multidimensional arrays retain nonzero constexpr class defaults. Construct
  only initialized prefix elements, reuse proven zero-default type facts,
  and project zero-tail subobjects through their typed layout rather than
  constructing unrelated fields. Preserve union activity and bit-field values.
  Bound dense expansion of implicit tails as well as ordinary evaluation.
  An optional probe that exceeds its storage budget fails softly so an
  ordinary runtime initializer can still compile
- lookup and reuse of previously computed constant values, including qualified lookup and
  static data members
- function-local static objects over the supported LowIR subset:
  - serialized LowIR and direct object compilation use the same
    `__cxa_guard_acquire`, `__cxa_guard_release` and exception-abort protocol
    for dynamic initialization. The host runtime makes it thread-safe;
    the standalone LowIR/native runtime supplies single-threaded guards,
    so concurrent initialization remains outside that execution boundary.
    A function-local thread-local object keeps its per-thread guard
  - constant initialization when the initializer is a constant expression
  - dynamic class-object local statics with the required guard/check behavior, including
    direct initialization from a class-prvalue factory call
  - a temporary bound to a local static reference persists for the
    reference's lifetime (12.2p5): it occupies static storage, not the
    initializing call's frame, and is destroyed at exit with the other
    static objects (thread storage for a `thread_local` reference)
  - one object per declaration wherever the body is lowered more than once: a
    constructor's or destructor's complete and base-subobject entries share
    their statics (N3485 6.7p4)
- ordinary namespace objects whose constant-initialization probe encounters a
  core constant-expression failure use dynamic initialization; only contexts
  that require a constant expression are rejected for that failure
- constant initialization of ordinary arrays evaluates their explicit scalar
  elements, including pointer and floating results of constexpr calls and
  conversions, while retaining omitted zero tails as compact ranges. It must
  not require a dense constant value for every omitted element
- a `constexpr` object is const, so one that is statically initialized states
  `storage=readonly` when its class has no `mutable` member and no
  non-trivial destructor, as PA11's const objects do; the temporary that a
  constant-initialized reference binds is readonly by its own type
  (`const int& r = 3` binds a readonly `const int`, `int&& r = 3` a writable
  `int`)

A call that constant evaluation replaces by its value does not make the
function used in emitted code, so a `constexpr` function whose every call is
evaluated at compile time (in a `static_assert`, a template argument, an
array bound, an enumerator or a constant initializer) need not be emitted.
The comparison accepts output with or without such unreferenced definitions.

PA16 also owns the semantic validation side of C++11 `constexpr`, not just evaluation. In
particular, the compiler should enforce the C++11-facing rules that matter for the
supported language subset, such as:

- `constexpr` variables require a compile-time initializer and a literal type
- A union can be a literal type with a non-volatile literal member even if another
  member has a nonliteral type. A constant evaluation still has to initialize
  the active member as required for a constant expression.
- a static data-member initializer is not a complete-class context: it cannot
  evaluate a member function body of its still-incomplete enclosing class,
  even when that body appears earlier in the class. Once the class closes,
  those defined `constexpr` members may be used in constant expressions
- `constexpr` function return and parameter types must be literal types
- `constexpr` constructors must produce literal objects through valid base/member
  initialization
- invalid `constexpr` declarations should fail during semantic analysis instead of being
  accepted and only failing later during use
- an executed declaration whose initializer is not constant invalidates the enclosing
  constant evaluation even when the declared value is not read
- a member call on a temporary is constant only when construction of that temporary is
  itself a valid constant expression

The implementation may support a strict superset of C++11 evaluation rules internally,
such as local variables, assignment, and loops inside constexpr evaluation. That is fine
and often useful for later milestones, but it does not reduce the requirement that the
standard C++11 forms above be covered cleanly and intentionally.

Constant evaluation is bounded, as Annex B allows. Support at least 512
nested `constexpr` calls, Annex B's figure. An evaluation that nests deeper,
or does more work than your evaluator's own limit, is not a constant
expression: a context that requires one is rejected, and a namespace object
falls back to dynamic initialization as above. Runaway recursion must end in
a clean rejection, not a crash or a hang.

### Constant reference-conversion decay

Constant evaluation preserves the designated array or function address when
a user-defined reference conversion is followed by decay. Apply the recorded
standard suffix to that pointer, and retain ordinary pointer lifetime and
one-past-array checks; a pointer to a destroyed temporary is not publishable.

### Constant evaluation across the required modes

The existing relaxed constexpr body subset remains required: local variables,
assignments, branches and bounded loops can participate when every evaluated
operation satisfies the constant-expression rules. Retain lifetime, forbidden
body-operation and nonconstant-evaluation diagnostics. The default GNU C++11
course mode retains the relaxed body rules. In ISO C++11, apply N3485
`[dcl.constexpr]` to the written body. An ordinary definition needs exactly one
return statement and may also contain the allowed empty statements and
declarations. A constructor body may contain those same auxiliary statements
and declarations. Some later statements, such as an extra return or a local
variable declaration, can be admitted by the C++14 extension diagnostic.
A loop still requires C++14 when compiling with strict language diagnostics.
A block-scope `extern` declaration in a C++14 constexpr function can name
an object with linkage. Taking its address can be a constant expression.
The declaration starts no local object lifetime.
See PA30 for the system-header and diagnostic pragma controls.

Apply the selected edition's aggregate initialization and C++17 result-object
rules during constant evaluation, including default member initializers and
inline static constexpr members. Lambda constant evaluation is introduced with
closures in PA20. Read N4140 `[dcl.constexpr]` and `[expr.const]`, then N4659's
corresponding clauses for the required later rules.

A trivial constexpr copy from a static constexpr member can initialize the
destination from its evaluated value. The destination has its own storage,
even when the source member supplies only an in-class initializer.

In C++11, passing a static constexpr data member by reference ODR-uses it.
The class's initializer supplies its value, and a definition at namespace
scope without an initializer supplies storage. For example, the
[reference-binding control](tests/controls/300-static-constexpr-member-reference.t)
defines the member before passing it to a `const unsigned&` parameter. Removing
that definition can leave an undefined symbol at link time. See N3485
`[class.static.data]` paragraph 3.

### C++20 literal types and transient allocation

A class may be a literal type with a constexpr destructor. For a defaulted
destructor, determine eligibility from the base and member destructors.
A destructor declared constexpr must satisfy the C++20 requirements for
its subobjects. A virtual destructor can be constexpr and run when
deleting an object allocated during the same constant evaluation. For a
constexpr variable, check hypothetical destruction
separately and preserve the value computed by its initializer. The object
and its non-mutable subobjects begin their lifetimes in that check. See
N4861 `[basic.types]`, `[dcl.constexpr]` and `[expr.const]`.

During evaluation, destroy automatic variables on scope exit in reverse
initialization order. This includes exits through `break`, `continue`, and
`return`, and the scope of an unbraced substatement. Evaluate a return
operand before destroying the block's variables. Apply the ordinary
constant-expression rules to operations the destructor actually executes.
See N4861 `[stmt.dcl]`, `[stmt.iter]`, `[stmt.jump]` and `[stmt.return]`.

Destroy materialized temporaries in reverse construction order at the end
of their full-expression. An initializer, a condition, and a return operand
each have their own boundary, including the conversions and initialization
they perform. A local reference can extend the complete temporary's lifetime
when it binds to the temporary or one of its subobjects. A temporary bound
to a reference member of that temporary can follow it into the same scope.
A call returning a reference does not extend its referent's lifetime.
By-value class parameters
passed by address with nontrivial destruction are destroyed with the caller's
temporaries. See N4861 `[intro.execution]`, `[class.temporary]`, and `[expr.call]`.

A C++20 constant expression may use `new` with a replaceable global
allocation function. For scalar and array allocations, keep the new object's
identity across calls and scopes within the evaluation. It must be released by
the matching form of `delete` before the evaluation completes. Diagnose an
attempt to access deallocated storage or to preserve its address in the result.
Run the destructor body before destroying members and bases in reverse
construction order. Array elements are destroyed last first. See N4861
`[expr.const]`, `[expr.new]`, `[expr.delete]` and `[class.dtor]`.

An explicit destructor call in a C++20 constant expression follows the
same destruction order. A scalar pseudo-destructor call also ends its
object's lifetime. Track the lifetime separately from the storage so
accesses after destruction fail. Reject ordinary placement `new` in a
C++20 constant expression. The hosted `std::construct_at` exception is
exercised in PA31. See N4861 `[basic.life]`, `[expr.call]` and `[expr.const]`.

### Out Of Scope

The following are explicitly out of scope for PA16:

- template language features that still remain deferred to PA17
- constant-evaluation operations beyond the required profile; lambda objects arrive with PA20
- hosted/vendor-only compatibility forms that are not part of the standard C++ language

Inputs that rely on those features have undefined behaviour for this milestone.

### Stage Handoff

The intended next stages are PA17 and PA18, which finish the remaining standard template
language using the now-complete constant-evaluation engine:

- PA17: complete the template entity and specialization model
- PA18: complete deduction, substitution, and SFINAE over that model

So PA16 should leave behind:

- a stable constant-evaluation semantic layer
- ordinary lowered declarations that no longer depend on PA15-specific constant-expression
  shortcuts
- a clear boundary where the remaining template-language work can build on real `constexpr`
  support rather than special-casing it

Automatic scalar-array image eligibility depends on the evaluated initializer,
not on whether the declaration spells `constexpr` or `const`. PA10 establishes
the literal-initializer case; PA16 adds general constant evaluation. Readonly
images may be shared, while each automatic array retains its own storage and
mutable arrays remain writable. Nonconstant initializers retain runtime evaluation, and volatile
arrays retain their required stores. Class construction and destruction stay
on their typed lifetime paths.

For automatic scalar initializers, use the constant value already recorded by
semantic analysis whenever the scalar can represent it, including at `-O0`.
This includes member calls and functional casts as well as free-function calls.
Keep the local's storage addressable and preserve required volatile stores.
Evaluate initializers without a proven constant value at runtime, preserving
their side effects.

### Design Notes (Non-Normative)

The useful shape for PA16 is one typed constant-evaluation layer shared by
`constexpr`, template arguments, `static_assert`, constant initialization, and
ordinary semantic checks.

Useful intermediate representations include:

- typed constant values for scalars, enums, pointers, references, arrays, and
  class objects
- a distinction between checking whether a declaration is valid `constexpr` and
  evaluating an expression in a constant-evaluation context
- reusable evaluated-value storage for bindings whose constant value is needed
  by lookup, template arguments, and later LowIR lowering
- typed structural interning of identical automatic constant-data templates,
  using data-item kinds, values, symbol identities, addends, size, and alignment
  rather than rendered LowIR text
- local-static initialization metadata that records whether LowIR lowering can
  emit a constant initializer or must emit guarded dynamic initialization

### C++20 requires-expressions

In C++20 mode, retain requires-expressions as parsed requirements. Simple
requirements check an unevaluated expression, type requirements name a type
without demanding its definition, compound requirements can require `noexcept`,
and nested requirements check boolean constant constraints. Local parameters
use function-parameter adjustment, with no default arguments or terminal
varargs ellipsis. Invalid immediate substitution makes a template requirement
false; an invalid requirement outside a templated declaration is an error.
Check in source order and stop once satisfaction is known. Constraint `&&` and
`||` short-circuit substitution as well as evaluation. Later template and
constant-evaluation assignments apply these rules to their added source forms.

### C++20 named concepts

A concept is a namespace-scope template definition with a boolean constraint;
it is not a variable or an emitted specialization. A concept-id is a bool
prvalue. Reuse template argument matching, defaults, parameter packs and the
constant-evaluation layer introduced by this assignment and its prerequisites.
Cache satisfaction by concept identity and canonical arguments, detect recursive
satisfaction and preserve substitution short-circuiting. A compound requirement
`{ expression } noexcept -> Concept<Args...>;` checks the expression, then its
non-throwing property, then the concept with `decltype((expression))` prepended
to its explicit arguments. Its value category and cv-qualifiers are preserved.

### C++20 comparison constant evaluation

Evaluate the recorded three-way comparison and rewritten candidates through
the shared constant evaluator. Read the real category objects and honor
short-circuit subobject order, array loops, conversions, constexpr
eligibility and non-throwing facts for defaulted comparisons.

### C++20 comparison templates

Instantiate defaulted and rewritten comparisons using the same typed
operator resolution as ordinary functions. An unavailable or deleted
comparison fails an immediate requirement; it must not make the enclosing
class template invalid before the comparison is demanded.
