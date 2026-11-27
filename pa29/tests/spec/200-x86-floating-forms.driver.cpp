#include <cstring>

extern "C" double asm_sqrt_double(double, const double*);
extern "C" float asm_sqrt_float(const float*);
extern "C" void asm_x87_sum(const double*, double*);
extern "C" const char* asm_comment_text();

int main()
{
    const double offset = 3;
    const float square = 81;
    double sum = 0;
    asm_x87_sum(&offset, &sum);
    return asm_sqrt_double(49, &offset) != 10 || asm_sqrt_float(&square) != 9
        || sum != 4 || std::strcmp(asm_comment_text(), "// yes") != 0;
}
