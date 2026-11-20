// N4140 [lex.ext], [dcl.spec.auto]
// Deduce the literal operator's specialization result in decltype and in calls.
// expect exit 0

template<unsigned Digits>
struct Count
{
  unsigned size() const { return Digits; }
};

template<char... Digits>
auto operator""_count()
{
  return Count<sizeof...(Digits)>{};
}

int accept(Count<2> value) { return value.size(); }

int main()
{
  decltype(12_count) first = 12_count;
  return accept(first) == 2 && (456_count).size() == 3 ? 0 : 1;
}
