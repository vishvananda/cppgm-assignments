template<class T> concept Modular = requires(T value) { value % value; };
struct Object {};
int main() { return !Modular<int> || Modular<Object> || sizeof(Modular<void>) != sizeof(bool); }
