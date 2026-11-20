// expect exit 0
namespace network {
template<int Family> struct Protocol {
  int code;
  constexpr int family() const { return Family; }
};

template<Protocol P> struct Profile {
  static constexpr int family = P.family();
  static constexpr const decltype(P)* value() { return &P; }
};

template<Protocol P> constexpr int code() { return Profile<P>::value()->code; }
constexpr Protocol<4> input{7};
static_assert(Profile<input>::family == 4);
static_assert(code<input>() == 7);

template<int Family> struct FamilyTag {};
constexpr int port(FamilyTag<4>, unsigned short value) { return value; }

struct Endpoint {
  unsigned short value;
  template<Protocol P>
    requires requires(FamilyTag<P.family()> tag) { port(tag, 0); }
  friend constexpr int read(Endpoint ep) { return port(FamilyTag<P.family()>{}, ep.value); }
};
}

int main() {
  using network::Profile;
  using network::Protocol;
  using network::input;
  return Profile<input>::value() != Profile<Protocol<4>{7}>::value() ||
         Profile<input>::value() == Profile<Protocol<4>{8}>::value() ||
         read<network::input>(network::Endpoint{1234}) != 1234;
}
