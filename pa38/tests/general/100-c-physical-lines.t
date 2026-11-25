#define TOTAL 1\+2#if TOTAL != 3#error split macro value#endif
#if 0// Continue this comment over the first #endif. \#endif#endif#define HEX 0x1p??/+3
#if __LINE__ != 12#error physical line number#endif
#line 100 "physical-lines"#if __LINE__ != 100#error presumed line number#endif
int main(void) { return HEX != 8.0; }
