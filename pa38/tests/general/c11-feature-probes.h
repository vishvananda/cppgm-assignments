#if defined(__has_feature) && defined(__has_extension)
#define QUERY_FEATURE(name) __has_feature(name)
#define QUERY_EXTENSION(name) __has_extension(name)
#define CHECK_C11_PROBES(probe, expected) \
    (probe(c_alignas) == expected && probe(c_alignof) == expected && \
     probe(c_atomic) == expected && probe(c_generic_selections) == expected && \
     probe(c_static_assert) == expected && probe(c_thread_local) == expected)

#if !CHECK_C11_PROBES(QUERY_FEATURE, EXPECT_C11_FEATURES)
#error wrong C11 feature probes
#endif

#if !CHECK_C11_PROBES(QUERY_EXTENSION, EXPECT_C11_EXTENSIONS)
#error wrong C11 extension probes
#endif
#endif
