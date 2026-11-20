// CWG 1330 [temp.inst], [except.spec]
// Selecting a member template requires its noexcept operand to be valid.
// expect reject

template<class T> T&& value_of() noexcept;

template<class Backend>
struct Number
{
  template<class Precision>
  Number(const Number&, Precision)
    noexcept(noexcept(Backend(value_of<const Backend&>(), value_of<unsigned>()))) {}
};

struct Basic
{
  Basic() = default;
};

constexpr bool result = noexcept(Number<Basic>(value_of<const Number<Basic>&>(), 1u));
