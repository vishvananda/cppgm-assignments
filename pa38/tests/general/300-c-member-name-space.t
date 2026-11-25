typedef char Size;
enum { Width = 4 };

struct Header {
    unsigned Size, present : sizeof(Size), Width : 3, value : Width;
};

struct Trailer {
    unsigned Size : 2, present : sizeof(Size);
};

int main(void) {
    struct Header header = { 10, 1, 5, 13 };
    struct Trailer trailer = { 2, 1 };
    return header.Size != 10 || header.present != 1 || header.Width != 5 ||
        header.value != 13 || trailer.Size != 2 || trailer.present != 1;
}
