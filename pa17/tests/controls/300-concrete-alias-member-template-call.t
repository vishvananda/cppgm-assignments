// expect exit 0
// N4140 [temp.names] and [temp.dep.type]

struct Offset { enum { amount = 2 }; };

struct Target {
  template<class Delta>
  static int next(int value) { return value + Delta::amount; }
};

struct Producer { static Target make(); };

template<class T>
struct Selector { using type = decltype(T::make()); };

template<class Arg>
int invoke(Arg value) {
  return Selector<Producer>::type::next<Offset>(value);
}

template<class T>
int invoke_dependent(int value) {
  return Selector<T>::type::template next<Offset>(value);
}

int main() {
  return invoke(40) == 42 && invoke_dependent<Producer>(20) == 22 ? 0 : 1;
}
