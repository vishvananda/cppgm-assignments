template<class T> concept Big = sizeof(T) > 1;
template<Big T> struct Box {};
Box<char> bad;
int main() { return 0; }
