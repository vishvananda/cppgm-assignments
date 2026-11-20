// expect exit 0

struct Context { int number; };

template<int Number>
struct Observer {};

struct ContextBase {
  ContextBase() : context(0) {}
  explicit ContextBase(Context& value) : context(&value) {}
  Context* context;
};

struct ObserverBase {
  ObserverBase() : observer(0) {}
  template<int Number>
  explicit ObserverBase(Observer<Number>) : observer(Number) {}
  int observer;
};

struct Base : ContextBase, ObserverBase {
  using ContextBase::ContextBase;
  using ObserverBase::ObserverBase;
};

struct Derived : Base {
  using Base::Base;
};

int main() {
  Context context{17};
  Derived first(context);
  Derived second(Observer<23>{});
  return first.context == &context && first.observer == 0 && second.context == 0 &&
                 second.observer == 23 ? 0 : 1;
}
