// expect reject
struct Value { int n; consteval Value(int value) : n(value) {} };
struct Member { Value value; Member(int n) : value(n) {} };
