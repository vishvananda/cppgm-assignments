struct Pair { int first; int second; };
static int* global_scalar = &(int){42};
static int* global_array = (int[]){3, 5, 7};
static struct Pair* global_record = &(struct Pair){.second=11, .first=13};
static int scalar_copy = (int){23};
static struct Pair record_copy = (struct Pair){17,19};
static int called;
static int next(void) { return ++called; }
static int sum(const struct Pair* value) { return value->first + value->second; }
int main(void) {
  if (scalar_copy != 23 || record_copy.first != 17 || record_copy.second != 19) return 10;
  int* saved = &(int){next()};
  int unrelated = 19;
  int* other = &(int){next()};
  if (saved == other || *saved != 1 || *other != 2 || unrelated != 19) return 1;
  *saved = 17;
  if (*saved != 17 || *global_scalar != 42 || global_array[2] != 7) return 2;
  if (global_record->first != 13 || global_record->second != 11) return 3;
  struct Pair* pair = &(struct Pair){.second=next(), .first=31};
  if (pair->first != 31 || pair->second != 3 || sum(&(struct Pair){4,5}) != 9) return 4;
  int* pointer = saved;
  int** pointer_object = &(int*){pointer};
  if (*pointer_object != saved) return 5;
  int* array = (int[]){next(), 23, next()};
  if (array[0] != 4 || array[1] != 23 || array[2] != 5) return 6;
  if (sizeof((int[]){2,3,4}) != sizeof(int) * 3) return 7;
  (int){next()};
  if (called != 6) return 8;
  int* first = 0;
  int* again;
  int count = 0;
repeat:
  again = &(int){count++};
  if (!first) { first = again; goto repeat; }
  if (first != again || *first != 1) return 9;
  const int* qualified = &(const int){29};
  char* text = (char[]){'o','k',0};
  return *qualified != 29 || text[1] != 'k';
}
