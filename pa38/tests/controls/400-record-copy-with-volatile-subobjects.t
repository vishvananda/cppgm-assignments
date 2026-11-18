// expect exit 0
struct Lock {
  union {
    int fields[10];
    volatile int shared[10];
  } storage;
};

int main(void)
{
  struct Lock before = { .storage.fields = {1, 2, 3, 4, 5} };
  const struct Lock saved = before;
  struct Lock after = {0};
  before.storage.fields[2] = 17;
  after = saved;
  return after.storage.fields[2] != 3 || after.storage.fields[4] != 5
    || before.storage.fields[2] != 17;
}
