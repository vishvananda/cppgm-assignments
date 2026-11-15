template<class T, int N> int outer(T value) {
  auto f=[]<class U=T, int M=N>(U item={}) { return sizeof(U)+M+item; };
  return f(value)+f();
}
int main() {
  return outer<int,3>(2)!=2*sizeof(int)+8 || outer<long,7>(4L)!=2*sizeof(long)+18;
}
