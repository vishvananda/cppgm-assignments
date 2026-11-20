#if defined(__cpp_consteval) || defined(__cpp_constinit) || defined(__cpp_constexpr_dynamic_alloc)
#error later feature macros in an older mode
#endif
#if defined(__cpp_impl_coroutine)
#error coroutine feature macro in an older mode
#endif
consteval constinit
