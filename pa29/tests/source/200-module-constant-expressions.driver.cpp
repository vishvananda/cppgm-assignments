extern "C" const unsigned expression_data[];
extern "C" unsigned expression_load();
extern "C" unsigned expression_offset(const unsigned*);

int main()
{
    const unsigned input[] = { 8, 15, 23 };
    return expression_data[0] != 17 || expression_data[1] != 11 || expression_load() != 11
        || expression_offset(input) != 36;
}
