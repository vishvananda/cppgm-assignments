
constexpr bool starts_with(const char* text, const char* word)
{
  return !*word || (*text == *word && starts_with(text + 1, word + 1));
}

constexpr bool contains(const char* text, const char* word)
{
  return *text && (starts_with(text, word) || contains(text + 1, word));
}

struct Record { int first_field; int second_field; };
Record record;

template<const int* P>
constexpr const char* signature()
{
  return __PRETTY_FUNCTION__;
}

static_assert(contains(signature<&record.first_field>(), ".first_field]"));
static_assert(!contains(signature<&record.first_field>(), "second_field"));
static_assert(contains(signature<&record.second_field>(), "second_field"));
