## CPPGM Programming Assignment 18 (`cppgm --emit-lowir`)

### Overview

PA18 is the second half of template completion. Its job is to finish the
remaining single-feature deduction/substitution behavior so ordinary generic
C++11 code stops depending on a pragmatic template subset.

PA18 still produces LowIR. It does not introduce a new output format.

### Prerequisites

You should complete Programming Assignment 17 before starting this assignment.

You will want to reuse:

- the preprocessing and tokenization pipeline from PA1-PA4
- the PA5 AST as the syntax boundary
- the PA6-PA7 semantic foundation
- the PA10-PA17 LowIR lowering path
- the PA8 LowIR contract
- the PA14-PA17 template machinery
- the PA16 full constant-evaluation layer

### Starter Kit

The starter kit contains:

- a `cppgm.cpp` assignment entry point, linked to the editable compiler source
  in `../dev/cppgm.cpp`
- the standard assignment `Makefile` and harness scripts
- the PA18 deduction/substitution test suite under `tests/`

Extend the `cppgm` implementation you built in earlier assignments; the
initial scaffold is not reinstalled at this milestone.

Use the supplied reference tools to inspect example output. Tests compare
your compiler with the checked-in contract references.

### Input / Command-Line Arguments

The PA18 invocation is the unoptimized LowIR mode:

    $ cppgm --emit-lowir -O0 -o <outfile> <srcfile1> <srcfile2> ... <srcfileN>

Behaviour is undefined unless the command-line arguments match that shape, with
the same source-file ordering and `-o` relaxations as the earlier source-to-LowIR
milestones. Preserve PA7's dump mode. Native driver behavior and optimized
LowIR output are not required in PA18.

### Substituted member types

For a built-in pointer comparison, a known pointer operand can supply the
target for deducing the other operand's conversion-function template. Include
the resulting candidate in normal overload resolution; explicit conversions
remain unavailable implicitly.

A substituted `typename T::member` must denote a type. A member class or alias
template without template arguments rejects an overload in the immediate
substitution context. An actual nested class remains a type even when incomplete;
a template-template argument still denotes its template. Rejection uses the
substitution result and does not instantiate an unused member-template body.

Equivalent dependent expressions in function-template declarations retain the
identity of the class template they name, including when a later declaration
adds namespace qualification or uses a namespace alias. Different templates or
template arguments remain distinct. The first declaration retains its ABI spelling.

Non-deduced constraints compare their substituted operands during partial
ordering. Unused template arguments, including an empty pack, do not distinguish
otherwise equivalent expressions or cause substitution to fail. Preserve
different member names and argument positions, even when a concrete
specialization gives them equal values.

A transformed ordering operand can become independent even while other
template arguments remain dependent. Evaluate that proven independent
operand in its ordinary substitution context, preserving access checks and
immediate substitution failures. Source declarations retain the dependent
spellings required by the ABI; operands that still depend on arguments remain
deferred.

A qualified member function template-id that names no function template is a
substitution failure in an immediate context, including an address used as a
non-type template argument. Outside substitution, the same invalid name remains
a hard error; errors in instantiated function bodies remain hard errors too.

Invalid value-initialization of a function type, excess aggregate initializer
elements, and nonempty parenthesized array-new initializers fail substitution
when they occur in an immediate context. The same invalid initializers remain
hard errors in ordinary expressions and instantiated function bodies.

### Output Format

On success, `cppgm` shall write LowIR text to `<outfile>` and exit
`EXIT_SUCCESS`.

The authoritative LowIR definition is `../pa8/lowir.md`. PA18 extends the
PA17 lowering surface only by making more of the C++ source language lower into
the already-defined LowIR family.

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
part of the assignment contract. Exact textual LowIR matching is not a PA18
grading requirement.

A runtime user-defined conversion in a conditional remains a call in unoptimized
LowIR, including a conversion that returns a named static constant or template
argument. Scalar conditional values retain the branch, store and merge form
from PA8. Constant-expression evaluation still uses the PA16 semantic engine.

### Error Handling

If an error occurs during preprocessing, tokenization, parsing, semantic
analysis, or LowIR generation, `cppgm` shall `EXIT_FAILURE`.

The output file is not required to be meaningful on failure.
Diagnostics are not part of the grading contract.

### Standard Output / Error

Standard output and standard error are ignored for automated testing of
`cppgm`.

You are free to use them for debugging, tracing, or diagnostic messages.

### Testing

PA18 tests live under `tests/`. The suite is split by test role:

- `tests/spec/` contains N3485/spec-anchored deduction, substitution, and
  SFINAE tests. Most carry a `// N3485 focus: 14.x.y [clause.name] ...`
  comment near the top, naming the governing text in `../doc/n3485.txt`.
- `tests/general/` contains broader generic-program examples that are useful
  for PA18 but are not one-rule spec probes.

The `make test` target runs both directories through the LowIR validator. For
successful tests, the validator checks the reference LowIR and your generated
LowIR for basic structural correctness, then compares the canonicalized LowIR
against the checked-in reference. For rejected tests, the exit status is the
checked result; exact diagnostic text is not checked.

This split assignment intentionally focuses on the deduction/substitution half
of template completion:

- full function-template deduction
- function-template partial ordering
- non-deduced contexts and braced-init, array-bound, and conversion deduction
  corners
- SFINAE and substitution failure
- no-eager-instantiation timing and dependent-call behavior

Self-checking controls in `tests/controls/` state their expected outcome in
their leading comment (`expect exit N` or `expect reject`) or in an
`x.expect` sidecar. `make test` compiles each with your
`cppgm --emit-lowir -O0`, builds the LowIR with the supplied
`lowir2native-ref -O0` and requires the stated exit status (and the output in
`x.stdout`, when present), or requires your frontend to reject the program.
The LowIR text of a control is not compared. `make test-controls` runs only
the controls; `make check TEST=tests/controls/<name>.t` runs one.

### PA18 Syntax Boundary

The authoritative source syntax is the shared `cppgm` source grammar, exposed
for this assignment as `pa18.gram`. The grammar defines accepted syntax only;
the PA18 semantic and lowering requirements are defined by the Assignment
Boundary and Out Of Scope sections below.

### Optional Student Test Ideas

When adding your own tests, useful PA18 themes include explicit template
arguments mixed with deduced ones, function-address deduction, conversion
function template deduction, constructor-template participation, richer
non-deduced contexts, and compact `enable_if` / `void_t` / detector patterns.

### Assignment Boundary

PA18 owns the remaining advanced single-feature standard template behavior over
the implemented surface, including:

- full function-template deduction over the intended C++11 subset
- function-template partial ordering
  From C++14, a shorter template-id can match the trailing defaults of a
  longer template in the supported template-template deduction case.
  During partial ordering, compare the concrete template pattern using
  its substituted trailing arguments. See N4659 `[temp.deduct.type]`
  and the matching example in [CWG 2398](../doc/cwg/cwg-2398.txt).
- substitution behavior and candidate dropping
- when a return type uses a variable template, a dependent template argument
  must name a template that matches its parameter. An invalid argument in
  the immediate substitution context discards the candidate. See N4140
  `[temp.arg.template]` and `[temp.deduct]`.
- `enable_if`, `void_t`, and detected-idiom style SFINAE behavior
- when an expansion in a trailing return type names a function parameter
  pack, substitute the parameter at the same position as the selected
  template arguments. See N4140 `[temp.variadic]` and `[temp.deduct]`.
- conversion function template deduction
- conversion template ABI names retain the declared target pattern, including
  explicit specializations and cv/reference target arguments
- constructor template deduction and overload participation
- a default template argument retains dependence on both operands of a
  logical operator. Short-circuit evaluation can skip an operand after
  substitution. Check a constructor template's dependent default when the
  candidate needs it. See N4140 `[temp.dep.constexpr]` and `[temp.deduct]`.
- when deduction checks an argument's specialization against a template
  template parameter, resolve the specialization's default arguments where
  they were declared, including defaults added by redeclarations. See N3485
  `[temp.param]`, `[temp.res]` and `[temp.deduct.type]`.
- a dependent member variable template can supply the value in a constructor
  template's default argument. Preserve the `template` disambiguator and
  substitute the value when checking the constructor candidate. See N4140
  `[temp.arg.nontype]`, `[temp.dep.temp]` and `[temp.deduct]`.
- non-deduced contexts and explicit template-id deduction edge cases
- CWG 1391: after deduction and defaults, conversions to originally
  nondependent call parameters are checked before signature substitution
- braced-init deduction in the supported template-call subset
  includes CWG 1591: a nonempty braced list deduces array element types and
  named bounds, as GCC and Clang apply the resolution in C++11 mode
- pointer, reference, enum, and static-member non-type template argument values
  over the supported constant-expression subset
- template deduction from arguments whose types come from already-resolved
  member-function calls, including the implicit-object overload selection from
  PA11/PA12
- an argument that names a set of overloaded functions participates in
  deduction the same way whether the called template was found by ordinary
  lookup or only by argument-dependent lookup
- a dependent unqualified call in a declaration uses ordinary lookup at
  its declaration point. If that lookup finds nothing, a later member
  declaration does not hide a function found through argument-dependent
  lookup during substitution
- dependent-call, dependent-alias, and no-eager-instantiation behavior when the
  primary assertion is a single PA18-owned feature rather than a broad
  multi-feature composition
- equivalent redeclarations of a function template with a dependent result
  type name the same template, however many such templates a translation unit
  declares (14.5.6.1)

In C++17, a deduced non-type argument in a partial specialization also
supplies deductions for parameters in its declared type. A reference to
an array can supply its bound. Retain the usual matching and
substitution checks. See N4659 `[temp.deduct.type]`.

A fixed pointer, reference, or function-address argument in a function-template
body also forms a nondependent specialization. Its local alias can name member
types without `typename`; an argument using a dependent qualifier retains the
usual disambiguation and substitution rules.

### C++17 deduction and expanded using declarations

Deduce constructor-based class template arguments before initializing the
selected specialization. Include the existing constructor-template, array
reference, default and pack cases. Declared deduction guides add candidates
associated with their class template, not ordinary callable functions.
Preserve explicitness, defaults and the copy-deduction/list-initialization
rules; diagnose equivalent guides and invalid result specializations.
See N4659 `[over.match.class.deduct]` and `[temp.deduct.guide]`.

A deduction use that names a template template parameter depends on its
argument. When that argument is a class template, use its guides after
substitution. This follows GCC and Clang for the class-template case in
[CWG 3003](../doc/cwg/cwg-3003.txt).

Placeholder non-type parameters (`auto`, `auto*`, `auto&`, `decltype(auto)`)
deduce type and value while retaining object/function identity, references
and heterogeneous packs. The resulting argument must still be a permitted
C++17 template argument. An evaluated pointer to a named object or function
keeps that identity, including an array's address after array-to-pointer
conversion. See N4659 `[temp.arg.nontype]`.
In C++20, a literal class with public, non-mutable structural members and
public structural bases can be the type of a non-type parameter. A class
template name in the parameter declaration deduces the class type first.
Evaluate the argument with the ordinary constant initialization rules.
Compare bases, array elements and members recursively when identifying
specializations, including the active member of a union. A user-defined
equality operator has no role in template argument equivalence.

A class-valued parameter names a const lvalue. Equivalent values of the
same class type name the same parameter object, including from different
templates. The unparenthesized `decltype` gives the parameter's type.
When the program uses the object's address, emit a linkable definition
using the target's template parameter object ABI. See N4861 `[temp.param]`,
`[temp.arg.nontype]`, `[temp.type]` and
[P1907R1](../doc/cwg/paper-p1907r1.txt).

A C++20 string literal operator template can declare a single class-valued
non-type parameter. Use the string literal, including its terminating code
unit, to initialize that parameter and select the specialization. Use this
form before considering a literal operator that takes a pointer and a length.
Apply class template argument deduction if the parameter names a class template.
See N4861 `[lex.ext]` and `[over.literal]`.

C++20 pointer and reference arguments may designate subobjects of named
objects with static storage duration. Apply the same rule to pointer and
reference members of structural values. Equivalent expressions for an
array element designate the same subobject, including array decay and the
address of element zero. Keep overlapping union members distinct when
they designate different subobjects. The prohibitions on temporary and
string objects, `typeid`, `__func__`, and their subobjects still apply.

Trailing-return function-pointer parameter types
are distinct from a placeholder whose argument type is deduced.
Pack-expanded using declarations import the corresponding names; diagnose a
missing pack. Multiple-base object-model observations remain in PA22.
Preserve C++17 `noexcept` function-type distinctions through substitution.
Instantiate a selected conversion function's exception specification when
overload resolution chooses it, including in a `decltype` operand. See
[CWG 1330](../doc/cwg/cwg-1330.txt).
Permit a non-throwing function pointer as a template argument for the
matching potentially throwing pointer type. See N4659
`[conv.fctptr]` and `[expr.const]`.
When `noexcept` contains a deduced construction such as `View{value}`,
its braced arguments can make the exception specification dependent.
Deduce the class and compute the exception specification after substitution.
Subsumption compares the identities and parameter mappings of atomic
constraints. A conjunction can reuse a concept containing many
disjunctions. Keep that case tractable when determining which overload is
more constrained. See N4861 `[temp.constr.normal]` and
`[temp.constr.order]`.

A concept can constrain the deduced type of a non-type parameter,
as in `template<Small auto N>`. Treat the parameter as a value and
evaluate the concept for the deduced type. Include the type-constraint
when comparing partial specializations. See N4861 `[temp.param]` and
`[temp.constr]`.

An equivalent pair of constraints may contain the same deduced construction
with renamed parameters. Resolve the class template and compare the operands
before substituting a concrete specialization. See N4861 `[temp.over.link]`.
See N4659 `[temp.arg.nontype]`, `[namespace.udecl]` and `[temp.deduct]`.

### Out Of Scope

The following are explicitly out of scope for PA18:

- `std::initializer_list` library semantics and initializer-list overload
  machinery
- member-pointer template behavior that depends on later member-pointer support
- hosted/vendor-only extensions that happen to use templates
- template-language features beyond the required profile
- backend/toolchain ownership that belongs to the later native and toolchain
  milestones

Inputs that rely on those features have undefined behaviour for this milestone.

### Stage Handoff

The intended template follow-up is PA19, which checks that the PA14-PA18
template features compose in realistic programs. The later backend stage
implements native code generation from the LowIR produced by the frontend.

So PA18 should leave behind:

- a complete standard template semantic layer
- instantiated declarations that lower through the ordinary LowIR path without
  template subset special-casing
- a clean handoff to PA19 for multi-feature template integration before
  backend/toolchain work

### Design Notes (Non-Normative)

The useful shape for PA18 is a typed substitution and deduction engine that
works on semantic declarations, types, expressions, and template arguments. A
substitution failure should be represented as candidate state during overload
resolution rather than as a diagnostic unless no viable candidate remains.

Useful intermediate representations include:

- deduction bindings that record which template parameter each typed argument
  constrained
- explicit non-deduced-context markers in the type/expression forms that need
  them
- a substitution result type that can carry success, SFINAE discard, or hard
  error
- deferred instantiation records for dependent calls and bodies that must not be
  forced before their template arguments are known

### C++20 function template signatures

The return type and the template-head are part of a function template's
signature. Two function templates with equal parameter types and different
return types are different templates, and overload resolution or SFINAE
selects between them. A class template may redeclare itself as a friend
inside its own definition. That template-head is one template level deeper,
so compare its constraints with the first declaration's by parameter position,
not by depth.
