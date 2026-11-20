// expect exit 0
template<class T>
concept Small = sizeof(T) == sizeof(char);

template<auto Value>
struct Selection { static constexpr int rank = 0; };

template<Small auto Value>
struct Selection<Value> { static constexpr int rank = 1; };

static_assert(Selection<'x'>::rank == 1);
static_assert(Selection<17>::rank == 0);

template<Small auto Value> constexpr int rank() { return 1; }
template<auto Value> concept CanRank = requires { rank<Value>(); };
static_assert(CanRank<'x'>);
static_assert(!CanRank<17>);

int main() {}
