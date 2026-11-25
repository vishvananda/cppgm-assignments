int first(int values[const *]);
int first(int *values);
int first(int values[const 2]) { return values[0]; }

int callback(int fn(int values[*]), int *values) { return fn(values); }

int main(void)
{
    int values[2] = { 7, 9 };
    return first(values) != 7 || callback(first, values) != 7;
}
