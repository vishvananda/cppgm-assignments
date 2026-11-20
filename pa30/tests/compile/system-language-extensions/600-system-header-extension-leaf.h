#if __cplusplus != 201103L || !defined(__STRICT_ANSI__) || defined(__cpp_if_constexpr)
#error the header must retain the translation unit language mode
#endif

template<class T>
int from_header(T n)
{
	if constexpr (sizeof(T) == sizeof(int))
		return n;
	else
		return n.missing();
}
