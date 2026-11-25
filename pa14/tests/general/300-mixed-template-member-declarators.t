template<typename T>
struct Packet {
    unsigned ordinary, code : sizeof(T), read() const;
};

template<typename T>
unsigned Packet<T>::read() const {
    return ordinary + code;
}

int main() {
    Packet<char> small = { 17, 1 };
    Packet<unsigned long long> large = { 19, 37 };
    return small.read() != 18 || large.read() != 56;
}
