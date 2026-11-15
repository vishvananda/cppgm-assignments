template<class T> concept Object = sizeof(T) > 1;
template<class T, int N> concept Sized = sizeof(T) >= N;
Object auto value = 3;
Object decltype(auto) reference = (value);
Sized<1> auto function(Object auto argument);
