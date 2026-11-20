## CPPGM Programming Assignment 5 (`cppgm --emit-ast`)

### Overview

Write the first `cppgm` source-compiler mode:

```sh
cppgm --emit-ast -o <outfile> <srcfile1> [<srcfile2> ...]
```

The program reads one or more C++ source files, runs translation phases 1
through 7 for each file, parses each translation unit using the PA5 syntax
subset, and writes a deterministic text dump of the parsed syntax tree.

PA5 is a syntax assignment. Build a tree-producing parser whose structured
AST later assignments consume directly. The required name-category information
helps choose syntax; type checking, overload resolution, and template
instantiation come later.

### Prerequisites

Complete the PA4 preprocessor. Reuse the PA1–PA4 token pipeline and source
locations. This is the first C++ parser you build in the course. Its structured
AST and deterministic dump are the deliverable.

Read [parsing.md](parsing.md) for the implementation order, grammar notation,
name-category boundary, and ambiguity examples. Parsing template syntax here
does not require implementing template deduction or instantiation.

### Starter Kit

The PA5 starter kit contains:

- `README.md`, this assignment handout
- `Makefile`, which builds `cppgm` and runs the PA5 tests
- `cppgm.cpp`, a link to the editable `dev/cppgm.cpp` entry point
- the grammar for this assignment called `pa5.gram`
- an HTML grammar explorer of `pa5.gram` in the sub-directory `grammar/`
- `scripts/run_all_tests.pl` and `scripts/compare_results.pl`
- `tests/spec/`, clause-anchored syntax tests
- `tests/general/`, broader parser tests
- checked-in `.ref` and `.ref.exit_status` files used as the oracle

Your main editable file is `dev/cppgm.cpp`. You may add or change other
implementation files under `dev/` as needed. Preserve the supplied test inputs,
harness scripts and grammar. Corrections to reference outputs follow the
[reference policy](../TESTING_AND_REFERENCES.md).

The starter `dev/cppgm.cpp` is a command-line scaffold for the long-lived
`cppgm` binary. It establishes the expected mode flags and help path; the AST
parser, AST data model, and AST output behavior are your assignment work.

The checked-in reference files under `tests/` are the grading oracle. The
`cppgm-ref` wrapper is available for investigation under the root reference
policy; the harness runs your compiler.

### Build And Test Commands

From the `pa5/` directory:

```sh
make
make check TEST='tests/spec/100-*.t'
make check TEST='tests/general/100-*.t'
make check TEST='tests/general/200-*.t'
make check TEST='tests/general/300-*.t'
make test
```

`make` builds `cppgm`. `make test` runs the local PA5 suite.

### Required Driver Surface

PA5 requires:

- `--emit-ast`
- `-o <outfile>`
- one or more source-file operands

The following modes and driver features are not part of PA5:

- `--emit-types`
- `--emit-semantics`
- `--emit-lowir`
- native compile or link driver behavior such as `-c`, `-E`, `-I`, `-L`, or
  `-l`
- hosted-toolchain query flags such as `--version`, `-v`, `-dumpmachine`, or
  `-print-search-dirs`

Behavior is undefined unless the command line has this form:

```sh
cppgm --emit-ast -o <outfile> <srcfile1> [<srcfile2> ...]
```

### Input Contract

The authoritative source syntax is the shared `cppgm` source grammar, exposed
for this assignment as `pa5.gram`. The grammar defines accepted syntax only;
the PA5 AST-output requirements are defined by the Required Features and Out Of
Scope sections below.

The grammar uses the token vocabulary from preprocessing and the extended BNF
notation explained in [parsing.md](parsing.md). That guide defines the small
name-category table and lexical fallback used before full semantic lookup
exists. Preserve names and template arguments in structured syntax nodes.
Known declarations and parameter kinds take precedence over lexical hints.

The shared grammar intentionally includes syntax whose semantic meaning is added
by later assignments. PA5 is responsible for structured syntax preservation,
not for deciding whether a later semantic or lowering stage would accept the
program.

Behavior is undefined for input that:

- does not match `pa5.gram`
- requires semantic disambiguation beyond the PA5 requirements
- depends on ill-formed-program diagnostics that PA5 is not required to issue

If this README and `pa5.gram` disagree about accepted source syntax, use
`pa5.gram`.

### Output Format

On success, `cppgm` writes the AST dump to `<outfile>`.

The first line is:

```text
<n> translation units
```

where `<n>` is the number of source files on the command line.

For each translation unit, in command-line order, the output contains:

```text
start translation unit <k>
...
end translation unit
```

where `<k>` is the 1-based translation-unit index.

Between those wrapper lines, write a deterministic line-oriented tree dump
rooted at:

```text
translation-unit
```

The dump must use explicit syntax nodes for supported constructs. Each line
is one node: two spaces of indentation per level of nesting, the node's
kind, and for some kinds one payload. [Node Vocabulary](#node-vocabulary)
lists every kind the references use and the payload each carries; the
checked-in `.ref` files are the oracle for the order of a node's children.
Only the dump is compared. The tree in memory may take any shape, node set
and ownership that produces it; nothing requires one node class per dump
line, and the kinds are the printer's spellings, not a class list.

PA5 output is a syntax tree, not a semantic dump. For example, base specifiers
and constructor mem-initializers should preserve the unresolved names and
argument syntax, but PA5 does not decide whether a name denotes a base, member,
or delegating constructor target.

Standard output and standard error are ignored by the automated PA5 tests.
They may contain diagnostics or tracing text, but they are not part of the
grading contract.

### Error Handling

If preprocessing, tokenization, or parsing fails, `cppgm` must exit with
`EXIT_FAILURE`.

The contents of `<outfile>` are unspecified on failure. For failing tests, the
harness compares only the named exit status, not diagnostic text and not the
output file.

### Required Features

PA5 must build structured AST nodes for the source subset that later PA6 and
PA7 passes consume, including:

- translation units in command-line order
- namespace definitions and aliases
- using directives and using declarations
- alias declarations and `typedef`
- simple declarations and function definitions
- class, struct, union, enum, and scoped enum declarations
- class members, access labels, bit-fields, base clauses, and constructor
  initializer syntax
- template declarations with type, non-type, and template-template parameters.
  A parameter's kind belongs to that declaration: reusing a name that an
  earlier declaration gave a different kind must not carry the earlier one
  over, or the later parameter stops disambiguating the same way
- dependent template arguments whose qualified operands participate in
  parenthesized logical expressions, even when the prefix could also begin a
  type-id
- common template-id (including operator and literal-operator template ids),
  explicit-instantiation, and explicit-specialization syntax
- `static_assert`
- declarator-derived syntax, including pointers, references, arrays, function
  parameter clauses, exception specifications, cv/ref qualifiers, default
  arguments, and trailing return types. A declarator's pack `...` precedes its
  declarator-id (`T... values`); an ellipsis after the last parameter, with or
  without a comma (`f(int, ...)`, `g(char value...)`), is the parameter
  clause's own and dumps under `parameter-clause`
  An unnamed pointer or reference parameter can name a nested type
  through `decltype(object)::`. Keep the qualified name and the
  abstract declarator in the AST for later type lookup.
- structured `type-id` syntax in casts, `new`, `typeid`, `alignof`,
  `sizeof(type)`, and `noexcept`
- compound statements, selection statements, iteration statements, labels,
  `break`, `continue`, `goto`, `return`, `throw`, and `try` / `catch`
- literals, identifiers, parenthesized expressions, calls, subscripts, member
  access, unary and binary operators, conditional expressions, assignments,
  comma expressions, keyword casts, `new` / `delete`, lambdas, `typeid`,
  `alignof`, `sizeof`, `noexcept`, and braced init lists

Unsupported statement or expression forms inside the PA5 boundary should fail
during parsing rather than being preserved as opaque placeholder nodes.

### Required C++14/17 syntax

The source driver accepts `-std=c++11`, `-std=c++14`, `-std=c++17` and
`-std=c++20`; the default stays C++11. Parse the forms in the
[required language profile](../LANGUAGE_PROFILE.md) into structured nodes.
The C++20 mode recognizes `char8_t` as a simple-type-specifier; its type
identity and conversions are taught in PA6 and PA7.
These include nested namespace definitions and attribute using-prefixes,
placeholder declarations, folds, deduction guides, initializer statements,
`if constexpr`, structured bindings, generic/initialized lambda captures and
pack-expanded using declarations. Syntax acceptance here does not require
later template instantiation or object lowering.

C++17 `namespace a::b { ... }` represents nested namespace definitions.
An attribute using-prefix applies one namespace to its attribute list; do
not combine it with individually scoped attributes in that same list.
Retain language-mode distinctions, including an empty using-prefix list.
GNU attribute effects remain hosted compatibility work. N4659
`[namespace.def]` and `[dcl.attr.grammar]` govern these syntax checks.
Accept a comma-separated list of using-declarators in C++17 and later. Each
entry has its own qualified name and optional pack expansion. See N4659
`[namespace.udecl]`.

In C++20, parse `using enum` with a single qualified or unqualified enum
name or alias template-id. Retain the target as a name and permit the
declaration in the same scopes as a using-declaration. See N4861
`[enum.udecl]` and [CWG 2621](../doc/cwg/cwg-2621.txt). PA6 resolves the target
and declares its enumerators.

### Out Of Scope

PA5 does not require:

- full semantic name lookup beyond the syntactic categories described above
- type checking
- overload resolution
- conversion ranking
- template argument deduction
- semantic validation or constant evaluation of non-type template parameters
  and arguments
- complete parsing of every C++11 corner case
- semantic resolution of `template-id` versus `<`
- semantic resolution of ambiguous template arguments such as `foo<T*p>`

Those topics belong to later semantic and template assignments.

### Testing And Grading Contract

The PA5 harness discovers every `.t` file under the requested test root.
For each test case `x.t`, it runs:

```sh
cppgm --emit-ast -o x.my x.t
```

and records `x.my.exit_status`.

Comparison rules:

- `x.my.exit_status` must match `x.ref.exit_status`.
- If the reference status is `EXIT_FAILURE`, the test passes after the exit
  status comparison.
- If the reference status is `EXIT_SUCCESS`, `x.my` must match `x.ref` exactly.
- Standard output and standard error are not compared.

The local suite is split by role:

- `tests/spec/` contains small tests tied to the cited syntax clauses and selected language modes.
  These files begin with an `N3485 focus` comment.
- `tests/general/` contains broader parser tests, cross-feature syntax
  combinations, and useful intake cases that are not a single-clause oracle.

### Design Notes (Non-Normative)

The simplest successful design keeps these concerns separate:

- preprocessing and token preparation
- recursive-descent or table-driven parsing
- AST node ownership
- deterministic AST printing

Plan for ambiguity. Some C++ syntax cannot be classified fully until later
semantic passes exist. PA5 should still preserve the required structure in the
tree so later assignments can classify it without reparsing source text.

### Handoff (non-normative)

The next assignment builds scopes, bindings, and canonical types on this AST.
Keep declarations, declarators, names, expressions, and source locations
available as structured data. Later semantic information can refine ambiguous
names without replacing the parser or reparsing token spellings from its dump.
Use stable node ownership and keep printing separate from parsing; no particular
arena, class hierarchy, or reference implementation layout is required.

Plan the node shape for what every later stage asks of every node. PA7
attaches a type and a value category to every expression, PA14 instantiates
template bodies, and PA10 lowers every node of every function. Facts that
every node of a kind carries are best reached from the node itself, and node
kinds are best an enumeration rather than a string; a generic tree whose
facts live in hash tables keyed by node, probed on every visit, works for
the fixtures and becomes the front end's dominant cost on the standard
library headers later assignments parse. Nodes hold kinds and identities,
not the dump's spellings: the printer renders `KW_INT:int` or a qualified name
when it writes the dump, and no later stage compares those strings.

### Multi-file test groups

For a root `name.t`, companions such as `name.t2` are additional primary
source files in the same invocation, in lexical order. They remain separate
translation units; the harness counts the group once. Headers and other
support files stay with
the owning case and are not concatenated into one source file.

### Node Vocabulary

The references use the node kinds below and no others. A line is a kind
alone or a kind and one payload:

- `<token>` is a token's kind and spelling joined by a colon, as PA2 names
  them: `KW_STRUCT:struct`, `OP_PLUS:+`, `TT_IDENTIFIER:override`.
- `<name>` is a name as the source spells it; one the source spells with
  several tokens is written with them joined and no spaces: `~C`,
  `operatorint`, `__owns_one_state<C>`, `decltype(n::base())`.
- `<text>` is the construct's own tokens, joined without spaces.

Declarations:

```text
translation-unit
empty-declaration
simple-declaration
init-declarator-list
init-declarator
function-definition
alias-declaration <name>
using-declaration
using-directive
namespace-definition <name>        `<unnamed>` for an unnamed namespace
inline                             first child of an inline namespace-definition
namespace-alias-definition <name>
target <name>                      the namespace a using-directive or alias names
linkage-specification <text>       `C` or `C++`
static-assert-declaration
message <text>                     a static-assert-declaration's string literal
explicit-instantiation-declaration
class-specifier <name>             no payload for an unnamed class
class-key <token>
class-forward-declaration <name>
member-specifiers
specifier <token>                  `explicit` is written as its spelling alone
access-specifier <token>
base-clause
base-specifier
base-name <name>
virtual <token>                    a virtual base specifier
virt-specifier <token>
special-member-declaration <name>  a constructor, destructor (`~C`) or conversion function (`operatorint`)
special-member-definition <name>
ctor-initializer
mem-initializer
mem-initializer-id <name>
bit-field-declaration
bit-field-declarator
enum-specifier <name>              no payload for an unnamed enumeration
enum-key <token>
enumerator <name>
```

Templates:

```text
template-declaration
template-parameter-clause
template-parameter-list
type-parameter
non-type-template-parameter
template-template-parameter
parameter-key <token>
parameter-pack ...
default-template-argument
ellipsis ...
pack-expansion <token>             OP_DOTS:...
pack-expansion-expression
sizeof-pack-expression <name>
deduction-guide                    a `name`, the parameter-clause, then the type-id
name <name>                        the template of a deduction-guide; the concept of a type-constraint
```

Specifiers, declarators and initializers:

```text
decl-specifier-seq
decl-specifier <token>
type-specifier-seq
type-specifier <token>
type-name <name>                   a name the parser knows as a type
identifier <name>                  any other name
cv-qualifier <token>
decltype-specifier <text>
qualified-type-name <name>         the member that a decl-specifier names after `decltype(...)::`
constrained-placeholder-type <name> auto
constrained-placeholder-type <name> decltype(auto)
global-scope
type-id
declarator
abstract-declarator
nested-declarator
ptr-operator <token>
array-suffix
parameter-clause
parameter-declaration
function-qualifier <text>          `noexcept`, `throw()`, `throw(int,Y*)`
ref-qualifier <token>              a function declarator's `&` or `&&`
noexcept-specification
trailing-return-type [<name>]      the payload repeats a return type that is one type-name
initializer
paren-initializer
braced-init-list
special-initializer <text>         a defaulted or deleted definition's `default` or `delete`
default-argument
```

Statements:

```text
compound-statement
expression-statement
return-statement
if-statement
condition
condition-declaration
then                               an if-statement's branches
else
while-statement
do-statement
for-statement
for-init-statement
iteration                          a for-statement's iteration expression
range-for-statement
range-declaration
range-initializer
switch-statement
case-statement
default-statement
break-statement
continue-statement
goto-statement <name>
labeled-statement <name>
try-block
function-try-block
handler
exception-declaration
throw-statement
```

Expressions:

```text
id-expression <name>
literal <text>
keyword-literal <token>            true, false, nullptr, this
parenthesized-expression
unary-expression <token>
postfix-expression <token>
binary-expression <token>
assignment-expression <token>
conditional-expression
call-expression
argument-list
paren-argument-list
subscript-expression
member-expression <token>
cast-expression <token>            a cast keyword; a C-style cast writes `OP_LPAREN:` with no spelling
sizeof-expression
type-trait-expression <token>      alignof, noexcept, typeid
new-expression
placement <text>
delete-expression
array-delete                       a delete-expression's `[]`
lambda-expression
lambda-introducer <text>
lambda-declarator
lambda-specifier <token>
fold-expression                    its operands, in source order
```

C++20 constraints:

```text
concept-definition <name>          the child of its template-declaration; one child, the constraint-expression
requires-clause                    one child, the constraint-expression
type-constraint                    first child of a constrained type-parameter; one child, a `name`
requires-expression                a parameter-clause when the source has one, then the requirements
simple-requirement                 one child, the expression
type-requirement                   one child, the type-id
compound-requirement               the expression, then `noexcept` and `return-constraint` when the source has them
noexcept                           a compound-requirement's `noexcept`
return-constraint <name>           the type-constraint after `->`
nested-requirement                 one child, the constraint-expression
```

A concept's `<name>` has its explicit arguments joined: `Same<int&>`. A
template-declaration's requires-clause follows its template-parameter-clause.
A lambda's head requires-clause follows its template-parameter-clause, and its
trailing requires-clause follows its lambda-declarator.

The mode-tagged [modern syntax example](tests/spec/100-required-modern-syntax.t)
and its [AST reference](tests/spec/100-required-modern-syntax.ref) show the
required later forms together. The dump preserves their syntax before the
owning semantic lessons perform deduction, capture analysis or instantiation.

### C++20 coroutine syntax

Parse `co_await` with a cast-expression operand, `co_yield` with an
assignment-expression or braced list, and the `co_return` statement
with its optional expression or braced list. The AST records the keyword
and operand under `coroutine-operation`. See N4861 `[expr.await]`,
`[expr.yield]` and `[stmt.return.coroutine]`.

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
A requirement that starts with `{` is a compound requirement. PA5 parses and
dumps the requirements; PA7 and later assignments check them.

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

### C++20 associated constraints

Retain a template-head's optional `requires` clause. Its grammar accepts
primary expressions joined by `&&` and `||`; calls and comparisons need
parentheses. A type template parameter may use a named concept in place of
`class` or `typename`, optionally followed by an ellipsis and a parameter name.
Retain the concept name and its explicit arguments for later semantic analysis.
Keep this uncommon syntax separate so ordinary template declarations and
parameters stay compact on both native and wasm32 targets.
### C++20 comparison syntax

Retain `<=>` as a binary operator and in operator-function names. It
associates to the left, between shift and relational precedence. Keep
its source operands for semantic analysis, including defaulted declarations.
### C++20 immediate declarations

In C++20 mode, parse `consteval` among function and constructor specifiers,
`constinit` among declaration specifiers, and `consteval` as an alternative
to `constexpr` in a lambda declarator. Retain these specifiers in the AST.
PA6 checks declaration validity, PA16 checks immediate invocations and
constant initialization, and PA20 supplies immediate lambda semantics.

Retain a type-constraint before `auto` or `decltype(auto)` as one placeholder
specifier, the `constrained-placeholder-type` node. Its payload is the
type-constraint as a `<name>`, one space, then `auto` or `decltype(auto)`.
Keep its concept name and explicit arguments, and distinguish the
two deduction rules. Generic and abbreviated parameters later use these parsed
facts to introduce constrained template parameters without parsing them again.
In `auto...` and `C auto...`, retain the ellipsis on the abstract parameter
declarator. A comma before the ellipsis in `auto, ...` makes it the function's
varargs ellipsis. See N4861 `[dcl.fct]` and `[dcl.spec.auto]`.

### C++20 explicit lambda template heads

Retain the lambda's explicit template parameter list and its head and trailing
requires-clauses separately. A generic lambda's written `auto` parameters
remain source syntax; append their invented template parameters after the
explicit list for semantic analysis. AST dumps show the explicit source head.
An explicit head has at least one template parameter: `[]<>() {}` is a
syntax error.
