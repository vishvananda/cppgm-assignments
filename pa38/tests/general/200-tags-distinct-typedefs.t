struct Item { int tag_value; };
typedef struct Row { int row_value; } Item;
enum Status { ready = 7 };
typedef long Status;
union Choice { int number; };
typedef double Choice;
struct Future;
typedef int Future;
struct Future { long value; };
typedef long Reverse;
struct Reverse { int value; };
struct Device { struct Backend* data; };
typedef struct Node { int buttons; } Backend;
int main(void) {
  struct Item tag = {17}; Item alias = {23};
  enum Status state = ready; Status wide = 3;
  union Choice tag_union = {5}; Choice real = 1.5;
  struct Future object = {11}; Future integer = 13;
  struct Reverse reversed = {31}; Reverse scalar = 37;
  if (reversed.value != 31 || scalar != 37) return 3;
  Backend node = {19}; struct Device device;
  device.data = (struct Backend*)&node;
  Backend* recovered = (Backend*)device.data;
  if (tag.tag_value != 17 || alias.row_value != 23 || state != ready || wide != 3) return 1;
  if (tag_union.number != 5 || real != 1.5 || object.value != 11 || integer != 13) return 2;
  return recovered->buttons != 19 || sizeof(Status) != sizeof(long);
}
