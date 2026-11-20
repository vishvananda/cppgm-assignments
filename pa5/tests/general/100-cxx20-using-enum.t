enum class Direction { north, south };
using enum Direction;
struct Route {
    using enum ::Direction;
};

using selected = char[16];
struct Table { enum class Key; };
enum class Table::Key { selected };
using KeyAlias = Table::Key;
void lookup() {
    using enum KeyAlias;
    static_assert(sizeof(selected) == sizeof(Table::Key));
}
