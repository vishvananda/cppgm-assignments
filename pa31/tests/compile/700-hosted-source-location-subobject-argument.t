#include <source_location>

struct Record { int counter; };
template<class T> struct Holder { T value; };
extern Holder<Record> store;

template<auto Pointer> consteval bool names_member()
{
    const char* text = std::source_location::current().function_name();
    const char* member = nullptr;
    for (const char* p = text; *p; ++p)
        if (*p == ':' && p[1] == ':')
            member = p + 2;
    constexpr char expected[] = "counter)]";
    if (!member)
        return false;
    for (const char c : expected)
        if (*member++ != c)
            return false;
    return true;
}

static_assert(names_member<&store.value.counter>());
