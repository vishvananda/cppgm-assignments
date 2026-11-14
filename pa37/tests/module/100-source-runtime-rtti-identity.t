// A freestanding ABI bootstrap: runtime definitions and generated RTTI coexist.
namespace std { struct type_info { const void* vtable; const char* label; }; }
namespace __cxxabiv1 {
struct __class_type_info { virtual ~__class_type_info(); };
__class_type_info::~__class_type_info() {}
}
void operator delete(void*) noexcept {}
struct Item {};
extern "C" int observe() { return typeid(Item).label[0] == '4'; }
