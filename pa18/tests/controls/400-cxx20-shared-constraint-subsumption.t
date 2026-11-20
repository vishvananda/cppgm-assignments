// expect exit 0
template<class T, unsigned Bit>
concept Set = (sizeof(T) & Bit) != 0;

template<class T, unsigned Bit>
concept Clear = (sizeof(T) & Bit) == 0;

template<class T>
concept Domain = (Set<T, 1> || Clear<T, 1>) && (Set<T, 2> || Clear<T, 2>) &&
                 (Set<T, 4> || Clear<T, 4>) && (Set<T, 8> || Clear<T, 8>) &&
                 (Set<T, 16> || Clear<T, 16>) && (Set<T, 32> || Clear<T, 32>) &&
                 (Set<T, 64> || Clear<T, 64>) && (Set<T, 128> || Clear<T, 128>);

template<class T>
concept Wide = Domain<T> && (sizeof(T) > 1);

template<Domain T> constexpr int choose() { return 1; }
template<Wide T> constexpr int choose() { return 2; }

static_assert(choose<char>() == 1);
static_assert(choose<int>() == 2);
int main() {}
