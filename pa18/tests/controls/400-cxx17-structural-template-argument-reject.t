// expect reject
struct Key { int id; };
template<Key K> struct Entry {};
Entry<Key{7}> invalid;
