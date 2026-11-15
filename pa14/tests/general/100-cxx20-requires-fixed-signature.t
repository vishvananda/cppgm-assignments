template<class T> void function(int (&)[requires { 1; }]);
template<class T> void function(int (&)[requires { 1; }]) {}
int main() { int values[1]; function<int>(values); }
