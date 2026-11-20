#if __has_feature(cxx_binary_literals) || __has_feature(cxx_variable_templates)
#error C++14 features must not be reported in C++11
#endif
#if !__has_extension(cxx_binary_literals)
#error binary literals are available as an extension in this mode
#endif
#if __has_extension(cxx_generic_lambdas)
#error the feature requires C++14
#endif
#if defined(__cpp_binary_literals) || defined(__cpp_variable_templates)
#error extension support does not change the C++11 feature-test macros
#endif
