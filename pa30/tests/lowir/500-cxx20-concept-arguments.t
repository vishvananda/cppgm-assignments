template<class T> concept IsInt = __is_same(T, int);
template<class T> concept HasMember = requires(T value) { value.member; };
template<class T> concept Fallback = requires { typename T::type; } || IsInt<T>;
template<int N> concept Positive = (N > 0);
template<class T, class U = T> concept Same = __is_same(T, U);
template<class... T> concept AllInts = (IsInt<T> && ...);
struct Present { using type = void; int member; };
static_assert(IsInt<int> && !IsInt<long>);
static_assert(HasMember<Present> && !HasMember<int>);
static_assert(Fallback<Present> && Fallback<int> && !Fallback<long>);
static_assert(Positive<3> && !Positive<-1>);
static_assert(Same<int> && !Same<int,long>);
static_assert(AllInts<> && AllInts<int,int> && !AllInts<int,long>);
static_assert(__is_same(decltype(IsInt<int>), bool));
static_assert(sizeof(IsInt<int>) == sizeof(bool));
template<bool B> struct Flag { static constexpr bool value = B; };
static_assert(Flag<IsInt<int>>::value);
int main() { return !IsInt<int> || HasMember<int> || !Same<long>; }
