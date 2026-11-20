// CWG 1330 [temp.inst], [except.spec]
// Completing the enclosing class does not instantiate its member template's
// noexcept operand. A call that selects the member does need it.
// expect exit 0

template<class T> T&& value_of() noexcept;

template<class Backend>
struct Number
{
  Number() = default;
  template<class Precision>
  Number(const Number&, Precision)
    noexcept(noexcept(Backend(value_of<const Backend&>(), value_of<unsigned>()))) {}
};

struct Basic
{
  Basic() = default;
};

struct Precise
{
  Precise(const Precise&, unsigned) noexcept;
};

static_assert(sizeof(Number<Basic>) != 0, "");
static_assert(noexcept(Number<Precise>(value_of<const Number<Precise>&>(), 1u)), "");
int main() {}
