static int select_value(int choice)
{
    int result = 7;
    switch (choice) {
    case 0: case 1:
        static_assert(sizeof(char) == 1);
        typedef int Value;
        Value next = choice + 2;
        result = next;
        break;
    case 2:
        goto nested_end;
        {
            result = 99;
        [[maybe_unused]] nested_end:
        }
        result = 5;
        break;
    case 3:
        [[maybe_unused]] last_case:
    }
    switch (choice) {
    default:
        int adjustment = 1;
        result += adjustment;
        break;
    case 3:
        goto done;
    }
    if (choice == 2)
        goto done;
    return result;
done:
    return result;
}

int main(void)
{
    if (select_value(0) != 3 || select_value(1) != 4)
        return 1;
    if (select_value(2) != 6 || select_value(3) != 7)
        return 2;
    {
        goto finished;
        return 3;
    finished:
    }
    return 0;
}
