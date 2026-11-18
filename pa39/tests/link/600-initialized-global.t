volatile int seed = 9;
int total;
int *selected = &total;
struct Setup {
    Setup() { *selected = seed + 30; }
};
Setup setup;
int main(int argc, char** argv) {
    return argc == 2 ? *selected + argv[1][0] : *selected;
}
