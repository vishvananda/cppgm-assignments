// Repeated concept edges must reuse normalization, not expand exponentially.
template<class T> concept C0 = sizeof(T)>0;
template<class T> concept C1 = C0<T> && C0<T>;
template<class T> concept C2 = C1<T> && C1<T>;
template<class T> concept C3 = C2<T> && C2<T>;
template<class T> concept C4 = C3<T> && C3<T>;
template<class T> concept C5 = C4<T> && C4<T>;
template<class T> concept C6 = C5<T> && C5<T>;
template<class T> concept C7 = C6<T> && C6<T>;
template<class T> concept C8 = C7<T> && C7<T>;
template<class T> concept C9 = C8<T> && C8<T>;
template<class T> concept C10 = C9<T> && C9<T>;
template<class T> concept C11 = C10<T> && C10<T>;
template<class T> concept C12 = C11<T> && C11<T>;
template<class T> concept C13 = C12<T> && C12<T>;
template<class T> concept C14 = C13<T> && C13<T>;
template<class T> concept C15 = C14<T> && C14<T>;
template<class T> concept C16 = C15<T> && C15<T>;
template<class T> concept C17 = C16<T> && C16<T>;
template<class T> concept C18 = C17<T> && C17<T>;
template<class T> concept C19 = C18<T> && C18<T>;
template<class T> concept C20 = C19<T> && C19<T>;
template<class T> concept C21 = C20<T> && C20<T>;
template<class T> concept C22 = C21<T> && C21<T>;
template<class T> concept C23 = C22<T> && C22<T>;
template<class T> concept C24 = C23<T> && C23<T>;
template<class T> requires C24<T> int f(T){return 1;}
template<class T> requires C24<T> && (sizeof(T) > 1) int f(T){return 2;}
int main(){return f(1)-2;}
