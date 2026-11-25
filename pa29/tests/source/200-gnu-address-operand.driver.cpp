extern "C" const int* symbol_address();
extern "C" const int* register_address(const int*);

int main()
{
    const int local = 3;
    return *symbol_address() != 11 || register_address(&local) != &local;
}
