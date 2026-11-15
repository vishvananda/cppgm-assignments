int main() {
  auto f=[]<class T> requires (sizeof(T)>sizeof(char)) (T value) { return value; };
  return f('x');
}
