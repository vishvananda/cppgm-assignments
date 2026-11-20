#if defined(BEFORE_MARK)
inline int before_mark(int x)
{
	if constexpr (true)
		return x;
}
#endif

#pragma GCC system_header

inline int after_mark(int x)
{
	if constexpr (true)
		return x;
}
