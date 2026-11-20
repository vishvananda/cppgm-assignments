// expect exit 0
template<class T> struct Box { T item; };
struct Incomplete;
template<class T> T& borrow();
template<class T> T* address(T&);
template<class T> void address(const T&&) = delete;

using Pointer = decltype(::address(::borrow<Box<Incomplete>>()));
Pointer result;
int main() { return result != nullptr; }
