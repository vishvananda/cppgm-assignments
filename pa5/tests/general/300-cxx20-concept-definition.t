template<class T> concept Integral = sizeof(T) > 1;
template<class T, class U> concept Same = true;
template<class T> concept Returning = requires(T value) {
  { value.field } noexcept -> Same<int&>;
  requires Integral<T>;
};
