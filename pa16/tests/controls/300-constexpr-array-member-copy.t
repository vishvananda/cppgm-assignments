// Copy a member array with nontrivial element constructors. expect exit 0
struct Element {
    int value;
    constexpr Element(int v) : value(v) {}
    constexpr Element(const Element& that) : value(that.value + 1) {}
};
struct Grid {
    Element cells[2][2];
};
constexpr bool test() {
    Grid input{{{1, 2}, {3, 4}}};
    Grid output(input);
    return input.cells[1][1].value == 4 &&
           output.cells[0][0].value == 2 && output.cells[1][1].value == 5;
}
static_assert(test(), "each array element uses its copy constructor");
int main() { return !test(); }
