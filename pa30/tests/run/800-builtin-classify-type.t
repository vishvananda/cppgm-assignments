struct Record { int member; };
union Union { int integer; double real; };

template<class T> struct Query {
  enum { type = __builtin_classify_type(T), expression = __builtin_classify_type((T())) };
};

static_assert(Query<double>::type == 8 && Query<double>::expression == 8, "");
static_assert(__builtin_classify_type(void) == 0, "");
static_assert(__builtin_classify_type(bool) == 4, "");
static_assert(__builtin_classify_type(int&) == 6, "");
static_assert(__builtin_classify_type(&Record::member) == 7, "");
static_assert(__builtin_classify_type(Record) == 12, "");
static_assert(__builtin_classify_type(Union) == 13, "");
static_assert(__builtin_classify_type(int[3]) == 14, "");

int effect(int*);
constexpr int constant_operand() { return 42; }
template<int Category> struct Tag {};
using Classified = Tag<__builtin_classify_type(constant_operand())>;
static_assert(__is_same(Classified, Tag<1>), "");

int main() {
  int effects = 0;
  int array[3] = {};
  static_assert(__builtin_classify_type(array) == 5, "");
  static_assert(__builtin_classify_type(effect) == 5, "");
  static_assert(__builtin_classify_type(decltype(effect)) == 10, "");
  if (__builtin_classify_type(effect(&effects)) != 1 || effects != 0)
    return 1;
  return __builtin_classify_type(effect(&effects), effect(&effects)) != 1 || effects != 2;
}
