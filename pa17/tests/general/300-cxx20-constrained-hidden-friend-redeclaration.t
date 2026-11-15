template<class T> concept C = sizeof(T)>0;
template<class T> concept D = sizeof(T)>1;
struct A {
 int x;
 template<class T> requires C<T> friend int f(T) {return 1;}
 template<class T> requires C<T> && D<T> friend int f(T) {return 2;}
};
template<class U> requires C<U> && D<U> int f(U);
int main(){return f(A{})-2;}
