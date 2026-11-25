struct Record { unsigned bits : 3; } item;

int alignment = __alignof__((item.bits));
