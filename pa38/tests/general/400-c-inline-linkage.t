extern int declared_first(int);
inline int declared_first(int);
inline int declared_first(int n) { return n + 3; }

static int increment = 5;
inline int declared_last(int n)
{
  static int local;
  local = increment;
  return n + local;
}
extern int declared_last(int);

extern inline int declared_with_extern(int n) { return n + 7; }

int inline_only(int n) { return n + 9; }
