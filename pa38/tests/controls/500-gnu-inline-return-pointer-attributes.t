// expect exit 0
extern inline int * __attribute__((__gnu_inline__, __always_inline__))
identity(int *value)
{
  return value;
}

int main(void)
{
  int value = 42;
  return *identity(&value) != 42;
}
