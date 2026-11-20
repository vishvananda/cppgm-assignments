# Required source-language profile

Build a C++ compiler with the following C++11/14/17 and selected C++20 profile.
This is a bounded course contract, not complete conformance to these standards. Later hosted
lessons consume these features rather than making them optional.

The driver default remains GNU C++11. `-std=c++11`, `-std=c++14`, `-std=c++17`,
`-std=c++20` and their `gnu++` counterparts select the documented mode. The
C++20 profile is bounded to the features listed here; it does not claim full
conformance to that standard. A required later
feature need only work in its stated mode; earlier-mode negative checks remain
required. The variable-template, relaxed constexpr and visible-body return-deduction
extensions remain course compatibility features in GNU C++11. ISO source
uses the edition specified by each rule. Hosted use of a suppressible
extension follows the source-location rules in [PA30](pa30/README.md).

| Feature | Mode | Owning lessons |
| --- | --- | --- |
| Binary literals, digit separators | C++14+ | PA1–PA4 token/value/macro boundaries |
| Hexadecimal floating literals | C++17 | PA1–PA4; GNU compiler modes also retain existing extensions |
| UTF-8 character literals of type `char` | C++17 | PA1 and PA2 token and value rules, PA4 macro pasting, PA11 literal operators |
| Optional variadic macro replacement with `__VA_OPT__` | C++20 | PA4 replacement, stringization and token pasting, PA30 hosted diagnostics in earlier modes |
| Distinct `char8_t`, UTF-8 code-unit literals, narrow-array initialization from UTF-8 strings | C++20 | PA1–PA4 token/value/macro boundaries; PA6/PA7 types and conversions; PA9 ABI; PA11 initialization and literal operators |
| Three-way comparison, rewritten candidates and defaulted comparisons | C++20 | PA2/PA4 tokens and macros; PA5 syntax; PA9 ABI; PA12 class/subobject comparisons; PA16 constexpr and earlier template instantiation |
| Named concepts, boolean concept-ids, compound return-type requirements | C++20 | PA5 syntax; PA14 lookup and type arguments; PA15 value arguments and packs; PA16 constexpr calls; PA17 variable templates |
| Requires-expressions with simple, type, `noexcept` compound and nested requirements | C++20 | PA5 syntax; PA7 non-template checks; PA14 substitution; PA15 packs; PA16 constant evaluation; PA17 variable templates |
| Associated constraints, trailing requires-clauses, constrained friends | C++20 | PA5 syntax; PA15 template-heads and overloads; PA17 partial specializations, alias and variable templates, friends; PA18 template signatures |
| Implied `typename` in type-only contexts | C++20 | PA14 dependent names; PA15 non-type parameter types |
| Abbreviated function templates, constrained placeholders (`C auto`, `C decltype(auto)`) | C++20 | PA5 syntax; PA20 parameter invention and deduction checks |
| Nested namespaces, attribute using-prefixes | C++17 | PA5 syntax, PA6 lookup; vendor effects PA30 |
| Using-enum declarations and individual scoped-enumerator imports | C++20 | PA4 feature macros, PA5 syntax, PA6 lookup |
| Contextual conversions, aggregate member defaults | C++14+ | PA11/PA12; constexpr PA16 |
| Bit-field default member initializers | C++20 | PA12 bit-field width and initialization; PA11 default member initialization |
| Public aggregate bases, direct prvalue result objects, inline variables, aligned allocation | C++17 | PA11/PA12; constexpr PA16; multi-TU PA25; host ABI PA32 |
| Fold expressions | C++17 | PA15; composed deduction PA18/PA19 |
| Immediate functions (`consteval`), constant-initialization declarations (`constinit`) | C++20 | PA2–PA5 tokens and syntax; PA6 declaration validity; PA16 evaluation; PA20 immediate lambdas |
| Relaxed constexpr bodies | C++14 rules, existing C++11 extension | PA16 |
| Variable templates | C++14, extension in GNU C++11 | PA17 |
| Template-template `typename`, placeholder non-type parameters, class deduction/guides | C++17 | PA17 declarations, PA18 deduction; multiple-base/member-pointer combinations PA22 |
| Class-valued non-type parameters, deduced class parameters and parameter objects | C++20 | PA18 template arguments and deduction; PA16 constant initialization; PA9 Itanium naming |
| Using-declarator lists and pack expansion | C++17 | PA5 syntax, PA6 lookup, PA17 pack expansion |
| Selection initializer statements | C++17 | PA10 |
| `if constexpr` | C++17 | PA19, after substitution and constant evaluation |
| `decltype(auto)`, generic lambdas, initialized captures | C++14+ | PA20; failure cleanup PA21 |
| Explicit lambda template heads, mixed invented parameters, head/trailing constraints, lambdas in unevaluated operands | C++20 | PA5 syntax; PA20 closure/template/constexpr ownership; PA21 failure cleanup |
| `[*this]`, constexpr closures, structured bindings, fixed-enum direct lists | C++17 | PA20; failure cleanup PA21 |
| `noexcept` function-type identity/conversion | C++17 | PA6/PA7; ABI PA9; deduction PA18; host checks PA32 |
| General GNU source assembly and shared LowIR assembly | GNU extension | PA8 transport; PA29 binding, integrated encoding and object behavior |
| Hosted source locations (`<source_location>`) | C++20 | PA30 builtin and PA31 hosted compile tests |
| Hosted coroutines (`co_await`, `co_yield`, `co_return`, `<coroutine>`) | C++20 | PA4 feature macro; PA5 syntax; PA30 handle builtins; PA31 promise and awaiter checking; PA32 frame lifetime and unwinding; PA37 WASI runtime |
| Standard-library consumers (`optional`, `variant`, `string_view`, deduction guides) | Required selected modes | PA31/PA32; use host headers, no STL implementation required |

Read the owning handout for exact supported forms and limits. Syntax appears
in the shared grammar at PA5; its presence does not require all later semantics
at PA5. Tests select modes with `NAME.cxx-standard` or driver `.flags` metadata
and run in ordinary assignment/cumulative suites.

The [offline references](doc/REFERENCES.md) retain edition-specific wording and
adopted-defect provenance. Selected later header extensions, including
conditional `explicit`, alias initializers and `no_unique_address`, remain
separately documented compatibility concessions, not full C++20/23 support.

PA37 adds `wasm32-unknown-unknown` and `wasm32-wasip1` alongside the native
x86-64 targets. The source-language profile stays the same, but target facts
change before preprocessing and semantic analysis: wasm32 has 32-bit pointers
and `long`, and binary128 `long double`. Its single-threaded profile excludes
TLS, atomics and architecture-specific assembly/intrinsics. See
[PA37](pa37/README.md) for the portable runtime, ABI and target requirements,
and the [WebAssembly references](doc/wasm/README.md) for the supplied contracts.
