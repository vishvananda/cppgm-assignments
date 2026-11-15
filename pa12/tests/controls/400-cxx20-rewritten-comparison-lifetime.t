// C++20 rewritten comparisons retain result and operand destruction; expect exit 0
int answer_dead, category_dead, calls;
struct Answer {
 bool value;
 operator bool() const { return value; }
 ~Answer() { ++answer_dead; }
};
struct Category {
 int value;
 ~Category() { ++category_dead; }
 friend Answer operator<(Category a,int) { return {a.value < 0}; }
};
struct A { friend Category operator<=>(A,int) { ++calls; return {-1}; } };
int main() {
 if (!(A{} < 3)) return 1;
 if (calls != 1 || answer_dead != 1 || category_dead != 1) return 2;
 A{} < 3;
 return calls != 2 || answer_dead != 2 || category_dead != 2;
}
