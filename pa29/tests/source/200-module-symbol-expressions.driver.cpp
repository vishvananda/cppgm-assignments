extern "C" int symbol_expression_function();
extern "C" void symbol_expression_end();
extern "C" unsigned char byte_before_origin[];
extern "C" unsigned int measured_size;
extern "C" const unsigned char* measured_pointer;

int main()
{
    const long function_size = reinterpret_cast<long>(&symbol_expression_end)
        - reinterpret_cast<long>(&symbol_expression_function);
    return symbol_expression_function() != 27 || measured_size != function_size * 2
        || measured_pointer != byte_before_origin + 2 || byte_before_origin[0] != 0x27
        || *measured_pointer != 0x32 || measured_pointer[1] != 0x56;
}
