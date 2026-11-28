#pragma once

#include <cstdint>
#include <cstring>

// Target vocabulary. Architecture, execution environment, object format and
// language data layout are distinct facts, selected before source analysis.
// Containers and backend algorithms are supplied by the implementation.
namespace target_model {

enum class Architecture : std::uint8_t
{
	X86_64,
	Wasm32,
	AArch64,
	I386,
	Wasm64
};

enum class Environment : std::uint8_t
{
	Linux,
	Darwin,
	Freestanding,
	WasiPreview1,
	Emscripten
};

enum class ObjectFormat : std::uint8_t
{
	Elf,
	MachO,
	WebAssembly
};

enum class CallingConvention : std::uint8_t
{
	SysVAmd64,
	DarwinAmd64,
	WasmBasicC,
	Aapcs64,
	DarwinAarch64,
	SysVI386
};

enum class MemberFunctionTag : std::uint8_t
{
	Function,
	Adjustment
};

struct CxxAbi
{
	std::uint8_t word_bytes;
	MemberFunctionTag member_function_tag;
	bool indirect_member_function;
	bool structor_returns_this;
	std::uint8_t guard_bytes;
};

enum class ByteOrder : std::uint8_t
{
	Little,
	Big
};

enum class ExtendedFloat : std::uint8_t
{
	X87,
	Binary64,
	Binary128
};

enum class Target : std::uint8_t
{
	Linux,
	MacOS,
	Wasm32,
	Wasi,
	Emscripten,
	AArch64Linux,
	AArch64MacOS,
	I386Linux,
	Wasm64
};

enum class WasmFunctionAttribute : std::uint8_t
{
	None,
	ImportModule,
	ImportName,
	ExportName
};

inline WasmFunctionAttribute wasm_function_attribute(const char* text, std::size_t length)
{
	if (length > 4 && std::memcmp(text, "__", 2) == 0 && std::memcmp(text + length - 2, "__", 2) == 0)
	{
		text += 2;
		length -= 4;
	}
	static const char* const names[] = { "import_module", "import_name", "export_name" };
	for (unsigned i = 0; i < 3; ++i)
		if (std::strlen(names[i]) == length && std::memcmp(names[i], text, length) == 0)
			return static_cast<WasmFunctionAttribute>(i + 1);
	return WasmFunctionAttribute::None;
}

struct DataLayout
{
	std::uint8_t pointer_bytes;
	std::uint8_t long_bytes;
	std::uint8_t long_double_bytes;
	std::uint8_t long_double_alignment;
	ExtendedFloat long_double_format;
	ByteOrder byte_order;
};

struct Description
{
	Architecture architecture;
	Environment environment;
	ObjectFormat object_format;
	CallingConvention calling_convention;
	DataLayout layout;
};

struct OptimizationModel
{
	bool scaled_memory_operands;
	bool locals_survive_calls;
	bool floating_literal_loads;
	bool packed_i32_multiply;
	// The vector registers that hold floating values in a loop (a Wasm
	// engine's are its host's; SSE2's sixteen are the smaller bank).
	std::uint8_t floating_registers;
	// Two adjacent float stores are worth one eight-byte store of a lane pair,
	// so that a later eight-byte copy of the pair forwards from one store
	// (AArch64's stp already writes the pair at once; a Wasm engine's code is
	// counted in instructions).
	bool pairs_float_stores;
};

constexpr bool is_wasm(Target target)
{
	return target == Target::Wasm32 || target == Target::Wasm64 || target == Target::Wasi ||
		target == Target::Emscripten;
}

constexpr bool is_bare_wasm(Target target)
{
	return target == Target::Wasm32 || target == Target::Wasm64;
}

constexpr bool is_aarch64(Target target)
{
	return target == Target::AArch64Linux || target == Target::AArch64MacOS;
}

constexpr bool is_i386(Target target)
{
	return target == Target::I386Linux;
}

// C23 bit-precise integers fit the existing one- and two-word machines.
constexpr unsigned bit_int_max_width = 128;

constexpr unsigned bit_int_bytes(unsigned width)
{
	return width <= 8 ? 1 : width <= 16 ? 2 : width <= 32 ? 4 : width <= 64 ? 8 : 16;
}

constexpr unsigned bit_int_alignment(Target target, unsigned width)
{
	return width > 64 && !is_aarch64(target) ? 8 : bit_int_bytes(width);
}

constexpr bool is_darwin(Target target)
{
	return target == Target::MacOS || target == Target::AArch64MacOS;
}

constexpr unsigned inline_atomic_max_bytes = 8;

constexpr bool is_inline_atomic_size(uint64_t bytes)
{
	return bytes != 0 && bytes <= inline_atomic_max_bytes && (bytes & (bytes - 1)) == 0;
}

constexpr bool pointer_va_list(Target target)
{
	return is_wasm(target) || is_i386(target) || target == Target::AArch64MacOS;
}

constexpr DataLayout data_layout(Target target)
{
	return target == Target::AArch64MacOS ? DataLayout{ 8, 8, 8, 8, ExtendedFloat::Binary64, ByteOrder::Little }
		: is_i386(target)                 ? DataLayout{ 4, 4, 12, 4, ExtendedFloat::X87, ByteOrder::Little }
		: target == Target::Wasm64        ? DataLayout{ 8, 8, 16, 16, ExtendedFloat::Binary128, ByteOrder::Little }
		: is_wasm(target)
		? DataLayout{ 4, 4, 16, target == Target::Emscripten ? std::uint8_t(8) : std::uint8_t(16),
			  ExtendedFloat::Binary128, ByteOrder::Little }
		: DataLayout{ 8, 8, 16, 16, target == Target::AArch64Linux ? ExtendedFloat::Binary128 : ExtendedFloat::X87,
			  ByteOrder::Little };
}

constexpr unsigned default_new_alignment(Target target)
{
	return target == Target::Emscripten ? 8 : 16;
}

constexpr Description describe(Target target)
{
	return Description{ is_aarch64(target) ? Architecture::AArch64
			: target == Target::Wasm64     ? Architecture::Wasm64
			: is_wasm(target)              ? Architecture::Wasm32
			: is_i386(target)              ? Architecture::I386
										   : Architecture::X86_64,
		is_darwin(target)                  ? Environment::Darwin
			: target == Target::Wasi       ? Environment::WasiPreview1
			: target == Target::Emscripten ? Environment::Emscripten
			: is_bare_wasm(target)         ? Environment::Freestanding
										   : Environment::Linux,
		is_darwin(target)     ? ObjectFormat::MachO
			: is_wasm(target) ? ObjectFormat::WebAssembly
							  : ObjectFormat::Elf,
		target == Target::AArch64MacOS       ? CallingConvention::DarwinAarch64
			: target == Target::AArch64Linux ? CallingConvention::Aapcs64
			: target == Target::MacOS        ? CallingConvention::DarwinAmd64
			: is_wasm(target)                ? CallingConvention::WasmBasicC
			: is_i386(target)                ? CallingConvention::SysVI386
											 : CallingConvention::SysVAmd64,
		data_layout(target) };
}

constexpr bool needs_aggregate_shape(Target target)
{
	return is_wasm(target) || is_aarch64(target);
}

constexpr OptimizationModel optimization_model(Target target)
{
	return is_aarch64(target) ? OptimizationModel{ true, false, false, true, 32, false }
		: is_wasm(target)     ? OptimizationModel{ false, true, false, true, 16, false }
							  : OptimizationModel{ true, false, true, false, 16, true };
}

// The course's Linux runtime provides GNU's combined sin/cos call ABI.
constexpr bool has_gnu_sincos(Target target)
{
	return describe(target).environment == Environment::Linux;
}

constexpr CxxAbi cxx_abi(Target target)
{
	return CxxAbi{ data_layout(target).pointer_bytes,
		(is_wasm(target) || is_aarch64(target)) ? MemberFunctionTag::Adjustment : MemberFunctionTag::Function,
		is_wasm(target), is_wasm(target) || target == Target::AArch64MacOS,
		is_wasm(target) ? std::uint8_t(4) : std::uint8_t(8) };
}

// An object-to-integer signature rewrite must retain its public call ABI.
// Register-sized integers carry these aggregate bits on the AMD64 ABIs;
// Wasm's typed function signatures distinguish those representations.
constexpr bool aggregate_integer_carriers(Target target)
{
	return describe(target).calling_convention == CallingConvention::SysVAmd64 ||
		describe(target).calling_convention == CallingConvention::DarwinAmd64;
}

inline const char* spelling(Target target)
{
	switch (target)
	{
	case Target::Linux:
		return "linux";
	case Target::MacOS:
		return "macos";
	case Target::Wasm32:
		return "wasm32-unknown-unknown";
	case Target::Wasm64:
		return "wasm64-unknown-unknown";
	case Target::Wasi:
		return "wasm32-wasip1";
	case Target::Emscripten:
		return "wasm32-unknown-emscripten";
	case Target::AArch64MacOS:
		return "arm64-apple-macos11";
	case Target::AArch64Linux:
		return "aarch64-linux-gnu";
	case Target::I386Linux:
		return "i386-linux-gnu";
	}
	return "";
}

// Version-one LowIR profile names; distinct from command-line aliases.
inline const char* lowir_spelling(Target target)
{
	static const char* const names[] = { "linux", "macos", "wasm32", "wasi", "emscripten", "aarch64", "arm64_macos",
		"i386", "wasm64" };
	return names[static_cast<unsigned>(target)];
}

const unsigned kTargetCount = static_cast<unsigned>(Target::Wasm64) + 1;

} // namespace target_model
