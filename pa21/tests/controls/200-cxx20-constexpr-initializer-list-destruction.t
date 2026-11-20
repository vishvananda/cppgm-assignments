// N4861 [dcl.init.list] and [class.temporary]
// expect exit 0
namespace std {
template<class T> class initializer_list {
  const T* data;
  decltype(sizeof(0)) count;
public:
  constexpr initializer_list() : data(nullptr), count(0) {}
  constexpr const T* begin() const { return data; }
  constexpr decltype(sizeof(0)) size() const { return count; }
};
}

struct Stamp {
  unsigned* log;
  unsigned digit;
  constexpr ~Stamp() { *log = *log * 10 + digit; }
};

constexpr bool use(std::initializer_list<Stamp> list) {
  return list.size() == 1 && *list.begin()->log == 0;
}

constexpr unsigned list_lifetimes() {
  unsigned log = 0;
  const bool observed = use({Stamp{&log, 1}});
  if (!observed || log != 1)
    return 0;
  {
    std::initializer_list<Stamp> list{Stamp{&log, 5}, Stamp{&log, 4}};
    auto copy = list;
    if (log != 1 || copy.size() != 2)
      return 0;
    log = copy.begin()->digit - 2;
  }
  return log;
}

static_assert(list_lifetimes() == 345);
int main() {}
