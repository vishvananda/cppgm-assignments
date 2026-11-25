extern "C" int select_number(int);
extern "C" __attribute__((overloadable)) int select_number(double);

int main() {
  int (*select_double)(double) = &select_number;
  return select_number(1) != 2 || select_double(2.0) != 4;
}
