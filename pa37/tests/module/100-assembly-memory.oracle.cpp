static unsigned char input[4] = {3, 5, 7, 27};
static unsigned char output[4];
extern "C" unsigned source() { return reinterpret_cast<unsigned>(input); }
extern "C" unsigned destination() { return reinterpret_cast<unsigned>(output); }
extern "C" int checksum() { return output[0] + output[1] + output[2] + output[3]; }
