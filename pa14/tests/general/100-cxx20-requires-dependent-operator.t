template<class T>
concept Equality = requires(const T& a, const T& b) {
    a == b;
    a != b;
};

namespace keys {
struct Key {};
bool operator==(const Key&, const Key&);
struct Opaque {};
}

int main() {
    return !Equality<keys::Key> || Equality<keys::Opaque>;
}
