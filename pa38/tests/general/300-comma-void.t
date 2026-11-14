int value;
void update(int amount) { value += amount; }
int main(void) {
  (value = 7, update(3));
  (update(2), update(5));
  return value != 17;
}
