// expect exit 0
struct Record { int first; int second; };
struct Field { int Record::* member; };
template<Field F> const Field* key() { return &F; }
constexpr Field first{&Record::first};
constexpr Field first_again{&Record::first};
constexpr Field second{&Record::second};
constexpr Field none{nullptr};

int main() {
  Record record{3, 5};
  return key<first>() != key<first_again>() || key<first>() == key<second>() ||
         record.*key<first>()->member != 3 || record.*key<second>()->member != 5 ||
         key<none>()->member != nullptr;
}
