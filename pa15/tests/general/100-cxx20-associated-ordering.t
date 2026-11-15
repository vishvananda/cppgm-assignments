// Concept normalization must retain atomic identity and ignore unused mappings.
template<class T> concept Big = sizeof(T) > 1;
template<class T> concept Huge = sizeof(T) > 2;
template<class T> concept Always = true;
template<class T> requires Big<T> int pick(T) { return 1; }
template<class T> requires Big<T> && Huge<T> int pick(T) { return 2; }
template<class T> int pick(T) { return 3; }
template<class U> requires Big<U> int pick(U);
template<class T, class U> requires Always<T> int mapped(T, U) { return 1; }
template<class T, class U> requires Always<U> && Big<T> int mapped(T, U) { return 2; }
template<class T> requires Big<T> || Huge<T> int either(T) { return 1; }
template<class T> requires Big<T> int either(T) { return 2; }
int main() { return pick(1) + pick(short(1)) + pick(char(1)) + mapped(1, 2) + either(1) - 10; }
