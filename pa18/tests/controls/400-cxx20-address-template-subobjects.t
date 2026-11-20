// expect exit 0
struct Record { int first; int second; };
Record record{3, 7};
int numbers[] = {2, 5, 11};
constexpr int& alias = record.second;

template<int* P> struct Pointer {};
template<int& R> struct Reference {};
template<class T, class U> struct Same { static constexpr bool value = false; };
template<class T> struct Same<T, T> { static constexpr bool value = true; };

static_assert(!Same<Pointer<&record.first>, Pointer<&record.second>>::value);
static_assert(Same<Reference<alias>, Reference<record.second>>::value);
static_assert(Same<Pointer<numbers>, Pointer<&numbers[0]>>::value);
static_assert(Same<Pointer<numbers + 2>, Pointer<&numbers[2]>>::value);

constexpr int* member() { return &record.second; }
template<const int* P> int read_pointer() { return *P; }
template<int& R> int& read_reference() { return R; }
template<void* P> void* read_erased_pointer() { return P; }
template<int* P> int read_preceding() { return P[-1]; }
struct Address { int* pointer; int& reference; };
template<Address A> const Address* read_address() { return &A; }

int main() {
  static Record local{13, 17};
  const Address* stored = read_address<Address{member(), record.first}>();
  return read_pointer<member()>() != 7 || &read_reference<alias>() != &record.second ||
         stored->pointer != &record.second || &stored->reference != &record.first ||
         read_preceding<numbers + 3>() != 11 || read_pointer<&local.second>() != 17 ||
         read_erased_pointer<static_cast<void*>(&record.second)>() != &record.second;
}
