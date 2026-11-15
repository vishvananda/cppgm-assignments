// C++20 rewritten candidates compete by conversion rank; expect exit 0
int calls;
struct A {
  int value;
  friend int operator<=>(A a,int b) { ++calls; return a.value-b; }
  friend bool operator<(A,double) { return false; }
  friend bool operator==(A a,int b) { return a.value == b; }
};
struct B {
  friend int operator<=>(B,int) { return -1; }
  friend bool operator<(B,int) { return false; }
};
struct MutableOnly { friend bool operator==(MutableOnly&,MutableOnly&) { return true; } };
struct ByValue { MutableOnly value; friend bool operator==(ByValue,ByValue) = default; };
int main() {
  if (!(A{1} < 2) || !(2 > A{1}) || calls != 2) return 1;
  if (!(1 == A{1}) || !(2 != A{1})) return 2;
  return (B{} < 1) || !(ByValue{} == ByValue{});
}
