#define PRESENT
#if __has_embed("100-c23-embed.inc/bytes.bin" limit(defined(PRESENT)))
int yes;
#endif
