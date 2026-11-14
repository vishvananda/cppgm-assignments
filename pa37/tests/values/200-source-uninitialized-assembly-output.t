extern "C" int observe() { int value; asm("" : "=r"(value)); return value; }
