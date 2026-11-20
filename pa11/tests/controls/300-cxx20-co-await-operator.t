// N4861 [over.oper]: operator co_await can be called by name. expect exit 0
struct Member {
  int value;
  int operator co_await() const { return value; }
};

struct Free { int value; };
int operator co_await(Free object) { return object.value; }

int main() {
  Member item{20};
  return item.operator co_await() + operator co_await(Free{22}) == 42 ? 0 : 1;
}
