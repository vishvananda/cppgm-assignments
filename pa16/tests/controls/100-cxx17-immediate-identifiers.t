// expect exit 0
int consteval = 4;
int constinit = 5;
int main() { return consteval + constinit == 9 ? 0 : 1; }
