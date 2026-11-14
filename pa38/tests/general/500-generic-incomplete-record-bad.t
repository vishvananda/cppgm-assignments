struct Record;
int value = _Generic(0, struct Record: 1, default: 2);
