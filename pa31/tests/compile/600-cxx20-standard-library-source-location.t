#if !__has_builtin(__builtin_source_location)
#error source location builtin must be available to the host header
#endif
#include <source_location>

constexpr std::source_location get(std::source_location location = std::source_location::current()) {
  return location;
}

#line 100 "fixture.cpp"
constexpr auto source = std::source_location::current();
static_assert(source.line() == 100 && source.column() > 0);
static_assert(source.file_name()[0] == 'f' && source.function_name()[0] == '\0');
constexpr auto caller = get();
static_assert(caller.line() == 103);

struct Aggregate {
  std::source_location member = std::source_location::current();
};

#line 200 "fixture.cpp"
constexpr auto aggregate = Aggregate{};
static_assert(aggregate.member.line() == 200);

consteval unsigned quotient(std::source_location location = std::source_location::current()) {
  return 100u / (location.line() - 400u);
}

#line 400 "fixture.cpp"
unsigned receive(unsigned result = quotient()) { return result; }

#line 500 "fixture.cpp"
consteval std::source_location in_body() {
  return std::source_location::current();
}

constexpr unsigned body_line(std::source_location location = in_body()) {
  return location.line();
}

static_assert(body_line() == 501);

int main() {
#line 300 "fixture.cpp"
  auto current = get();
  if (current.line() != 300 || current.column() == 0 || current.file_name()[0] != 'f' ||
      current.function_name()[0] == '\0')
    return 1;
#line 310 "fixture.cpp"
  auto runtime_aggregate = Aggregate{};
  if (runtime_aggregate.member.line() != 310 || runtime_aggregate.member.function_name()[0] == '\0')
    return 2;
#line 410 "fixture.cpp"
  if (receive() != 10)
    return 3;
  return body_line() == 501 ? 0 : 4;
}
