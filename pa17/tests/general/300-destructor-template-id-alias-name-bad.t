template<class T> struct Value { template<class U> using Alias = Value<U>; ~Alias<T>() {} };
