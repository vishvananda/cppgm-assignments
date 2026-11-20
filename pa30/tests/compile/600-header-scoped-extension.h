#define EXTENSION_PRAGMA(x) _Pragma(#x)
EXTENSION_PRAGMA(clang diagnostic push)
EXTENSION_PRAGMA(clang diagnostic ignored "-Wc++20-extensions")
struct HeaderValue
{
	explicit(false) HeaderValue(int);
};
EXTENSION_PRAGMA(clang diagnostic pop)
#undef EXTENSION_PRAGMA
