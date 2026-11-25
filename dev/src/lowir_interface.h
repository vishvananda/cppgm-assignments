#pragma once

#include <stdint.h>
#include "lowir_records.h"
#include "lowir_c_vocabulary.h"

/* Versioned C ABI for foreign LowIR producers. No C++ containers cross this
 * boundary. Symbol strings, parameter arrays, global data descriptors and the
 * other argument records are borrowed for one call. Body buffers and compiled
 * object bytes are module-owned. IDs are dense, zero based (debug type, scope
 * and file IDs are not zero). CPPGM_NO_ID is absent.
 * Functions return 1 on success (IDs use CPPGM_NO_ID on failure). A failure
 * poisons that module; destroy it after reading cppgm_lowir_error(). Separate
 * modules own independent input; calls on one module must be serialized.
 * Compilation calls are serialized internally (shared backend scratch pools);
 * separate modules can construct/validate concurrently.
 *
 * Types: kind in bits 0..7, alignment log2 in 8..15, size in 16..63.
 * Scalars have zero alignment/size; obj carries both. ptr has zero alignment
 * and size 4 for Wasm or size 8 (also spelled 0) for native targets.
 * A record type (since ABI version 4) is the value cppgm_lowir_record
 * returns: kind CPPGM_TYPE_RECORD, the record's ID in 16..63.
 * Value: kind byte, floating TypeKind byte, zero reserved halfword; index is
 * a temporary, slot, symbol, block, or index into this body's literal pool.
 * op/sub/flags/order/immediate have the LowIR vocabulary's meanings. Convert
 * immediate holds the source type. Call immediate holds a signature ID when
 * CPPGM_FLAG_SIGNATURE is set. Asm immediate holds an assembly template ID.
 * extra references the body's operand pool (phi/call/switch/asm).
 * No textual names or number parsing occur on the instruction path.
 *
 * Every number an argument or a record field takes has a name: an enumerator
 * of lowir_c_vocabulary.h (the vocabulary's own numbers) or of this header.
 * Reserved fields are zero.
 */
#if defined(__GNUC__)
#define CPPGM_LOWIR_API __attribute__((visibility("default")))
#else
#define CPPGM_LOWIR_API
#endif

/* Versions 3 through 5 add to the version before and change nothing in it:
 * cppgm_lowir_create accepts CPPGM_LOWIR_ABI_VERSION_MIN to
 * CPPGM_LOWIR_ABI_VERSION. */
#define CPPGM_LOWIR_ABI_VERSION 5u
#define CPPGM_LOWIR_ABI_VERSION_MIN 2u
#define CPPGM_NO_ID UINT32_MAX

#ifdef __cplusplus
extern "C" {
#endif

typedef struct CppgmLowir CppgmLowir;
typedef uint64_t CppgmType;

/* cppgm_lowir_create's target, independent of the host running the library.
 * The AArch64 and Wasm targets require ABI version 5. */
enum CppgmTarget
{
	CPPGM_TARGET_LINUX = 0,
	CPPGM_TARGET_MACOS = 1,
	CPPGM_TARGET_WASM32 = 2,
	CPPGM_TARGET_WASIP1 = 3,
	CPPGM_TARGET_EMSCRIPTEN = 4,
	CPPGM_TARGET_AARCH64_LINUX = 5,
	CPPGM_TARGET_AARCH64_MACOS = 6
};

/* The truth-valued arguments: cppgm_lowir_function's `definition`,
 * cppgm_lowir_global's `declaration` and cppgm_lowir_compile's `pic`.
 * cppgm_lowir_signature's `variadic` is CPPGM_ARITY_FIXED or
 * CPPGM_ARITY_VARIADIC. A `binding` is a CPPGM_BINDING_* value, a `storage`
 * CPPGM_STORAGE_DEFAULT, CPPGM_STORAGE_READONLY or CPPGM_STORAGE_THREAD_LOCAL.
 * Functions get C language linkage (CPPGM_LINKAGE_C) unless
 * cppgm_lowir_symbol_fact states another. */
enum CppgmFunctionForm
{
	CPPGM_FUNCTION_DECLARATION = 0,
	CPPGM_FUNCTION_DEFINITION = 1
};
enum CppgmGlobalForm
{
	CPPGM_GLOBAL_DEFINITION = 0,
	CPPGM_GLOBAL_DECLARATION = 1
};
enum CppgmCodeForm
{
	CPPGM_CODE_FIXED = 0,
	CPPGM_CODE_PIC = 1
};

typedef LowirLiteral CppgmLiteral;
typedef LowirValue CppgmDirectValue;
typedef LowirInstruction CppgmDirectInstruction;
typedef LowirSlot CppgmDirectSlot;
typedef LowirBodyCounts CppgmBodyCounts;
typedef LowirBodyBuffers CppgmBodyBuffers;

typedef struct CppgmDataItem
{
	CppgmType type;
	CppgmLiteral bits;
	int64_t amount; /* address addend or zero byte count */
	uint32_t symbol;
	uint32_t kind; /* CPPGM_DATA_SCALAR, _ADDRESS, _UNALIGNED_ADDRESS or _ZERO */
} CppgmDataItem;

/* The ABI version of this library (its CPPGM_LOWIR_ABI_VERSION) and the
 * cppgm release it belongs to ("0.9.2"). A client that loads the library at
 * run time compares the ABI version with the one it was written for. Both
 * need no module. (Since ABI version 3: a version 2 library has neither.) */
CPPGM_LOWIR_API uint32_t cppgm_lowir_abi_version(void);
CPPGM_LOWIR_API const char* cppgm_lowir_version(void);

/* Writable records come from lowir_records.h; the reserve/commit contract
 * is shared with BodyConstruction below.
 * The C API owns modules and contains exceptions at the foreign boundary. */
CPPGM_LOWIR_API int cppgm_lowir_body_reserve(
	CppgmLowir* module, uint32_t symbol, const CppgmBodyCounts* minimum, CppgmBodyBuffers* buffers);
CPPGM_LOWIR_API int cppgm_lowir_body_commit(
	CppgmLowir* module, uint32_t symbol, const CppgmBodyCounts* counts, uint32_t temp_count);

CPPGM_LOWIR_API CppgmLowir* cppgm_lowir_create(uint32_t abi_version, uint32_t target);
CPPGM_LOWIR_API void cppgm_lowir_destroy(CppgmLowir* module);
CPPGM_LOWIR_API const char* cppgm_lowir_error(const CppgmLowir* module);
CPPGM_LOWIR_API uint32_t cppgm_lowir_symbol(CppgmLowir* module, const char* name, uint32_t length);
CPPGM_LOWIR_API uint32_t cppgm_lowir_signature(
	CppgmLowir* module, CppgmType result, const CppgmType* parameters, uint32_t count, uint32_t variadic);
CPPGM_LOWIR_API int cppgm_lowir_function(
	CppgmLowir* module, uint32_t symbol, uint32_t signature, uint32_t binding, uint32_t definition);
CPPGM_LOWIR_API int cppgm_lowir_global(CppgmLowir* module, uint32_t symbol, CppgmType type, uint32_t binding,
	uint32_t storage, const CppgmDataItem* items, uint32_t count, uint32_t declaration);
/* Validate once after construction, before optimization or serialization. */
CPPGM_LOWIR_API int cppgm_lowir_validate(CppgmLowir* module);
CPPGM_LOWIR_API int cppgm_lowir_write(CppgmLowir* module, const char* path);
/* Optimizes and consumes the module, returning a relocatable object for
 * the selected target in module-owned memory. Valid until destroy; compile
 * at most once. No external toolchain, subprocess or temporary file is
 * involved. level is 0..3. Wasm objects require CPPGM_CODE_FIXED. */
CPPGM_LOWIR_API int cppgm_lowir_compile(CppgmLowir* module, uint32_t level, uint32_t pic);
CPPGM_LOWIR_API const uint8_t* cppgm_lowir_object_data(const CppgmLowir* module);
CPPGM_LOWIR_API uint64_t cppgm_lowir_object_size(const CppgmLowir* module);

/* ---- Boundary, symbol and argument metadata (since ABI version 3) ---- */

/* A parameter of a boundary and its metadata (pa8/lowir.md "Functions" and
 * "Object ABI Conventions"). A record that is zero but for `type` states none. */
typedef struct CppgmParameter
{
	CppgmType type;
	uint64_t object_bytes; /* object_bytes=; 0 is absent */
	uint8_t pass;          /* pass=: CPPGM_PASS_* */
	uint8_t alias;         /* alias=: CPPGM_ALIAS_* */
	uint8_t classes;       /* classes=: 0, or a CPPGM_CLASSES value */
	uint8_t shape_element; /* shape=: CPPGM_ELEMENT_*, with its count */
	uint16_t shape_count;
	uint16_t reserved;
} CppgmParameter;

/* The other facts of a boundary, as bits of CppgmBoundary::facts. */
enum CppgmBoundaryFact
{
	CPPGM_BOUNDARY_REPEATABLE = 1,     /* repeatable=yes */
	CPPGM_BOUNDARY_NOALIAS_RESULT = 2, /* noalias_result=yes */
	CPPGM_BOUNDARY_THIS_RETURN = 4     /* this_return=yes */
};

/* The metadata of a boundary. A zero record is a fixed-arity boundary
 * without metadata. */
typedef struct CppgmBoundary
{
	uint8_t arity;                /* arity=: CPPGM_ARITY_* */
	uint8_t effects;              /* effects=: CPPGM_EFFECTS_* */
	uint8_t unwind;               /* unwind=: CPPGM_UNWIND_* */
	uint8_t returns;              /* return=: CPPGM_RETURN_* */
	uint8_t facts;                /* CPPGM_BOUNDARY_* bits */
	uint8_t result_classes;       /* result_classes=: 0, or a CPPGM_CLASSES value */
	uint8_t result_shape_element; /* result_shape=: CPPGM_ELEMENT_*, with its count */
	uint8_t reserved;
	uint16_t result_shape_count;
	uint16_t reserved2;
} CppgmBoundary;

/* The classes= value of a direct object: the classes of its eightbytes
 * (CPPGM_EIGHTBYTE_*; CPPGM_EIGHTBYTE_NONE for an absent second one), or memory. */
#define CPPGM_CLASSES(first, second) (CPPGM_CLASS_STATED | (first) | ((second) << 2))
#define CPPGM_CLASSES_MEMORY (CPPGM_CLASS_STATED | CPPGM_CLASS_MEMORY)

/* A signature with metadata: the boundary of a function, or of a call that
 * sets CPPGM_FLAG_SIGNATURE. A null `boundary` is a zero record. */
CPPGM_LOWIR_API uint32_t cppgm_lowir_boundary(CppgmLowir* module, CppgmType result, const CppgmParameter* parameters,
	uint32_t count, const CppgmBoundary* boundary);

/* The metadata of a symbol that cppgm_lowir_function or cppgm_lowir_global
 * has declared, by key (pa8/lowir.md "Program Structure").
 * cppgm_lowir_symbol_fact: CPPGM_KEY_ROLE, CPPGM_KEY_LINKAGE,
 * CPPGM_KEY_BINDING and CPPGM_KEY_STORAGE take the enumerator of the value;
 * the yes-valued keys CPPGM_KEY_KEEP_ALIAS to CPPGM_KEY_COLD take 1 or 0;
 * CPPGM_KEY_TLS_FOR takes the symbol ID of a thread-local global.
 * cppgm_lowir_symbol_name: CPPGM_KEY_OBJECT (the linker's name of the symbol)
 * and CPPGM_KEY_SECTION; length 0 removes the name. */
CPPGM_LOWIR_API int cppgm_lowir_symbol_fact(CppgmLowir* module, uint32_t symbol, uint32_t key, uint32_t value);
CPPGM_LOWIR_API int cppgm_lowir_symbol_name(
	CppgmLowir* module, uint32_t symbol, uint32_t key, const char* name, uint32_t length);

/* The metadata of one call argument or of a va_arg result (pa8/lowir.md
 * "Calls", "Variadic Argument Access"): classes=, argument_type= and
 * argument_shape=. */
typedef struct CppgmArgumentFact
{
	uint32_t instruction;  /* the call or va_arg: its position in the instruction buffer */
	uint32_t argument;     /* the argument's position; 0 for va_arg */
	uint8_t classes;       /* 0, or a CPPGM_CLASSES value */
	uint8_t type;          /* argument_type=: a scalar CPPGM_TYPE_*, or CPPGM_TYPE_VOID */
	uint8_t shape_element; /* argument_shape=: CPPGM_ELEMENT_*, with its count */
	uint8_t reserved;
	uint16_t shape_count;
	uint16_t reserved2;
} CppgmArgumentFact;

/* The argument facts of a committed body, in instruction order. A second
 * call replaces the facts of the first. */
CPPGM_LOWIR_API int cppgm_lowir_body_argument_facts(
	CppgmLowir* module, uint32_t symbol, const CppgmArgumentFact* facts, uint32_t count);

/* ---- Record types (since ABI version 4) ---- */

/* The kind of a record type, past the vocabulary's CPPGM_TYPE_* kinds. */
#define CPPGM_TYPE_RECORD 255u

/* A field of a record: `count` consecutive elements (0 is one) of `type`, a
 * scalar type or an earlier record type of the module, from byte `offset`. */
typedef struct CppgmField
{
	uint64_t offset;
	CppgmType type;
	uint64_t count;
} CppgmField;

/* A record type: an object of `bytes` bytes and `alignment` (a power of
 * two) with these fields, which may overlap (a union) and need not be at
 * their types' alignment (a packed record). Returns its type, or 0 on
 * failure. A record type stands for obj of its size and alignment wherever
 * a type is taken: in signatures, boundaries, globals, data items and the
 * instruction and slot records of a body. An object of a record type is
 * passed and returned as C passes and returns an object with the same
 * fields. The library derives x86-64 eightbyte classes or, since version 5,
 * Arm and Wasm aggregate shapes for parameters, results, unnamed variadic
 * arguments and va_arg results. Explicit boundary and argument facts are
 * kept. */
CPPGM_LOWIR_API CppgmType cppgm_lowir_record(
	CppgmLowir* module, uint64_t bytes, uint32_t alignment, const CppgmField* fields, uint32_t count);

/* ---- Source locations (since ABI version 3) ---- */

/* A `!dbg(file, line, column)` location (pa8/lowir.md "Debug Locations").
 * `file` is an ID of cppgm_lowir_debug_file. Lines and columns count from 1.
 * `scope` is a lexical scope of cppgm_lowir_debug_scope; 0 is the function.
 * A zero record is no location. */
typedef struct CppgmDebugLocation
{
	uint32_t file;
	uint32_t line;
	uint32_t column;
	uint32_t scope;
} CppgmDebugLocation;

/* A source file name: one token of the text, so without a space, a comma or
 * a parenthesis. Equal names give equal IDs; no ID is 0. */
CPPGM_LOWIR_API uint32_t cppgm_lowir_debug_file(CppgmLowir* module, const char* name, uint32_t length);

/* ---- Assembly templates (since ABI version 3) ---- */

/* One template (pa29/assembly.md "Assembly templates"): the records of
 * asm_model.h with fixed-width fields. An index is a position in an array of
 * the same CppgmAssembly; CPPGM_NO_ID is absent. An `asm` instruction
 * (CPPGM_OP_ASM, type void) holds the template ID in `immediate` and its
 * arguments in the operand pool. */
typedef struct CppgmAsmRegister
{
	uint8_t bank; /* CPPGM_ASM_BANK_* */
	uint8_t number;
	uint16_t bits; /* 0: the operand's width */
	uint8_t offset;
	uint8_t reserved[3];
} CppgmAsmRegister;

typedef struct CppgmAsmGroup
{
	uint32_t first_register;
	uint16_t register_count;
	uint16_t reserved;
} CppgmAsmGroup;

typedef struct CppgmAsmImmediate
{
	uint8_t kind; /* CPPGM_ASM_IMMEDIATE_* */
	uint8_t is_signed;
	uint8_t reserved[6];
	CppgmLiteral low;
	CppgmLiteral high;
} CppgmAsmImmediate;

typedef struct CppgmAsmAlternative
{
	uint32_t first_group;
	uint32_t first_immediate;
	uint32_t matching; /* the output operand whose location this input shares */
	uint16_t group_count;
	uint16_t immediate_count;
	uint8_t locations; /* CPPGM_ASM_LOCATION_* bits */
	uint8_t early_write;
	uint16_t reserved;
} CppgmAsmAlternative;

typedef struct CppgmAsmOperand
{
	CppgmType type;
	uint32_t input;  /* the invocation argument read */
	uint32_t output; /* the invocation argument that is the output's address */
	uint32_t first_alternative;
	uint16_t alternative_count;
	uint8_t flags; /* CPPGM_ASM_OPERAND_* bits */
	uint8_t input_storage;
	uint8_t condition;
	uint8_t reserved[7];
} CppgmAsmOperand;

typedef struct CppgmAsmPiece
{
	uint8_t kind;   /* CPPGM_ASM_PIECE_* */
	uint8_t format; /* CPPGM_ASM_FORMAT_* */
	uint16_t bits;
	uint8_t offset;
	uint8_t reserved[3];
	uint32_t operand; /* an Operand piece's operand */
	uint32_t first;   /* a Text piece's bytes of `text` */
	uint32_t count;
} CppgmAsmPiece;

/* A zero field states no effect: a producer that knows nothing about the
 * source states CPPGM_ASM_MEMORY_READ_WRITE, the properties SIDE_EFFECT, STACK
 * and RED_ZONE, and the status flags in `state_write`. */
typedef struct CppgmAssembly
{
	uint8_t dialect;     /* CPPGM_ASM_DIALECT_* */
	uint8_t memory;      /* CPPGM_ASM_MEMORY_* */
	uint16_t properties; /* CPPGM_ASM_PROPERTY_* bits */
	uint32_t state_read; /* CPPGM_ASM_STATE_* bits */
	uint32_t state_write;
	uint32_t argument_count;            /* the arguments of an invocation */
	const CppgmDebugLocation* location; /* where the source states it; may be null */
	const char* text;
	const CppgmAsmOperand* operands;
	const CppgmAsmAlternative* alternatives;
	const CppgmAsmGroup* groups;
	const CppgmAsmRegister* registers;
	const CppgmAsmImmediate* immediates;
	const CppgmAsmPiece* pieces;
	const CppgmAsmRegister* clobbers;
	uint32_t text_size;
	uint32_t operand_count;
	uint32_t alternative_count;
	uint32_t group_count;
	uint32_t register_count;
	uint32_t immediate_count;
	uint32_t piece_count;
	uint32_t clobber_count;
} CppgmAssembly;

/* Defines a template and returns its ID. IDs count from 0 in call order. */
CPPGM_LOWIR_API uint32_t cppgm_lowir_assembly(CppgmLowir* module, const CppgmAssembly* assembly);

/* ---- Debug information (since ABI version 3) ---- */

/* The object holds line tables when locations exist, and source types and
 * locals when a debug type, scope or local exists. */

/* The location of a function definition. */
CPPGM_LOWIR_API int cppgm_lowir_function_location(
	CppgmLowir* module, uint32_t symbol, const CppgmDebugLocation* location);
/* The locations of a committed body's instructions. `indices` has one entry
 * for each instruction of the buffer: 0 for none, else 1 + a position in
 * `locations`. */
CPPGM_LOWIR_API int cppgm_lowir_body_locations(
	CppgmLowir* module, uint32_t symbol, const CppgmDebugLocation* locations, uint32_t count, const uint32_t* indices);

/* Source types and locals (pa8/lowir.md "Source type and local metadata in
 * hosted objects"); the numbers are that section's. */
enum CppgmDebugKind
{
	CPPGM_DEBUG_UNSPECIFIED = 0,
	CPPGM_DEBUG_BASE = 1,
	CPPGM_DEBUG_POINTER = 2,
	CPPGM_DEBUG_REFERENCE = 3,
	CPPGM_DEBUG_RVALUE_REFERENCE = 4,
	CPPGM_DEBUG_ARRAY = 5,
	CPPGM_DEBUG_CONST = 6,
	CPPGM_DEBUG_VOLATILE = 7,
	CPPGM_DEBUG_STRUCTURE = 8,
	CPPGM_DEBUG_UNION = 9,
	CPPGM_DEBUG_ENUMERATION = 10,
	CPPGM_DEBUG_ENUMERATOR = 11,
	CPPGM_DEBUG_MEMBER = 12,
	CPPGM_DEBUG_INHERITANCE = 13,
	CPPGM_DEBUG_NAMESPACE = 14,
	CPPGM_DEBUG_ALIAS = 15,
	CPPGM_DEBUG_SUBROUTINE = 16,
	CPPGM_DEBUG_PARAMETER = 17,
	CPPGM_DEBUG_CONSTANT = 18,
	CPPGM_DEBUG_METHOD = 19
};

enum CppgmDebugEncoding
{
	CPPGM_DEBUG_ENCODING_NONE = 0,
	CPPGM_DEBUG_ENCODING_BOOLEAN = 1,
	CPPGM_DEBUG_ENCODING_SIGNED = 2,
	CPPGM_DEBUG_ENCODING_SIGNED_CHAR = 3,
	CPPGM_DEBUG_ENCODING_UNSIGNED = 4,
	CPPGM_DEBUG_ENCODING_UNSIGNED_CHAR = 5,
	CPPGM_DEBUG_ENCODING_FLOATING = 6,
	CPPGM_DEBUG_ENCODING_COMPLEX = 7,
	CPPGM_DEBUG_ENCODING_ADDRESS = 8
};

enum CppgmDebugFlag
{
	CPPGM_DEBUG_FLAG_DECLARATION = 1,
	CPPGM_DEBUG_FLAG_BIT_FIELD = 2,
	CPPGM_DEBUG_FLAG_POLYMORPHIC = 4,
	CPPGM_DEBUG_FLAG_VIRTUAL_BASE = 8,
	CPPGM_DEBUG_FLAG_ARTIFICIAL = 16,
	CPPGM_DEBUG_FLAG_VIRTUAL_METHOD = 32,
	CPPGM_DEBUG_FLAG_SCOPED_ENUM = 64
};

typedef struct CppgmDebugType
{
	uint8_t kind;     /* CPPGM_DEBUG_* */
	uint8_t encoding; /* CPPGM_DEBUG_ENCODING_* */
	uint16_t reserved;
	uint32_t parent; /* a debug type ID; 0 is none */
	uint32_t type;   /* the referenced debug type ID; 0 is none */
	uint32_t flags;  /* CPPGM_DEBUG_FLAG_* bits */
	uint64_t bytes;
	uint64_t bit_offset;
	uint64_t count;
	uint64_t constant;
	const char* name; /* a presentation string; may be null with length 0 */
	uint32_t name_length;
} CppgmDebugType;

/* Adds a source type and returns its ID. IDs count from 1 in call order, so
 * a record can name a type that a later call adds. */
CPPGM_LOWIR_API uint32_t cppgm_lowir_debug_type(CppgmLowir* module, const CppgmDebugType* type);
/* Adds a lexical scope of a defined function inside scope `parent` (0: the
 * function's own scope) and returns its ID. IDs count from 1 in call order. */
CPPGM_LOWIR_API uint32_t cppgm_lowir_debug_scope(CppgmLowir* module, uint32_t function, uint32_t parent);
/* A named local of a defined function: its slot (by position), its debug
 * type and scope (0: none), its name, and where it is declared (may be null). */
CPPGM_LOWIR_API int cppgm_lowir_debug_local(CppgmLowir* module, uint32_t function, uint32_t slot, uint32_t type,
	uint32_t scope, const char* name, uint32_t length, const CppgmDebugLocation* declaration);

#ifdef __cplusplus
}
#endif

#ifdef __cplusplus
namespace lowir_model {

// One function under construction. reserve exposes writable prefixes of
// implementation-owned pools. Pointers expire on another reserve, commit,
// compilation or destruction; IDs survive growth. Parameters are the first
// temporaries. A construction instruction's location is its insertion block;
// next is ignored before commit. layout is a permutation of block IDs; plain
// foreign slots have zero name, kind, reserved and index fields. A second
// commit, or a count outside the reservation, fails. commit binds block links and definitions and clears construction locations.
// No text parsing, allocation per instruction, or per-instruction dispatch is
// part of this interface. Reserve once using existing size facts when possible.
class BodyConstruction
{
public:
	virtual ~BodyConstruction() {}
	virtual bool reserve(const BodyCounts& minimum, BodyBuffers& buffers) = 0;
	virtual bool commit(const BodyCounts& counts, uint32_t temp_count) = 0;
	virtual const char* construction_error() const = 0;
};

} // namespace lowir_model
#endif
