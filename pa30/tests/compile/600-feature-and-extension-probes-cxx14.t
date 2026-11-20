#if !__has_feature(cxx_binary_literals) || !__has_feature(cxx_variable_templates)
#error C++14 features must be reported in their introducing edition
#endif
#if !__has_extension(cxx_binary_literals) || !__has_extension(cxx_generic_lambdas)
#error a standard feature also answers an extension query
#endif
#if __cpp_binary_literals != 201304L || __cpp_variable_templates != 201304L
#error wrong C++14 feature-test macros
#endif
