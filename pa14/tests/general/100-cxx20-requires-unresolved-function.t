struct Overloaded { static void function(int); static void function(double); };
struct Member { void function(); };
template<class T> bool valid() { return requires(T value) { value.function; }; }
int main() { return valid<Overloaded>() || valid<Member>(); }
