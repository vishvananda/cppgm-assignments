#!/usr/bin/env python3
"""Project the authoritative scaffold enums into the foreign C vocabulary."""
import argparse
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
# (scaffold header, its enum, the C enum, the group word of the C enumerators, the prefix of the header's
# enumerators). An enum class has no prefix: its CamelCase enumerators become words.
ENUMS = [
    ("lowir_model.h", "TypeKind", "CppgmTypeKind", "TYPE", None),
    ("lowir_model.h", "Opcode", "CppgmOpcode", "OP", None),
    ("lowir_model.h", "UnaryOp", "CppgmUnaryOp", "UNARY", None),
    ("lowir_model.h", "BinaryOp", "CppgmBinaryOp", "BINARY", None),
    ("lowir_model.h", "ComparePredicate", "CppgmComparePredicate", "CMP", None),
    ("lowir_model.h", "ConvertOp", "CppgmConvertOp", "CONVERT", None),
    ("lowir_model.h", "ValueKind", "CppgmValueKind", "VALUE", None),
    ("lowir_model.h", "MemoryOrder", "CppgmMemoryOrder", "ORDER", None),
    ("lowir_model.h", "IndexBounds", "CppgmIndexBounds", "BOUNDS", None),
    ("lowir_model.h", "VectorShape", "CppgmVectorShape", "SHAPE", None),
    ("lowir_model.h", "VectorOp", "CppgmVectorOp", "VECTOR", None),
    ("lowir_model.h", "InstructionFlag", "CppgmInstructionFlag", "FLAG", "IF_"),
    ("lowir_model.h", "DataItemKind", "CppgmDataItemKind", "DATA", None),
    ("ir_symbol_model.h", "SymbolRole", "CppgmSymbolRole", "ROLE", "SR_"),
    ("ir_symbol_model.h", "LanguageLinkageMode", "CppgmLanguageLinkageMode", "LINKAGE", "LLM_"),
    ("ir_symbol_model.h", "SymbolBindingMode", "CppgmSymbolBindingMode", "BINDING", "SBM_"),
    ("ir_symbol_model.h", "SymbolVisibility", "CppgmSymbolVisibility", "VISIBILITY", "SV_"),
    ("ir_symbol_model.h", "GlobalStorageMode", "CppgmGlobalStorageMode", "STORAGE", "GSM_"),
    ("ir_symbol_model.h", "SymbolFlag", "CppgmSymbolFlag", "SYMBOL", "SF_"),
    ("ir_symbol_model.h", "CallArityMode", "CppgmCallArityMode", "ARITY", "CAM_"),
    ("ir_symbol_model.h", "CallEffectsMode", "CppgmCallEffectsMode", "EFFECTS", "CFXM_"),
    ("ir_symbol_model.h", "CallUnwindMode", "CppgmCallUnwindMode", "UNWIND", "CUM_"),
    ("ir_symbol_model.h", "CallReturnMode", "CppgmCallReturnMode", "RETURN", "CRM_"),
    ("ir_symbol_model.h", "ParamPassingMode", "CppgmParamPassingMode", "PASS", "PPM_"),
    ("ir_symbol_model.h", "ParamAliasMode", "CppgmParamAliasMode", "ALIAS", "PALM_"),
    ("ir_symbol_model.h", "AggregateElement", "CppgmAggregateElement", "ELEMENT", None),
    ("ir_symbol_model.h", "EightbyteClass", "CppgmEightbyteClass", "EIGHTBYTE", "EB_"),
    ("ir_symbol_model.h", "ObjectClassBits", "CppgmObjectClassBits", "CLASS", "OC_"),
    ("ir_symbol_model.h", "MetadataKey", "CppgmMetadataKey", "KEY", None),
    ("asm_model.h", "Dialect", "CppgmAsmDialect", "ASM_DIALECT", None),
    ("asm_model.h", "RegisterBank", "CppgmAsmRegisterBank", "ASM_BANK", None),
    ("asm_model.h", "Memory", "CppgmAsmMemory", "ASM_MEMORY", None),
    ("asm_model.h", "Format", "CppgmAsmFormat", "ASM_FORMAT", None),
    ("asm_model.h", "PieceKind", "CppgmAsmPieceKind", "ASM_PIECE", None),
    ("asm_model.h", "ImmediateKind", "CppgmAsmImmediateKind", "ASM_IMMEDIATE", None),
    ("asm_model.h", "Location", "CppgmAsmLocation", "ASM_LOCATION", "AL_"),
    ("asm_model.h", "OperandFlag", "CppgmAsmOperandFlag", "ASM_OPERAND", "AO_"),
    ("asm_model.h", "Property", "CppgmAsmProperty", "ASM_PROPERTY", "AP_"),
    ("asm_model.h", "State", "CppgmAsmState", "ASM_STATE", "AS_"),
]


def enumerators(source, name, prefix):
    """The (word, number) pairs of one enum: a stated value, or one more than the enumerator before."""
    keyword = r"enum " if prefix else r"enum class "
    body = re.search(keyword + name + r" : (?:std::)?uint(?:8|16|32)_t\s*\{(.*?)\};", source, re.S).group(1)
    body = re.sub(r"//[^\n]*", "", body)
    number = -1
    for entry in body.split(","):
        entry = entry.strip()
        if not entry:
            continue
        match = re.fullmatch(r"([A-Za-z][A-Za-z0-9_]*)(?:\s*=\s*(0x[0-9a-fA-F]+|[0-9]+))?", entry)
        if not match:
            raise ValueError("unsupported enum entry: " + entry)
        number = int(match.group(2), 0) if match.group(2) else number + 1
        word = match.group(1)
        if prefix:
            if not word.startswith(prefix):
                raise ValueError("enumerator without the prefix %s: %s" % (prefix, word))
            word = word[len(prefix):]
        else:
            word = re.sub(r"([A-Z]+)([A-Z][a-z])", r"\1_\2", word)
            word = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", word).upper()
        yield word, number


def generated():
    lines = ["#pragma once", "",
             "// Generated from lowir_model.h, ir_symbol_model.h and asm_model.h;",
             "// run scripts/generate_lowir_c_vocabulary.py."]
    sources = {}
    for header, name, c_name, group, prefix in ENUMS:
        if header not in sources:
            sources[header] = (ROOT / "dev/src" / header).read_text()
        lines += ["", "enum " + c_name, "{"]
        for word, number in enumerators(sources[header], name, prefix):
            lines.append(f"\tCPPGM_{group}_{word} = {number},")
        lines[-1] = lines[-1].rstrip(",")
        lines.append("};")
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    destination = ROOT / "dev/src/lowir_c_vocabulary.h"
    content = generated()
    if args.check:
        if destination.read_text() != content:
            raise SystemExit("stale C vocabulary; run scripts/generate_lowir_c_vocabulary.py")
    else:
        destination.write_text(content)


if __name__ == "__main__":
    main()
