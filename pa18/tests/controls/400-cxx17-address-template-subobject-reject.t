// expect reject
struct Record { int field; };
Record record;
template<int* P> struct Pointer {};
Pointer<&record.field> invalid;
