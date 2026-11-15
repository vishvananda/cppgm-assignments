// GNU cold marks a rare path. A call of a cold function, and a call on the
// path to one, may stay a call or go inline; a cold function may keep its
// callees out of line. An ordinary caller still inlines a small callee.
volatile int sink;
extern "C" {
__attribute__((cold)) void report(int code, int value)
{
  sink = code;
  sink = value;
  sink = code * value;
  sink = code + value;
  sink = code - value;
  sink = code ^ value;
}
__attribute__((cold)) void note(int code) { sink = code; }
int helper(int x) { return x * 3 + (x >> 2) - (x & 7) + (x | 9) * 5; }
[[gnu::cold]] int slow_path(int x) { return helper(x) + helper(x + 1); }
int fast_path(int x) { return helper(x) + helper(x + 1); }
int checked_sum(const int* values, int count)
{
  int sum = 0;
  for (int i = 0; i < count; ++i)
  {
    if (values[i] < 0)
    {
      sink = helper(values[i]);
      report(i, values[i]);
    }
    sum += values[i];
  }
  return sum;
}
int noted(int value)
{
  if (value < 0)
  {
    sink = helper(value);
    note(value);
  }
  return value + 1;
}
}

int main()
{
  int values[4] = { 1, -2, 3, 4 };
  int sum = checked_sum(values, 4);
  return sum == 6 && slow_path(sum) == fast_path(sum) && noted(-1) == 0 ? 0 : 1;
}
