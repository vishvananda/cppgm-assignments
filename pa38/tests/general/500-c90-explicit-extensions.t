__extension__ typedef long long Wide;
__extension__ struct Packet { int size; int values[]; };

static int variable_size(int count)
{
    __extension__ typedef int Row[count];
    return sizeof(Row) == count * sizeof(int);
}

int main(void)
{
    Wide value = __extension__ (int){ 42 };
    struct Packet packet = { 2 };
    return value != 42 || !variable_size(packet.size);
}
