// expect exit 0
char8_t global[] = u8"Aé";
char narrow[] = u8"Aé";
unsigned char bytes[] = u8"Aé";
int main() {
  char8_t local[] = u8R"(Aé)" "B";
  return sizeof(local) != 5 || global[1] != 195 || global[2] != 169 ||
         local[0] != 65 || local[3] != 66 || local[4] != 0 ||
         narrow[0] != 65 || bytes[1] != 195 || bytes[2] != 169;
}
