struct Register {
    unsigned head : 3, ordinary, : 0, tail : 4, read() const;
};

unsigned Register::read() const {
    return head + ordinary + tail;
}

struct State {
    enum Value { Idle, Ready, Busy } plain, field : 3;
};

int main() {
    Register reg = { 1, 20, 3 };
    State state = { State::Busy, State::Ready };
    reg.tail += state.field;
    return reg.read() != 25 || state.plain != State::Busy;
}
