extern int declared_first(int);
inline int declared_first(int n) { return n + 3; }

inline int declared_last(int n) { return n + 5; }
extern int declared_last(int);

extern inline int declared_with_extern(int n) { return n + 7; }

int inline_only(int n) { return n + 9; }
