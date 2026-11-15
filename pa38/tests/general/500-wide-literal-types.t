typedef int wchar_t;
typedef unsigned short char16_t;
typedef unsigned int char32_t;
_Static_assert(_Generic(L'a', int: 1, default: 0), "wide C character type");
_Static_assert(_Generic(u'a', unsigned short: 1, default: 0), "UTF16 C character type");
_Static_assert(_Generic(U'a', unsigned int: 1, default: 0), "UTF32 C character type");
static wchar_t* wide = L"wide";
static char16_t* utf16 = u"hello";
static char32_t* utf32 = U"world";
static wchar_t buffer[] = L"copied";
static int first(const wchar_t* text) { return text[0]; }
int main(void) {
  wchar_t* local = L"local";
  if (first(wide) != 'w' || buffer[2] != 'p' || local[1] != 'o') return 1;
  if (utf16[4] != 'o' || utf32[4] != 'd') return 2;
  if (!_Generic(L"text", int*: 1, default: 0)) return 3;
  return sizeof(L'a') != sizeof(wchar_t) || sizeof(u'a') != sizeof(char16_t);
}
