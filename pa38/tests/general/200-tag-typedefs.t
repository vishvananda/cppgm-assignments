typedef enum Mode { first, second } Mode;
typedef struct Context Context;
struct Context { int value; Mode mode; Context *next; };
typedef union Number Number;
union Number { int value; unsigned bits; };
int read_context(const Context *context, Mode mode) {
  return context->mode == mode ? context->value : -1;
}
int main(void) {
  Context tail = { 19, first, 0 }, context = { 17, second, &tail };
  Number number = { 4 };
  return !(read_context(&context, second) == 17 && number.value == 4 &&
           context.next->value == 19);
}
