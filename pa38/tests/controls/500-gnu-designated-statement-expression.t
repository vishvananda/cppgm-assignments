// expect exit 0
struct selection { int maximum; };

static int select_value(int value, int *evaluations)
{
    struct selection selected = {
        .maximum = ({
            int outer = (++*evaluations, value);
            ({ __auto_type inner = outer; inner < 10 ? inner : 10; });
        }),
    };
    return selected.maximum;
}

int main(void)
{
    int evaluations = 0;
    if (select_value(3, &evaluations) != 3)
        return 1;
    if (select_value(17, &evaluations) != 10)
        return 2;
    return evaluations != 2;
}
