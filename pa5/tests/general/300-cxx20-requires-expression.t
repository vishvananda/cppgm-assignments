template<class T> bool check() {
  return requires(T value) {
    value + value;
    typename T::type;
    { value.run() } noexcept;
    requires (sizeof(T) > 1);
  };
}
