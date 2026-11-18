struct Triple { unsigned char bytes[3]; };
extern "C" Triple exchange(Triple v) {
    Triple result = {{v.bytes[2], v.bytes[0], v.bytes[1]}};
    return result;
}
extern "C" Triple from_boundary(const Triple* from) { return exchange(*from); }

template<int N> struct Bytes { unsigned char data[N]; };
extern "C" void copy31(Bytes<31>* to, const Bytes<31>* from) { *to = *from; }
extern "C" void copy33(Bytes<33>* to, const Bytes<33>* from) { *to = *from; }
extern "C" void copy40(Bytes<40>* to, const Bytes<40>* from) { *to = *from; }
extern "C" void copy49(Bytes<49>* to, const Bytes<49>* from) { *to = *from; }
extern "C" void copy64(Bytes<64>* to, const Bytes<64>* from) { *to = *from; }
extern "C" void copy65(Bytes<65>* to, const Bytes<65>* from) { *to = *from; }
extern "C" void copy149(Bytes<149>* to, const Bytes<149>* from) { *to = *from; }
extern "C" void clear149(Bytes<149>* to) { *to = Bytes<149>(); }

extern "C" void mark_words(const int* mask, int* out, int last) {
    for (int i = 0; i <= last; ++i)
        if (mask[i]) out[i] = 9;
}

template<class Count>
int both_set(const int* first, const int* second, Count count) {
    for (Count i = 0; i < count; ++i)
        if (first[i] && second[i]) return 1;
    return 0;
}
extern "C" int search_signed(const int* first, const int* second, int count) {
    return both_set(first, second, count);
}
extern "C" int search_unsigned(const int* first, const int* second, unsigned count) {
    return both_set(first, second, count);
}
