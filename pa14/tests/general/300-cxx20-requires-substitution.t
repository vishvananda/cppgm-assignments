struct Complete { using type = void; int value; };
struct Missing {};
template<class T> bool check() {
  return requires(T value) { typename T::type; value.value; };
}
int main() { return !check<Complete>() || check<Missing>() || check<int>(); }
