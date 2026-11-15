#define WIDE_(text) L ## text
#define WIDE(text) WIDE_(text)
#if '\%' != '%' || '\q' != 'q'
#error incorrect preprocessing character value
#endif
_Static_assert('\%' == '%', "conditional character escape");
_Static_assert('\8' == '8', "not an octal escape");
_Static_assert(L'\q' == L'q', "wide character escape");
int main(void) {
  const char* text = "\%" "\q\8\n\x41\101";
  if (text[0] != '%' || text[1] != 'q' || text[2] != '8') return 1;
  if (text[3] != '\n' || text[4] != 'A' || text[5] != 'A' || text[6] != 0) return 2;
  return WIDE("\%")[0] != L'%' || sizeof("\%") != 2;
}
