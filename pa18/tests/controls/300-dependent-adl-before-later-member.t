// expect exit 0

template<class...> using Void = void;
template<class T> T& argument();

template<class Outer>
struct Probe {
  template<class T, class = void>
  struct HasInspect { static constexpr bool value = false; };

  template<class T>
  struct HasInspect<T, Void<decltype(inspect(argument<T>()))>> {
    static constexpr bool value = true;
  };

  static constexpr int complete_class_use() { return inspect(2, 3); }
  static constexpr int inspect(int x, int y) { return x + y; }
};

namespace model {
struct WithInspect {};
struct WithoutInspect {};
void inspect(WithInspect&);
}

static_assert(Probe<int>::HasInspect<model::WithInspect>::value, "ADL uses the declaration context");
static_assert(!Probe<int>::HasInspect<model::WithoutInspect>::value, "ADL must find a viable declaration");
static_assert(Probe<int>::complete_class_use() == 5, "the member body sees the complete class");

int main() {}
