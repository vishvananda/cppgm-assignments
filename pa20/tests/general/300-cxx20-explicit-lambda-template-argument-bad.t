int main() { auto f=[]<int N>() { return N; }; return f.operator()<int>(); }
