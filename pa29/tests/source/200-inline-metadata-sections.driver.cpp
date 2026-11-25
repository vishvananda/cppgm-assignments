extern "C" {
    const char* emit_metadata(int*);
    extern const int compiler_metadata_record[];
    int external_data = 19;
}

int main()
{
    int value = 11;
    const char* code = emit_metadata(&value);
    const int* record = compiler_metadata_record;
    const long start = reinterpret_cast<long>(record);
    return value != 14 || start + record[0] != reinterpret_cast<long>(code)
        || start + sizeof(int) + record[1] != reinterpret_cast<long>(&external_data)
        || record[2] != 0x5a5a5a5a;
}
