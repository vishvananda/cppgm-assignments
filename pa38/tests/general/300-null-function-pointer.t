typedef int (*Callback)(int);
struct Callbacks { Callback first; Callback second; void *data; };
struct Callbacks callbacks = { (void*)0, (void*)(1 - 1), (void*)0 };
int main(void) {
  Callback cb = (void*)0;
  cb = (void*)(3 - 3);
  return !(cb == (void*)0 && (void*)0 == callbacks.first &&
           callbacks.second == 0 && callbacks.data == 0);
}
