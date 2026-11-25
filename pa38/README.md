## CPPGM Programming Assignment 38 (`cppgm --emit-lowir -x c`)

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
cppgm --emit-lowir -O0 -x c -std=c17 -o output.lowir input.t
```

`-std=gnu17` selects the GNU extension dialect. It also accepts discarding
immediate object-pointer qualifiers and conditional character/string escapes
such as `\%` (whose value is `%`), as hosted GNU C libraries require. This does
not make differently qualified types compatible or allow unrelated pointer
conversions, nested qualifier removal, or removal of atomic qualification.
Strict `-std=c17` retains its qualifier and escape diagnostics. The C input
profile also accepts `-std=c99`, `-std=gnu99`, `-std=c11`, and `-std=gnu11`,
with the selected edition's value of `__STDC_VERSION__`. The input language and target
are separate choices. `-x c++` continues to select C++; a language and standard
that disagree must be diagnosed. The existing `.c` handling is unchanged unless
C is selected explicitly.

For C input, `-fshort-wchar` selects `unsigned short` as the type of wide
character constants and the element type of wide string literals. Wide
strings use UTF-16 code units and the `__WCHAR_*` and `__SIZEOF_WCHAR_T__`
predefines describe the selected type. `-fno-short-wchar` restores the target
default. Use the same setting across translation units that share wide types.

GNU C modes recognize `asm` as the spelling of `__asm__`. In ISO C modes,
`asm` remains an ordinary identifier.

Accept GNU C's `case first ... last:` labels. Both bounds are integer
constant expressions converted to the promoted switch type. Ranges are
inclusive and must be ordered, with no overlap with another label in the
same switch. The width of a range must not determine the size of the IR.

GNU C's `__label__ name[, name]...;` declarations at the start of a
compound statement give those labels block scope. Resolve label definitions,
`goto`, label addresses, and `asm goto` operands to the innermost declaration.
Different macro expansions can use the same local label name independently.

Use `-std=c90`, `-std=c89`, or `-std=iso9899:1990` for ISO C90. These
modes leave `__STDC_VERSION__` undefined. The C95 amendment mode,
`-std=iso9899:199409`, defines it as `199409L` and recognizes digraphs in
source and after token pasting. In both ISO modes, `inline` and `restrict`
are ordinary identifiers. Recognize `//` comments in system headers,
including quoted headers they include. In other source, lex the two
slashes as separate tokens.
`-std=gnu89` and `-std=gnu90` select C90 with GNU extensions, including
`inline`, line comments, and digraphs.

The experimental C23 mode uses `-std=c23`. Accept the
aliases `-std=c2x` and `-std=iso9899:2024`, and `-std=gnu23` or
`-std=gnu2x` for the GNU dialect. These modes define
`__STDC_VERSION__` as `202311L`. Leave trigraphs unchanged unless
explicitly enabled. Read `#elifdef` and `#elifndef` as conditional
definedness tests on the written macro name. A reached `#warning`
produces a diagnostic with the unexpanded message and normally allows
translation to continue. In C23, recognize binary numbers and digit
separators in integer and floating constants, preprocessing tokens,
and decimal `#line` operands.
In earlier C modes, accept binary integers as an extension in both
source and preprocessing conditions. Apply the pedantic diagnostic
policy to that extension. Recognize digit separators only in C23 and
later C modes.

In a preprocessing condition, treat `__has_c_attribute` as defined
and expand macros in its operand before reading an attribute name or
a namespace-qualified name. Report `202311L` for the standard
`noreturn` attribute and its alternate spellings. Use the existing
target attribute capabilities for qualified extension names, and return
zero for unsupported names. Provide the query in earlier C modes as
an extension.

In C23, use `#embed "name"` or `#embed <name>` to read a binary
resource as a comma-separated sequence of unsigned byte values.
For a quoted name, search beside the physical source file first,
even after `#line`. Search the `--embed-dir=directory` options
in order for angle names and as a fallback for quoted names. Use
this separate search path for resources.

Apply macro replacement to computed resource names and to embed
parameters. Support `limit`, `prefix`, `suffix`, and `if_empty`
with or without the pair of underscores on each end. `limit`
takes a nonnegative preprocessing integer expression without
`defined`. `prefix` and `suffix` supply their own punctuation.
An empty resource or a zero limit selects `if_empty`, if present.
Diagnose missing resources, unsupported parameters, and invalid
or repeated standard parameters.

In a preprocessing condition, `__has_embed` resolves the same
resource and parameters. Return `__STDC_EMBED_NOT_FOUND__` (0)
for a missing resource or unsupported parameter,
`__STDC_EMBED_FOUND__` (1) for a nonempty result, and
`__STDC_EMBED_EMPTY__` (2) for an empty result. Determine this
from the resource size without reading its contents. Feed a
directive's expansion into the existing token stream as it is
consumed, bounded by the effective limit.

In the legacy editions, where a declaration permits an omitted type, use
`int`. This includes an old-style parameter without a declaration. A direct
call to an undeclared identifier introduces a block-scope `extern int`
function declaration without a prototype. Apply default argument promotions
at that call and check later declarations for compatibility. With
`-pedantic-errors`, reject declarations after statements and declarations
in a `for` initializer in C90 and C95.
A selection or iteration statement in those editions uses its enclosing
block's scope. A compound substatement still has its own scope. Starting
in C99, both the control statement and each substatement have block scope.
Resolve tags and typedef names using those scopes while parsing a statement
and when checking the types it refers to.

For C90 and C95, apply pedantic diagnostics to C99 type specifiers such as
`long long`, `_Bool`, and `_Complex`. Also diagnose compound literals,
variable-length and flexible arrays, array parameter modifiers,
trailing enum commas, and repeated type qualifiers. Check qualifiers
introduced through an array typedef on its element type. A repeated
typedef with the same non-variably-modified type and an anonymous record
member require C11 in pedantic mode. Keep honoring system-header
diagnostic suppression and explicit GNU `__extension__` markers.

In C90 and C95, only an array lvalue converts to a pointer. An array
member of a returned struct retains its array type in a comma expression.
With GNU extensions, allow a subscript of the returned array. Otherwise,
diagnose the subscript in pedantic mode. Beginning in C99, such arrays
take the usual array-to-pointer conversion. The element designated by
subscripting a C array is an lvalue. Keep the temporary's lifetime rules
when using pointers into a returned object.

Use a bitwise signed left shift in C90 and C95. Keep the low bits within
the promoted left operand's width, and reject invalid shift counts in
required constant expressions. In pedantic C90 and C95, diagnose
`__func__` and require constant elements for brace-initialized
automatic aggregates. A legacy constant initializer cannot contain a
call, assignment, increment, decrement, or comma even on a
short-circuited branch. A constant `sizeof` operand remains unevaluated.
Distinguish a null pointer constant from a pointer obtained by casting
a value that only folds to zero. A used static function requires a
definition in the same translation unit, including when its use is in
unreachable code. A reference only under constant `sizeof` does not
require a definition.

`-ffreestanding` and `-fhosted` select the C execution environment. Bare
Wasm defaults to freestanding and requires WASI for hosted C. Native
targets and WASI default to hosted. The last environment flag wins.
Define `__STDC_HOSTED__` as zero in freestanding mode and one in hosted
mode. Keep header search and startup options independent of this choice.
Predefine `__STDC_NO_THREADS__` as one when targeting Darwin, matching
Clang's platform definitions. Omit the compiler predefine on Linux and
Wasm. The selected runtime determines which thread operations work.
Use the target's C system include paths for C input.
For WASI C, define `__wasm_exception_handling__` so the SDK's
`<setjmp.h>` selects the exception-tag implementation of nonlocal jumps.
Supply the target's scalar integer types, widths, limits and constant
spellings to its headers. For example, on 64-bit Darwin `int64_t` is
`long long` and `intmax_t` is `long`. Both have width 64.
Supply the Wasm integer format macros used by `<inttypes.h>`. Choose each
length modifier from the underlying integer type. In wasm32, `intptr_t`
uses `long` and `int32_t` uses `int`, although both are 32 bits wide.
Supply preprocessing constants for `<stdatomic.h>` that describe the
scalar atomic operations supported by the target. In C11 and later modes,
Wasm with `-mno-atomics` defines `__STDC_NO_ATOMICS__`. The lock-free
queries then report no inline atomic support.
When linking with `cppgm`, `-nostartfiles` omits the supplied startup,
`-nodefaultlibs` omits the supplied runtime libraries, and `-nostdlib`
omits both. On Linux, supply `_start` if you omit startup. On bare
Wasm, select the functions the host calls with `--export`.

The hosted entry point is `int main(void)` or `int main(int, char **)`.
Native startup also accepts the third `char **` parameter for the
environment. Reaching the end of hosted `main` returns zero. In
freestanding C, `main` is an ordinary function. Do not infer library
semantics from the names of ordinary freestanding functions. Preserve
the behavior of explicit builtins and generated helpers.

Reaching the final brace of a function that returns a value is valid
when the caller discards the result. Preserve the function's side
effects and return control to the caller. Using the missing value has
undefined behavior.

With `-pedantic`, diagnose C11 syntax such as `_Generic` and `_Atomic` in
C99 modes. With `-pedantic-errors`, reject those uses. System headers and
the tokens supplied by their macro replacement lists suppress these diagnostics
unless `-Wsystem-headers` is set. Keep the diagnostic policy of a token passed
as a macro argument. A message-free
`_Static_assert` is a C23 extension in the C modes above.
`__VA_OPT__` and omission of a variadic macro's argument after its
named arguments receive C23 extension diagnostics in earlier
editions. An explicit empty argument with a trailing comma is
valid in C99 through C17. In C23, expand `__VA_OPT__` only when the
macro-replaced variadic arguments contain tokens. Support stringizing
and pasting its expansion. Treat
`_Alignof(expression)` as a GNU extension. The GNU spelling
`__alignof__` accepts the expression. A standard type-name operand must
be complete. For an expression that names an object or member, report its
declared alignment, including a packed member's reduced alignment. Reject
bit-field designators. Alignment queries leave their operands unevaluated.

Before C23, diagnose universal character names for basic and control
characters when converting a character constant or string literal.
Apply the same rule in `#if` and `#elif` expressions. The permitted
low values are U+0024, U+0040, and U+0060. A token that is skipped,
unused in a macro, or stringized does not require this literal
conversion. Use the pedantic and system-header policy above.

C99 and GNU99 use the C99 Annex D identifier ranges. The digit ranges
may continue an identifier. C11 and C17 use their Annex D ranges for
initial and subsequent characters. An allowed UTF-8 character and its
universal character name spell the same identifier. Apply the selected
edition when lexing the result of `##` as well as in source.

In C source, LF, CRLF, and standalone CR are physical line endings.
Recognize a UTF-8 byte order mark at the start of a file. Replace
trigraphs before splicing a backslash and its following line ending.
Count physical line endings for `__LINE__`, including endings deleted
by splicing. A `#line` directive changes the presumed line number for the
following line. For a quoted C include, start with the directory of
the file as opened, including when `#line` changes `__FILE__`. Then
search the configured include directories. An angle include uses the
configured angle search path. Apply this rule after macro substitution
when the directive uses a macro to provide the name. Keep backslashes
in the written header name, including in a quoted name supplied by a
macro. Check escape sequences when a string token is used as a literal.
For an angle name assembled from macro tokens, collapse each stretch
of separating whitespace to one space. Keep a space after `<` and
drop one before `>`. In `__has_include`, preserve the spelling of a
direct header name, including repeated spaces. Expand macro-produced
operands before forming the computed name. After the name, allow
macros that expand to nothing before the closing parenthesis.
Diagnose an empty header name or unexpected tokens after the name.

The ISO C modes above enable trigraphs. GNU modes leave the three
characters as written unless `-trigraphs` is supplied. A backslash
separated from a line ending by spaces, tabs, vertical tabs, or form
feeds also continues the line as an extension. Report this with a
warning, promoted to an error by `-Werror`. The warning follows the
system-header policy and can be disabled with
`-Wno-backslash-newline-escape`.

A C preprocessing number can include the sign after `e` or `E`. A sign
after `p` or `P` is also part of the number in C99 and later, and in GNU
C modes. Apply that rule in source and when re-lexing a paste. A
number-like spelling may be stringized without converting it to a
constant. Diagnose an invalid spelling when a number is needed in an
expression. In pedantic ISO C90 and C95, diagnose hexadecimal floating
constants.

For a macro redefinition, compare parameter spellings and replacement
token spellings after line splicing. Diagnose a change to a universal
character name's written escape even when it names the same character.
Lookup of the macro and substitution of its parameters use the identifier
itself, including when the source spells it with a different escape.

In ISO C99, lex `u`, `U`, and `u8` before a quote as identifiers.
Use the same edition for macro pasting. C11 and GNU99 accept Unicode
literal prefixes.

In C23 identifiers, use Unicode 15.1's XID_Start and XID_Continue
properties for raw and escaped code points, with underscore allowed
as an initial character. Require the decoded identifier to be in
Normalization Form C. Diagnose non-NFC identifiers without changing
their spelling. Apply both rules to pasted identifiers. Strings
and preprocessing numbers may contain sequences outside NFC.

Accept `#pragma STDC FP_CONTRACT ON`, `OFF`, and `DEFAULT` at file
scope and before a compound block's first declaration or statement.
Accept the same settings through `_Pragma`. Restore the enclosing setting
on exit from the block. OFF requires separate rounding across operations.
ON permits contraction within one expression. This implementation defaults
to separate rounding and can contract a same-type scalar multiply-add on
AArch64. A cast or assignment between the multiply and add keeps separate
roundings. The runtime test allows either permitted outcome under ON.

Apply `#pragma STDC CX_LIMITED_RANGE ON`, `OFF`, and `DEFAULT` with
the same file and block scope as `FP_CONTRACT`. Accept `_Pragma` and
restore the enclosing setting after each compound block. The default is
OFF. Preserve the scaled quotient and infinity recovery in full-range
scopes. ON permits elementary complex multiply and divide when the
programmer knows the intermediate values are in range. The runtime tests
check that both approaches give the required values for safe operands.

Apply `#pragma STDC FENV_ACCESS ON`, `OFF`, and `DEFAULT` at file scope
or before the first declaration or statement in a compound block.
Accept the corresponding `_Pragma` spelling. A block inherits the
enclosing mode and restores it when the block ends. The default is OFF.
With access ON, real floating adds, subtracts, multiplies, and divides
use `fenv_binary` in LowIR. Retain the operation even when its value is
discarded, since it can set an observable floating-point status flag.
Use `fenv_convert` for real floating conversions and `fenv_cmp_signal`
for the relational operators. Equality, inequality, and quiet comparison
builtins use `fenv_cmp`. A quiet NaN raises invalid for the signaling
comparison. Preserve status effects of complex arithmetic as well. A
call to a complex runtime routine can read rounding state and raise
exceptions. Its call boundary must keep those effects observable even
when the result is unused. Hosted math calls also retain the effects of
rounding and status updates. For example, `sqrt` rounds in the current
direction, and a flag clear between calls to `sin` and `cos` remains
observable. Static-storage initializers use translation-time arithmetic.
Real floating division by zero in a static initializer produces a quiet NaN
for a zero numerator or a signed infinity for a nonzero numeric numerator.
This computation leaves the execution-time status flags clear.
For software binary128, implement the classification and quiet comparison
results from the representation or through routines that preserve the
floating-point status flags for quiet NaNs. Compare the two signed zeros as
equal. A relational operator in an enabled scope still signals invalid
for a quiet NaN on native targets, even if its result is discarded.
The selected hosted `<math.h>` must classify `float`, `double`, and
`long double` at their own precision. Each classification or quiet
comparison evaluates its operands once.

The output is ordinary [PA8 LowIR](../pa8/lowir.md). Preserve target sizes,
alignment, function signatures, object names, qualifiers and conversions. C
functions and objects use their C ABI names. A C++ `extern "C"` declaration
continues to have C++ syntax and semantics; language linkage does not select C.

### Initial C profile

The first fixture set covers these parts of the C17 input profile:

- C keywords, preprocessing tokens, feature macros and C++ keywords used as
  ordinary C identifiers; `_Bool`, `_Static_assert`, `_Alignas`, `_Alignof`
  and `_Noreturn` use their C meanings.
- Accept an alignment specifier anywhere in the declaration specifier list.
  Use the strictest nonzero request for the object or member, including an
  anonymous member. Preserve the declared type's own alignment. Diagnose
  alignment specifiers on typedefs, bit-fields, functions, parameters, and
  register objects, and requests weaker than an object's type. A type
  operand uses the type's alignment without evaluating VLA bounds.
  A struct or union declaration can mix ordinary declarators and bit-fields
  in either order, including an unnamed zero-width separator. For a list
  that defines an enum, every declarator uses that same enum type. Apply
  the usual type constraints to each declarator. Member names use a separate
  name space. An unqualified name in a width expression can still refer to
  an enclosing typedef or enumerator with the same spelling. See C99
  through C17 §§6.2.3 and 6.7.2.1.
  GNU `aligned` can accompany a bit-field in its declaration specifiers
  or after its width. A named field's request affects its position and
  record alignment. On an unnamed zero-width field, it can increase the
  alignment of the following field and contributes to the record
  alignment on Linux AArch64.
  For a nonzero-width field whose explicit alignment exceeds
  `#pragma pack`, Linux caps the position alignment at the pack limit.
  Darwin and Wasm use ordinary packed placement for that field.
- Preserve the byte offset of an address initializer in a packed record,
  including an address cast to a pointer-width integer and an address with
  a nonzero addend. Keep the record's layout when its elements form an array.
- With `-fms-anonymous-structs` or `-fms-extensions`, a record member
  declaration without a declarator can use a complete named struct or
  union, including through a typedef. Give each declaration its own
  anonymous subobject of that type. Make its fields visible in the
  enclosing record for member access, designators, and `offsetof`.
  A duplicate visible member name or an incomplete member type is an
  error.
- A GNU `__builtin_offsetof` designator can index array members at
  runtime. Compute the fixed part from layout, then evaluate each runtime
  index once and scale it by the size of the array element. A designator
  with constant indices remains an integer constant expression.
- An external declaration of type `void` can give a name to storage
  supplied by the linker. Allow taking its address and import the symbol
  without an object layout. Reject a definition of an object of type
  `void`.
- In ELF objects, a static C declaration with GNU `alias("target")` can
  name an existing definition in its translation unit. Keep the alias's
  local linkage and give it the target's storage. Reject a separate
  definition with an initializer and resolve chains to their actual object.
- In pedantic modes, check an explicit definition against every declaration
  of the same linked object in the translation unit. If a declaration's
  strongest standard alignment request exceeds the type's alignment, the
  definition must supply the same request. The definition may supply that
  alignment through GNU `aligned` when it has no nonzero standard request.
  Treat zero and the type's natural alignment as neutral requests. Use the
  strongest applicable alignment for storage supplied by a tentative
  definition alone.
- Procedural scalar and pointer expressions, control flow, prototype-based
  function declarations, calls, callbacks and variadic argument promotions;
  declarations without prototypes use default argument promotions and compatible
  later prototypes retain their parameter checks. C17 identifier-list (K&R)
  definitions retain each parameter's declared object type while their public
  signature uses default argument promotions. Match declarations to their
  parameter names. Require a declaration for each name in pedantic C99 and
  later modes that support identifier lists. Check compatibility with earlier
  and later prototypes.
  A tag introduced in a prototype's parameter list has scope through the
  end of the declarator. A tag introduced in a function definition's own
  parameter list remains visible in its body.
- Accept GNU attributes before the contents of a parenthesized declarator,
  including an abstract pointer declarator, and before an individual named
  declarator following a comma. An attribute before a parameter's
  type still belongs to that parameter. Follow GCC's type rules for
  `vector_size` and `mode` in a nested declarator by applying the modifier to
  the base type before forming derived types. A GNU `weak` attribute after
  the pointer's `*` applies to the declared symbol, including a function
  returning a pointer.
- With optimization enabled, discard a private constant object when no live
  code, retained initializer or explicit assembly operand needs it. Preserve
  a definition marked `used` or assigned an explicit section.
- Implicit conversions between object pointers and qualified `void*`, without
  discarding pointee qualifiers; integral initialization of enumeration objects.
- GNU C arithmetic on `void*` and function pointers uses a one-byte stride.
  Apply the GNU extension policy in pedantic mode.
- A GNU C cast to a union initializes the first compatible named member
  from the operand, or copies an operand already of that union type.
- A GNU `transparent_union` typedef with integer or pointer members of the
  same machine width can accept an argument compatible with one of its
  members. Null pointers and compatible conversions through `void*` can
  initialize a pointer member. The first member determines the ABI for both
  direct calls and calls through a function pointer. A function definition
  can access the parameter's members as a union object.
- A GNU `cleanup(function)` attribute on an addressable automatic variable
  calls the named function with the variable's address when leaving its
  scope. Run cleanup functions in reverse declaration order on fallthrough
  and transfers out of the scope. Evaluate a return's value before running
  the cleanups, and discard the cleanup function's own return value.
- For relational comparison, require pointers to qualified or unqualified
  versions of compatible object types. Equality also permits a null pointer
  constant, compatible function pointers, and an object pointer with a void
  pointer. Apply the pedantic and system-header policy to supported GNU
  ordered-pointer comparisons.
- GNU C pointer extensions used by hosted libraries: implicit conversions
  between function pointers and `void*`, and between pointers to corresponding
  signed/unsigned integer types (including the three character types).
  Pointer-sign conversions preserve the address and accept qualification
  differences as LLVM does. They do not make the pointed-to types compatible
  for `_Generic` or `__builtin_types_compatible_p`.
- `_Generic` selections preserve the selected expression's type and value
  category. The control and unselected associations are not evaluated.
  Diagnose compatible types in the same association list and a controlling
  type compatible with more than one association.
- GNU `__builtin_choose_expr` takes an integer constant condition and two
  expressions. Check both expressions for validity. Evaluate only the selected
  expression and preserve its type and value category, including array,
  function, and bit-field properties.
- GNU `__builtin_constant_p` yields an integer without evaluating its
  operand. At `-O2`, include constants proved by propagation through local
  integer variables, casts, and comparisons. A volatile read or an increment
  in the probe supplies no new constant and has no effect. Resolve queries
  used in integer constant expressions during semantic analysis, before
  optimizing the function body.
- In optimized C code, `__builtin_object_size` modes 1 and 3 can determine
  the extent of an interior fixed-size array member through a pointer
  parameter. Give unknown subobject bounds their mode-specific result.
  The static query does not evaluate the pointer expression.
- In C, accept GNU `__builtin_tgmath`. The first function's prototype gives
  the number of trailing call arguments, and at least two candidates are
  required. Validate the signatures as one type-generic family and select
  by the common type of the arguments in the varying positions. Apply the
  type-generic math rules for integer promotion, real and complex domains,
  and fixed floating return types. Evaluate only the selected function
  expression and the call arguments. In an unevaluated context, evaluate
  neither. Give the call the selected function's return type.
- For GNU `__builtin_classify_type` in C, apply default argument promotions
  to the expression form. A boolean or enumeration expression reports the
  integer category. A type-name keeps its own category and does not evaluate
  a variable array bound. A single expression is unevaluated and can report
  its category in an integer constant expression.
- Clang's `__attribute__((overloadable))` lets C function prototypes with
  one name and distinct parameter signatures form an overload set.
  Redeclarations agree on the attribute. At most one signature can omit it
  and keep its ordinary C symbol. Marked functions use the Itanium
  function-name encoding with the same C argument and result conventions.
  Use the typed arguments to select a candidate. In particular, rank
  `float` or `double` to `long double` as a promotion and prefer compatible
  pointer conversions over incompatible ones. Diagnose an unavailable
  function if its overload is selected, including an ellipsis-only fallback
  selected in an unevaluated operand.
  [Clang overloadable declarations](https://clang.llvm.org/docs/AttributeReference.html#overloadable)
- The GNU conditional expression with one void arm has type `void`.
  In `value ?: fallback`, evaluate `value` once and use it as both the
  condition and the value selected when it is nonzero. Apply the same
  result conversions as for a conditional with both operands written.
  Evaluate the selected arm for effects and diagnose the extension under
  the pedantic policy.
- C character and string literal types, including the compatible integer
  types of wide, UTF-16 and UTF-32 literals. An identifier immediately after a
  quoted literal is a separate preprocessing token and can expand as a macro.
- Accept GNU C imaginary suffixes `i`, `I`, `j`, and `J` on integer and
  floating literals. Use the numeric suffixes to determine the component type
  and give the value a positive zero real part. Support the suffix spellings
  used by `<complex.h>` for `I` and `_Complex_I`, including `1.0iF` and `1.0fi`.
  Apply the pedantic policy to these GNU suffixes, honoring `__extension__`
  and system-header macros. `-Wsystem-headers` enables diagnostics for those
  macros. In the typed `-E` stream, `_Complex` precedes the component type
  and the bytes of the real part precede those of the imaginary part.
- Round floating constants in the target format during translation.
  A value that rounds past the largest finite number gives an infinity of
  the selected type. Preserve subnormal values and the sign of a zero
  produced by applying unary minus after rounding.
- An implicit or explicit conversion from complex to real uses the real
  component and converts it to the destination type. Conversion to `_Bool`
  compares both components to zero. Preserve the source's evaluation and
  apply the same value rules to static initializers.
- Comparisons and logical operators produce `int`. Assignment, comma,
  conditional and prefix increment results
  do not become C++ lvalues.
- Check the operand forms of integer constant expressions for assertions,
  case labels, enumeration values, bit-field widths, alignment, and array
  designators. An evaluated comma operator is invalid in these expressions.
  A floating literal may be the immediate operand of a cast to an integer.
  Check operand forms in conditional branches that evaluation skips. A
  foldable array bound can still declare a variable-length array. Use C's
  integer constant expressions of value zero for null pointer conversions.
  A pointer-sized integer with static storage can hold a symbol address
  and a constant byte addend carried by a relocation.
  GNU static initializers can form the byte offset of a member by taking its
  address relative to a null pointer to a record. Reuse the record layout
  facts for this expression.
  An empty GNU compound literal of array type completes an omitted bound
  as zero. Its address still designates its own static storage when used in
  a static initializer through array-to-pointer conversion.
  GNU folding can supply the value of a conditional in a required constant
  context, such as a case label or array designator. It can also fold casts
  from null or integer-derived pointer values back to integers. Diagnose
  these extensions in pedantic mode.
- Give a named `register` object automatic storage duration. Diagnose an
  explicit address of the object or a record member it contains, including
  a register parameter. A register pointer can designate other objects.
  Accept `sizeof` on a register array. Diagnose `register` at file scope,
  on functions, and in incompatible storage-class combinations.
- Under the pedantic policy through C17, a declaration in a `for`
  initializer may introduce identifiers only for automatic or register
  objects. Reuse of a visible tag is allowed. A static assertion also fits
  because it introduces no identifier. The restriction was removed in C23.
- When the two pointer operands of `?:` point to compatible types, form
  the composite pointed-to type and combine their qualifiers. A bound or
  a prototype from either operand can determine the result type. Evaluate
  the selected operand and preserve the existing null-pointer rules.
  Apply the usual arithmetic conversions to two arithmetic operands,
  including equal narrow integer and bit-field types.
- Separate tag and ordinary identifier namespaces, including typedefs that
  reuse a tag spelling for an unrelated type; struct and enum tags, typedefs,
  aggregate initialization, C member and array
  designators, member access,
  function parameters and results, compatible record copy and assignment, C object
  linkage and tentative definitions. Starting in C99, an ISO inline
  definition with external linkage supplies the external symbol if a file-scope
  declaration uses `extern` or leaves out `inline`. In the C90 and C95 modes,
  apply GNU89 linkage to `inline`: an `extern inline` body can serve calls in
  its translation unit and the external symbol is supplied by another unit.
  An inline definition with external linkage and without `extern` supplies
  the symbol itself. Advertise the selected C rules to hosted headers with
  `__GNUC_GNU_INLINE__` or `__GNUC_STDC_INLINE__`.
  GNU `gnu_inline` selects GNU89 rules for that C function in later
  modes. A static definition retains internal linkage and can supply a
  callable body. `gnu_inline` and `always_inline` attributes can also occur
  after the return type's pointer operator.
- An uninitialized native stack-pointer register variable at file scope
  exposes the current stack value and uses no data storage. Support reading it,
  and the implicit read/write dependency used by inline assembly that
  requires a stack frame. Its name is not a writable object in memory.
- For a GNU `packed` enumeration without a fixed base, choose the
  smallest compatible integer type that covers all member values.
- Give C99 through C17 enumeration constants type `int`, including inside
  later enumerator initializers. The enumeration object type is compatible
  with `unsigned int` for nonnegative values in the `int` range and `int`
  when the enumeration has negative values in that range. Diagnose constants
  outside the `int` range in pedantic modes. GNU C allows wider integer
  representations when needed.
- In C23, accept a fixed enumeration base that names an ordinary integer
  type. Ignore its qualifiers, including atomic qualification. Diagnose a
  bit-precise or enumeration base and values that do not fit the fixed
  type. Give each member the enumeration type, including inside its
  definition. Use the base type’s numeric conversions and arithmetic.
  A declaration with a fixed base and no body stands on its own.
- For a C23 enumeration without a fixed base, retain the type of an
  explicitly initialized value outside the `int` range while evaluating
  the remaining members. An implicit increment that needs a wider type
  preserves signedness. On completion, give the members type `int` if all
  values fit. Otherwise give them the enumeration type and choose a
  compatible integer representation that holds every value. Diagnose an
  enumeration with no such representation.
- In C23, a named enumeration can have another definition in the same
  scope when the base agrees and both lists have the same member names
  and values. Member order can change. Keep the original tag and member
  declarations visible while evaluating the second list. Diagnose a
  different value, a missing or repeated member, and a definition nested
  inside the definition of the same tag. Earlier editions allow one
  definition per scope.
- In C23, a tagged struct or union can have another definition in the
  same scope. Keep the first definition complete while checking the
  next one. Match members in order by name, exact type, alignment
  request, and bit-field width. Compare the contents of corresponding
  anonymous struct and union members. A named member declared with an
  untagged struct or union still has its own type. Diagnose nested
  definitions of the same tag and keep the first definition's layout.
- In C23, tags declared in different scopes can name distinct,
  compatible types. Match complete records of the same tag and kind
  by member order, names, compatible types, alignments, and bit-field
  widths. Compare corresponding anonymous members by their contents.
  For enums, match the names and values in any order and compare any
  fixed bases. Recheck a record pair after completion of a tag reached
  through its members. Handle recursive member types.
- Use the composite type where required for compatible records. Keep
  the stronger array bounds and function prototypes within their
  members, including through pointers and recursive fields. Support
  assignment, by-value calls, and conditional expressions with these
  compatible types.
- GNU C supports forward references to an enumeration tag. Keep the type
  incomplete until its definition. A pointer or a non-defining declaration
  can refer to it in the meantime. A storage definition or a function
  definition needs a complete type. A call needs a complete return type.
  Diagnose a forward reference or a
  declarator-less enum redeclaration under the pedantic policy.
- In an inline-only definition with external linkage, diagnose references to
  internal-linkage identifiers and definitions of modifiable static or
  thread-local objects. Use all file-scope declarations of the function to
  settle whether its definition supplies the external symbol.
  Under `-pedantic-errors`, diagnose an external inline declaration that
  still has no definition at the end of its translation unit.
- Access a C thread-local object through the target's C ABI, including an
  object defined by another compiler in a separate translation unit.
- Give a redeclared C object or function the composite of its compatible
  types. Combine bounds and prototypes through pointers, array elements,
  function parameters, and return types. A block declaration can refine
  its local view of an object or function and constrain later declarations
  of the same entity. Keep the refined bound or prototype visible only
  where the declaration applies. A block function declaration inherits the
  linkage of a visible prior declaration with linkage and forms a composite
  type with that declaration. Otherwise it has external linkage and uses
  its written type.
  At the end of a translation unit, complete
  a still-incomplete tentative array with external linkage as a one-element
  array. Use a bound or a record definition supplied later in the file
  when available. Under `-pedantic-errors`, reject an incomplete tentative
  declaration with internal linkage at its declaration.
- A flexible array member is the last member of a struct with at least
  one other named member. A name injected by an anonymous struct or
  union counts. A union may hold a flexible record, including through
  another union. Under the pedantic policy, diagnose a flexible record
  as a struct member or array element and a nonempty initializer of the
  flexible member itself. Reject members of function type. A pointer to
  a flexible record or to a function is a valid member type.
- Under the GNU extension policy, a static record initializer can initialize
  a nested flexible member with a string. This also applies to a file-scope
  compound literal. Use the string's code units and terminator. Keep the
  declared types, member offsets and array strides. Use storage already
  supplied by a containing union where it fits. Extend the end of a static
  object when necessary and diagnose an initializer that would overlap a
  later member. Diagnose nested element lists, element designators into the
  flexible array, and initialization of a flexible tail within an array
  element or an automatic object.
- Resolve each initializer designator from the aggregate of the closest
  brace pair. Continue with the next subobject after the designated one,
  including through nested arrays, records, and a union's selected member.
  A later designator replaces the value of the subobject it names. An
  earlier whole-object initializer still supplies the other subobjects. An
  initializer in braces supplies a new value for the whole subobject,
  including implicit zeros. Check overwritten expressions for valid names,
  types, and the constant-expression requirements for static storage.
  Infer the size of an incomplete array from its highest initialized index
  and keep implicit zero ranges compact. When GNU C extensions are allowed,
  an empty initializer may deduce a complete array of length zero.
- Under the GNU extension policy, allow `[first ... last]` to initialize
  whole array elements, including elements of record or array type.
  A member or subscript after a range selects a subobject of each element.
  A second range can select multiple subobjects within each element.
  Both endpoints are in-bounds integer constant expressions and the range
  includes both endpoints. A later write to the same subobject replaces
  its previous value at the indices they share. A write to one struct
  member preserves values supplied for other members. Switching the
  selected union member discards earlier initializers through the
  previous member at the affected indices. Further writes through the
  same member preserve its already initialized subobjects. A replacement
  for a whole aggregate supplies values for all its initialized subobjects,
  including implicit zeros.
  Evaluate a surviving range's value once and use it for every element it
  still initializes. Braces can supply the entire aggregate value,
  including its implied zeros. Each nested brace pair has its own current
  object. A positional initializer resumes after the designated subobject
  of the final range element. Brace elision uses the first subobject as
  usual when the expression initializes a member of each ranged element.
  The aggregate cases cover ordinary records and rows, including
  volatile-qualified record destinations with ordinary members.
  Diagnose a range under the pedantic policy.
- GNU C records with empty bodies have size zero. A member of empty record
  type consumes no bytes in its enclosing record. Diagnose empty record
  declarations under the pedantic policy.
- Resolve the address of a local static object in its own initializer.
  For GNU C static data, order pointers converted from integer constants
  by their unsigned widths on the selected target.
- Check the initializer of an object with static or thread storage duration
  during analysis. Apply the same rules to scalar values, braced leaves,
  and file-scope compound literals. An address constant may name a static
  object or a function. An offset from that address uses an integer constant
  expression and the element size. Diagnose an evaluated call or comma
  operator, a read of an ordinary variable, and an address of an automatic
  object. Emit the checked initializer as data.
- A read or write of a volatile-qualified structure or union remains
  observable, including a discarded value, a return, an argument, or a copy.
  Use scalar volatile accesses for the qualified storage and ordinary accesses
  for any unqualified temporary. Keep the accesses through optimization.
- Bit-field widths fit the C declared type. A `_Bool` member has at most one
  value bit. Diagnose a wider declaration.
- C compound literals of scalar, pointer, record and array types, including
  array-bound deduction and designators. Each occurrence denotes an lvalue;
  block-scope objects survive the full expression and file-scope objects have
  static storage with constant initialization.
  GNU C permits a record compound literal to initialize static storage inside
  a block. Check each written initializer for a constant value and use the
  initializer directly for the destination's storage. The literal itself
  retains its usual lifetime.
- Block-scope variable-length arrays with automatic or register storage can
  mix fixed and runtime dimensions. Evaluate each written runtime bound once
  at its declaration. A typedef captures its extent when execution reaches
  the typedef, and later declarations using that typedef reuse it. Use the
  captured sizes for `sizeof`, subscripting and pointer arithmetic. Release
  the storage on every scope exit and preserve alignment requests. Diagnose
  jumps and switch labels that enter the scope of a variably modified
  identifier past its declaration.
  Leave `__STDC_NO_VLA__` undefined on the supported targets. In C23,
  variably modified types are required even when an implementation omits
  automatic VLA objects.
- In C23, accept `= {}` on a variable-length array with automatic
  storage. Default-initialize each element and clear aggregate padding
  using the complete captured extent. An empty initializer supplies no
  size for an array of unknown bound. Diagnose a nonempty VLA
  initializer and a compound literal of VLA type.
- Require a complete element type when forming an array type. Parse an array
  bound as an assignment expression. A comma expression can appear in
  parentheses within the bound.
- An array parameter adjusts to a pointer. Qualifiers in the outer brackets
  apply to the adjusted pointer object, including `restrict` and C11 `_Atomic`.
  Apply the same adjustment to identifier-list parameters. In a prototype,
  runtime bounds and `[*]` describe unspecified variable lengths. Allow
  `[*]` in type names in that scope, including a nested callback prototype.
  Diagnose it in type names at file scope, in a definition's own parameter
  list, or in its body. Evaluate a definition's written runtime bounds on
  entry, including any bound in the adjusted outer bracket. Retain the
  inner strides. Require a bound with `static`.
- When `_Atomic(type-name)` forms an atomic pointer to a VLA, retain the
  type name's bounds. Evaluate a shared specifier's written bounds once per
  declaration and reuse an extent already captured by a typedef. A function
  type derived from a pointer-to-VLA return type is variably modified.
  A function with linkage cannot have that type. A local pointer to such a
  function can use the runtime bounds of its own declaration.
- Read and assign atomic records with the same sequentially consistent
  ordering as atomic scalars. Load the entire atomic representation in
  one operation when passing, returning, or copying its value. Pass
  ordinary values using their unqualified type's size and alignment.
  Initialize any added atomic padding before the object is shared.
  The value of an assignment is the value it stored. Use the runtime
  operations from PA30 for records wider than the inline widths.
- Use one sequentially consistent read-modify-write for an atomic
  compound assignment, increment, or decrement. When the width needs
  the generic runtime, load the expected representation and retry
  compare-exchange with the snapshot returned on failure. Evaluate the
  object address and any right operand once. A postfix expression yields
  the value replaced by the successful operation.
- Apply `restrict` to pointers to object types, including `void` and
  incomplete record types. The GNU spellings `__restrict` and `__restrict__`
  use the same qualifier in C. Apply lvalue conversion and function signature
  adjustment to the top-level qualifier as for `const`. Preserve qualifiers
  on pointed-to types and diagnose an implicit conversion that discards them
  in pedantic mode. Treat a `restrict` qualifier on an array typedef of
  pointers as a C23 extension in earlier editions.
- Starting in C23, an array and its element type share ordinary qualifiers.
  Apply this rule to conversions to and from void pointers and to operators
  on pointers to arrays. Combine qualifiers on compatible array types,
  including when one bound is fixed and the other is evaluated at runtime.
  Preserve atomic element types and qualification behind another pointer
  level. Through C17, an array itself is unqualified, so a pointer to an
  array of const elements can convert to plain `void *`. Apply the
  pedantic policy when an earlier mode uses the C23 qualification conversion.
- Evaluate the runtime bounds needed by a `sizeof` type name. A bound in a
  pointer type whose value cannot change the result may be elided.
  `_Alignof` and a type-name `_Alignas` use the element alignment of a
  variable-length array without evaluating its bounds.
  `__builtin_types_compatible_p` accepts variably modified type names.
  Check the bounds' types without evaluating them. Compare array bounds
  when both are fixed, and preserve qualification inside pointers.
  The scope restriction for identifiers declared with variably modified
  types does not apply to an anonymous type name.
- Evaluate a `sizeof` expression operand when it has variable-length array
  type. Preserve the effects of evaluated bounds in casts and compound
  literals even if the pointer result is discarded. A compound literal may
  have pointer-to-VLA type. Diagnose a compound literal of VLA type.
- Accept `typeof` in GNU C and the alternate spellings `__typeof` and
  `__typeof__` in all the C modes above. C23 makes `typeof` and
  `typeof_unqual` keywords. Accept `__typeof_unqual` and
  `__typeof_unqual__` as extensions in earlier editions. Each takes a
  parenthesized type name or expression. Diagnose a bit-field operand.
  `typeof` preserves qualifiers. `typeof_unqual` removes the top-level
  qualifiers, including `_Atomic` on non-array types. For an array,
  preserve its bounds and the atomic qualification of its elements.
  Keep pointee qualifiers when removing qualifiers from a pointer.
  Evaluate the operand only when its type is variably modified. An indirection of
  GNU C arithmetic on `void *` advances and subtracts in byte units.
  GNU `sizeof` gives `void` and function types size one, with an
  unevaluated expression operand. Apply the ordinary extension diagnostic
  rules.
  `void *` has type `void`. Applying `&*` preserves the pointer, including a
  null pointer. A discarded void indirection evaluates the pointer's
  effects without a data access. Require an object type for a store or
  standard `sizeof`. For declarators
  sharing a specifier, repeat the evaluated expression operand for each
  declarator and capture written type-name bounds during the first
  declarator's evaluation.
- Recognize `bool`, `true`, `false`, and `static_assert` in C23. Give
  `true` and `false` type `bool` and allow them in integer constant
  expressions. In C23 preprocessing conditions, their values are 1 and
  0. In earlier C modes the spellings are ordinary identifiers and can
  be defined as macros by headers or by source.
- Define `__CHAR8_TYPE__` as `unsigned char` in C23 so compiler
  headers can declare the UTF-8 character and atomic types. Earlier C
  modes leave this macro undefined.
- In C23, recognize `nullptr`, `alignas`, and `alignof`. Give `nullptr`
  its own scalar type with the size, alignment, and null representation
  of a character pointer. `<stddef.h>` supplies the typedef `nullptr_t`.
  Accept null pointer constants and values of that type when initializing
  or assigning it. Convert a `nullptr_t` value to a pointer, `bool`, or
  `void` while preserving operand effects. Support equality with a null
  pointer constant or a pointer. A conditional with a `nullptr_t` arm
  pairs it with a pointer or another `nullptr_t` value. Keep the pointer
  type in the mixed case. Diagnose ordered comparisons with `nullptr_t`.
- In C23, accept a parameter list consisting solely of `...`. Support the
  `<stdarg.h>` `va_start(ap)` form in variadic functions. The optional
  compatibility arguments have no execution effects. Use the existing
  target variadic call convention. A variadic `nullptr_t` argument can be
  read through `va_arg` as `void *` or a character pointer.
- Form signed `_BitInt(N)` types for widths 2 through 128 and unsigned
  types for widths 1 through 128. Evaluate the width as an integer constant
  expression and check its range. Intern types by width and signedness. Use
  the declared width for promotions, conversions, bit-fields, operations,
  and atomic updates. A bit-precise value keeps its type through integer
  promotion. Apply the usual arithmetic conversions when operands differ.
- Choose the smallest bit-precise type that represents a `wb` or `WB`
  literal. An optional `u` or `U` before or after the suffix makes the
  type unsigned. Use `intmax_t` or `uintmax_t` arithmetic in preprocessing
  conditions. In earlier C modes, the type specifier and suffixes follow
  the C23 extension diagnostic policy.
- Store bit-precise values in one, two, four, eight or sixteen bytes.
  Values wider than 64 bits have sixteen-byte alignment on Arm and
  eight-byte alignment on x86-64 and Wasm. Preserve the declared value
  bits across storage and call boundaries. A switch can compare both
  words of a wide case value, including during duplicate-label checks.
  The compiler supplies the width limit through `__BITINT_MAXWIDTH__`.
- Support the GNU `__builtin_stdc_*` bit utilities that C library headers
  select with `__has_builtin`. Count across the operand's precision before
  any promotions, and evaluate the argument once. Counts and positions have
  type `unsigned int`, the single-bit predicate has type `bool`, and floor
  and ceiling have a result in the operand's type. Use the bit-field width
  for field operands. A missing first bit gives zero. A count across an
  all-matching operand gives its width. The C++ input mode does not expose
  these C-only names. Generic `__builtin_clzg`, `__builtin_ctzg`, and
  `__builtin_popcountg` also accept bit-precise unsigned integers in C.
- Preserve signaling NaNs in static initializers for `float`, `double`,
  and `long double`. The C23 `<float.h>` macros may call compiler builtins
  to construct these constants. Unary plus preserves their representation,
  and unary minus flips the sign bit while preserving the signaling bit
  and payload.
- In C23, accept `constexpr` object definitions with initializers and add
  `const` to their declared type. Give file-scope definitions internal
  linkage. Preserve automatic storage and distinct addresses for
  block-scope definitions without `static`. Treat `constexpr` as an
  identifier in earlier C modes.
- In ordinary object builds, emit file-scope named constants when code
  or static data needs their addresses. Keep explicitly retained objects
  and assembler names, and preserve distinct addresses for distinct
  objects.
- Use a C23 named constant or a member reached through `.` as an operand
  of the matching kind of constant expression. Check the active member
  of a constant union. An array element read does not supply a named
  constant. Diagnose atomic, volatile, restrict-qualified, and variably
  modified object or subobject types.
- Check the written initializer values of a C23 `constexpr` object against
  their destination types and bit-field widths before conversion. Require
  integer and arithmetic constant expressions for the matching
  destinations, and require null for pointers. Require a real floating
  or integer expression for a real floating destination. Keep a signaling
  NaN in its compatible real format. Check earlier writes even
  when a later designator overrides them. C23 UTF-8 character and string
  literals use `unsigned char` for their code units.
- In GNU C23 mode, apply range designators to `constexpr` aggregates.
  An overlapping write replaces the designated subobject. Untouched
  subobjects retain their value from earlier initializers, including from a
  copied aggregate. A point update can replace a member within a repeated
  cell. Keep large ranges and intervening point updates sparse during
  constant evaluation. When a range update preserves an inherited union
  member, require that member to be active throughout the range.
- In C23, infer the type in `auto name = expression` when the declaration
  has no written type. Accept one object declarator consisting of an
  identifier with optional attributes and enclosing parentheses.
  Apply lvalue, array-to-pointer, and function-to-pointer conversions to
  the initializer, then apply the written qualifiers. Preserve the type
  of a bit-field as it would be used in a generic controlling expression.
  Evaluate the initializer once, including any variably modified bounds.
- Diagnose a reference to the pending C23 inferred name in its own
  initializer, even when an outer declaration uses the same name.
  Diagnose inference after an earlier declaration in the same scope.
  With a written type, `auto` is permitted on a block-scope object
  without another storage class. Recognize C23 `thread_local` alongside
  `_Thread_local` and apply the ordinary thread storage rules.
- In C23, allow identifier, `case`, and `default` labels before a
  declaration or the closing brace of a compound statement. Treat the
  free label as if followed by a null statement. A following declaration
  remains in the enclosing scope. A label on an unbraced substatement
  still requires a statement. Apply the C23 extension diagnostic policy
  to free labels in earlier C modes, and continue to reject jumps that
  enter the scope of a variably modified identifier.
- In C23, accept `static`, `thread_local`, `register`, and `constexpr`
  before the type of a compound literal. Give its lvalue the storage
  duration and qualifiers of an object definition in the same scope.
  At block scope, require `static` with `thread_local`. Diagnose
  duplicate or incompatible specifiers and address-of a register
  literal or its subobjects.
- Apply the existing rules for exact initialization to `constexpr`
  compound literals. Use their values and member selections in constant
  expressions. A static literal has the same address across evaluations
  of its occurrence. An automatic literal has the lifetime of the current
  block. A thread-local literal has one instance per thread.
- When `sizeof` is followed by a compound literal, apply the expression
  form to the whole operand, including postfix operations. An operand
  of fixed-size type is unevaluated.
- Hosted C header declarations and their builtin operations through the
  existing hosted environment, including PA30's GNU startup and shutdown
  function attributes. Apply them to C function declarations and retain
  them on a later definition.
- Support the reserved GNU spelling `__auto_type` in the C modes above.
  It declares one object with a plain identifier and an expression
  initializer. Bind the identifier after the initializer. Apply array and
  function decay to infer the object type, then apply qualifiers written on
  the declaration. Reject a bit-field or void initializer and preserve any
  dynamic bounds captured by the initializer. Evaluate the initializer once.

This is an initial profile, not a claim of complete C17 conformance. Use
`(void)` for a prototype with no parameters; an empty `()` declares a function
without a prototype. Extend the profile and its tests together.
Do not silently apply a C++ rule where a supported C construct has a
different meaning.

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
reference outputs. A `.c-standard` sidecar selects the C edition and dialect
for an individual fixture, such as `c99`, `gnu17`, or `c23`. Controls use the same
convention. Rejected inputs have the usual failure-status reference.
An adjacent `.t.1` adds another translation unit, as in the earlier source
assignments. `tests/controls/*.t` state an expected program result and run the
generated LowIR through the supplied native backend.

`make test-wasm` runs the same source inputs through PA37's Wasm checker and
their `.wasm-expect` result sidecars. It requires the pinned Wasm tools and SDK.
`make test-native-driver` runs selected variable-length array programs
at `-O0` and `-O2` using the executable, object and LowIR paths on the host.
`make test-native-abi` runs `tests/abi/` using the mixed-object runner from
PA27. Use GCC as `CPPGM_HOST_CC` on x86-64 Linux and Clang on Darwin.
Pass and return a flexible array record's fixed part by the target ABI,
including when a union contains the record. Intel Darwin follows Clang's
memory convention for these records. Linux x86-64 follows GCC's
classification of the fixed members.
Use the target's bit-field alignment and calling convention for both
named and unnamed fields. The mixed-object test compares record size
and alignment with the host compiler and passes and returns aggregates
with zero-width and nonzero unnamed fields.
From the repository root, `make test-pa38` selects this assignment explicitly;
`make test-c` and `make test-c-wasm` are convenience aliases.
