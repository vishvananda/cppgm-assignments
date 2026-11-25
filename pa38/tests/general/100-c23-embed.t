#define RESOURCE "100-c23-embed.inc/bytes.bin"
#define PARAMS __limit__(1 + 1) __prefix__((16 + 1),) __suffix__(, 25)
#define ANGLE <angle.bin>

#if !defined(__has_embed) || !defined(__STDC_EMBED_NOT_FOUND__) || !defined(__STDC_EMBED_FOUND__) || !defined(__STDC_EMBED_EMPTY__)
#error missing predefined embed probe or status macro
#endif
#if __STDC_EMBED_NOT_FOUND__ != 0 || __STDC_EMBED_FOUND__ != 1 || __STDC_EMBED_EMPTY__ != 2
#error incorrect embed status macro values
#endif
#if __has_embed(RESOURCE PARAMS) != __STDC_EMBED_FOUND__
#error quoted computed resource
#endif
#if __has_embed(ANGLE) != __STDC_EMBED_FOUND__
#error computed angle resource
#endif
#if __has_embed(<angle.bin> limit(__has_embed(RESOURCE))) != __STDC_EMBED_FOUND__
#error nested resource query
#endif
#if __has_embed("angle.bin") != __STDC_EMBED_FOUND__
#error quoted lookup must fall back to the embed search path
#endif
#if __has_embed(<empty.bin>) != __STDC_EMBED_EMPTY__ || __has_embed(<angle.bin> limit(0)) != __STDC_EMBED_EMPTY__
#error empty and limited resources
#endif
#if __has_embed(<angle.bin> vendor::unsupported(a[2])) != __STDC_EMBED_NOT_FOUND__
#error unsupported qualified parameter
#endif
#if __has_embed(<include-only.bin>) != __STDC_EMBED_NOT_FOUND__ || __has_embed("missing.bin") != __STDC_EMBED_NOT_FOUND__
#error resource lookup must be independent of include lookup
#endif
#if __has_embed("missing.bin" limit(0)) != __STDC_EMBED_NOT_FOUND__
#error a zero limit still requires resolving the resource
#endif

#line 400 "virtual/path/other.c"
static const unsigned char full[] = {
#embed "100-c23-embed.inc/bytes.bin"
};
static const unsigned char affixed[] = {
#embed RESOURCE PARAMS
};
static const unsigned char angle[] = {
#embed ANGLE limit(__has_include("100-c23-embed.inc/headers/include-only.bin"))
};
static const unsigned char empty[] = {
#embed <empty.bin> prefix(99,) suffix(,99) __if_empty__(42)
};
static const unsigned char zero_limit[] = {
#embed <angle.bin> limit(0) prefix(99,) suffix(,99) if_empty(43)
};
static const unsigned char nothing[] = {
  44
#embed <empty.bin>
};
int main(void) {
  return sizeof full != 3 || full[0] != 0 || full[1] != 42 || full[2] != 255 ||
         sizeof affixed != 4 || affixed[0] != 17 || affixed[1] != 0 ||
         affixed[2] != 42 || affixed[3] != 25 ||
         sizeof angle != 1 || angle[0] != 81 ||
         sizeof empty != 1 || empty[0] != 42 ||
         sizeof zero_limit != 1 || zero_limit[0] != 43 ||
         sizeof nothing != 1 || nothing[0] != 44;
}
