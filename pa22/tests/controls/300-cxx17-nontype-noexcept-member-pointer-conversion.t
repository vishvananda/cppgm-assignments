// expect exit 0
struct Record {
  int key() const & noexcept { return 7; }
};

using Member = int (Record::*)() const &;
template<Member P> struct MemberAt {
  static constexpr Member value = P;
};
template<auto P> using Converted = MemberAt<P>;

constexpr Member direct = MemberAt<&Record::key>::value;
constexpr Member converted = Converted<&Record::key>::value;

int main() {
  Record item;
  return direct == converted && (item.*converted)() == 7 ? 0 : 1;
}
