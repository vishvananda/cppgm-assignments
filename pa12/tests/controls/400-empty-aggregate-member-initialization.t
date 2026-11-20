// expect exit 0
struct Field {};
struct Aggregate { Field first; Field second; };

struct Initializer {
  int& count;
  operator Field() const { ++count; return {}; }
};

int defaults = 0;
Field make_field() { ++defaults; return {}; }
struct Defaulted { Field field = make_field(); };

int main() {
  int count = 0;
  (void)Aggregate{Initializer{count}, Initializer{count}};
  (void)Defaulted{};
  return count != 2 || defaults != 1;
}
