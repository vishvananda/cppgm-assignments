namespace N {template<class T> concept Modular = requires(T value) { value % value; };}
using N::Modular;

int main() { return !N::Modular<unsigned> || !Modular<int>; }
