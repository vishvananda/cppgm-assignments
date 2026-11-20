constexpr bool starts_with(const char* text, const char* word)
{
  return !*word || (*text == *word && starts_with(text + 1, word + 1));
}

constexpr bool contains(const char* text, const char* word)
{
  return *text && (starts_with(text, word) || contains(text + 1, word));
}

template<class T>
int check_signature()
{
  const bool named = contains(__PRETTY_FUNCTION__, "SelectedArgument");
  char guard[sizeof(char[named]) * 2 - 1];
  char signature[sizeof(__PRETTY_FUNCTION__) - 30];
  return sizeof(guard) + sizeof(signature);
}

struct SelectedArgument {};

int use_specialized_signature()
{
  return check_signature<SelectedArgument>();
}
