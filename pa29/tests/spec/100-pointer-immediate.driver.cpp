extern "C" unsigned immediate_address();

int main()
{
    return immediate_address() != 512;
}
