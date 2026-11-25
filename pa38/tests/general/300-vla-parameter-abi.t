int last_column(int columns, int data[static 2][columns]);

int check_vla_parameter(void)
{
    int values[2][3] = {{8, 0, 0}, {0, 0, 21}};
    volatile int columns = 3;
    return last_column(columns, values) != 29;
}

int main(void) { return check_vla_parameter(); }
