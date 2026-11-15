template<class T> concept Big = sizeof(T) > 1;
template<class T> requires Big<T> struct Box;
template<class U> requires (!Big<U>) struct Box;
int main() { return 0; }
