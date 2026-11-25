struct Header {
    unsigned begin : 3, middle, : 0, end : 4, tail[2];
};

union State {
    enum { Idle, Ready, Busy } plain, code : 3;
};

struct Counter {
    unsigned ordinary, next : 4;
};

int main(void) {
    struct Header header = { 2, 5, 9, { 13, 17 } };
    union State state = { .plain = Ready };
    struct Counter counter = { 19, 3 };
    if (header.begin != 2 || header.middle != 5 || header.end != 9 ||
        header.tail[0] != 13 || header.tail[1] != 17 ||
        state.plain != Ready || counter.ordinary != 19 || counter.next != 3)
        return 1;
    state.code = Busy;
    header.end++;
    counter.next += 2;
    return header.end != 10 || state.code != Busy || counter.next != 5;
}
