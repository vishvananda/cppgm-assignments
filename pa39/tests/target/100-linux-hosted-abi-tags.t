// Model the attribute fallback a Linux C header can introduce.
#if !defined(__GNUC__) && !defined(__clang__) && !defined(__TINYC__)
#define __attribute__(attribute)
#endif

namespace hosted {
inline namespace tagged __attribute__((__abi_tag__("course"))) {
struct Result { int value; };
}
}

hosted::Result result_from_header();
int main() { return result_from_header().value; }
