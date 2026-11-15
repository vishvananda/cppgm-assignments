template<class T> concept First = true;
template<First T> concept Second = true;
int main() { return 0; }
