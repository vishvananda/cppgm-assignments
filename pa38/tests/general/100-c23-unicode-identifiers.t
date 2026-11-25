#define λ 17
#define x̀ 25
#define JOIN(a, b) a ## b
#define QUOTE(a) #a
#define QUOTE_EXPANDED(a) QUOTE(a)
#define MARK ©

#if \u03BB != 17 || x\u0300 != 25
#error raw and escaped identifier spellings must match
#endif

static int πδ = 42;
static int x٢ = 4;
static int \U0002EBF0 = 7;
static int 가 = 5;
static int Ál = 6;
static int split\
猫 = 9;

int main(void)
{
    return JOIN(π, δ) != 42 || x\u0662 != 4 || 𮯰 != 7 || \uAC00 != 5 ||
           \u00C1l != 6 || split猫 != 9 ||
           sizeof QUOTE_EXPANDED(MARK) != 3 || sizeof QUOTE(0à) != 5 ||
           sizeof "\u212A" != 4;
}
