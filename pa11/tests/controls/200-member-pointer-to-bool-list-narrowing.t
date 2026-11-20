// expect reject
struct Record { int value; };
bool narrowed{&Record::value};
