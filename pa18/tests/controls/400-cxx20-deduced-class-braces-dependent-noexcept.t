// expect exit 0
namespace lib {
template<class T> concept Range = requires(T& t) { t.value; };

template<Range R> struct View {
  template<class T> explicit View(T&& ref) noexcept(R::nonThrowing): pointer(&ref) {}
  R* pointer;
};
template<class R> View(R&) -> View<R>;

struct Adapt {
  template<class T>
    requires requires(T& value) { lib::View{value}; }
  auto operator()(T& value) const noexcept(noexcept(lib::View{value})) {
    return lib::View{value};
  }
};
}

struct Safe {
  static constexpr bool nonThrowing = true;
  int value;
};
struct MayThrow {
  static constexpr bool nonThrowing = false;
  int value;
};

int main() {
  Safe safe{3};
  MayThrow maybe{4};
  static_assert(noexcept(lib::Adapt{}(safe)));
  static_assert(!noexcept(lib::Adapt{}(maybe)));
  return lib::Adapt{}(safe).pointer != &safe || lib::Adapt{}(maybe).pointer != &maybe;
}
