int main(void)
{
    int index = 0;
    int total = 0;
    for (_Static_assert(sizeof index > 1, "index type"); index != 4; ++index)
        total += index;
    return total != 6;
}
