template<class T> struct Trap { static_assert(sizeof(T) == 0, "must not instantiate"); };
template<class T> constexpr bool check = requires {
  requires false && (sizeof(Trap<T>) > 0) || true;
  requires (sizeof(T) > 0) || (sizeof(Trap<T>) > 0);
  requires T::missing || true;
};
static_assert(check<int>, "constraint disjunction recovers from substitution failure");
int main() { return !check<int>; }
