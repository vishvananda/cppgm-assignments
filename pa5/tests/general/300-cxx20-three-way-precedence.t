struct C { int operator<=>(const C&) const; };
int f(int a,int b,int c) { return a << 1 <=> b + c < 0 == true; }
int g(int a,int b,int c) { return a <=> b <=> c; }
