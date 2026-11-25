#define WIDE(piece) L ## piece
const __WCHAR_TYPE__ *bad = L"prefix " WIDE("\u0041");
