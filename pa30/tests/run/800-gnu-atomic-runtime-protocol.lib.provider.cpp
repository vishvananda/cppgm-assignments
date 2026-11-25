#include <cstddef>
#include <cstring>
#if defined(__APPLE__)
#define ATOMIC_ABI(name) "_" name
#else
#define ATOMIC_ABI(name) name
#endif
static int calls[4];
static bool good=true;
static std::size_t expected_width=17;
static bool replace_pending;
static unsigned char replacement[17];
static bool valid(std::size_t n,int order){if(n!=expected_width||n>17||order<0||order>5){good=false;return false;}return true;}
extern "C" void protocol_load(std::size_t,const void*,void*,int) __asm__(ATOMIC_ABI("__atomic_load"));
extern "C" void protocol_store(std::size_t,void*,const void*,int) __asm__(ATOMIC_ABI("__atomic_store"));
extern "C" void protocol_exchange(std::size_t,void*,const void*,void*,int) __asm__(ATOMIC_ABI("__atomic_exchange"));
extern "C" bool protocol_compare(std::size_t,void*,void*,const void*,int,int) __asm__(ATOMIC_ABI("__atomic_compare_exchange"));
extern "C" void protocol_load(std::size_t n,const void* p,void* out,int order){++calls[0];if(valid(n,order))std::memcpy(out,p,n);}
extern "C" void protocol_store(std::size_t n,void* p,const void* value,int order){++calls[1];if(valid(n,order))std::memcpy(p,value,n);}
extern "C" void protocol_exchange(std::size_t n,void* p,const void* value,void* out,int order){++calls[2];if(valid(n,order)){unsigned char desired[17];std::memcpy(desired,value,n);std::memcpy(out,p,n);std::memcpy(p,desired,n);}}
extern "C" bool protocol_compare(std::size_t n, void* p, void* expected, const void* desired, int success, int failure)
{
    ++calls[3];
    if (!valid(n, success) || !valid(n, failure))
        return false;
    if (failure == 3 || failure == 4)
        good = false;
    if (replace_pending) {
        std::memcpy(p, replacement, n);
        replace_pending = false;
    }
    if (std::memcmp(p, expected, n) != 0) {
        std::memcpy(expected, p, n);
        return false;
    }
    std::memcpy(p, desired, n);
    return true;
}
extern "C" int atomic_runtime_calls(int index){return calls[index];}
extern "C" int atomic_runtime_protocol_ok(){return good;}
extern "C" void atomic_runtime_expect_width(std::size_t width){expected_width=width;}
extern "C" void atomic_runtime_replace_once(const void* value)
{
    std::memcpy(replacement, value, expected_width);
    replace_pending = true;
}
