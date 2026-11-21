// A count over a cell's neighbors, unrolled, inside loops over cells and
// rows. The test before the unrolled loop branches over the moves of the
// edge to the remaining iterations and falls into the unrolled loop, while
// the moves of an earlier, colder edge wait out of line for the next place
// no code falls through.
struct cell {
    bool alive, next;
    cell** first;
    cell** last;
};

struct row {
    cell* first;
    cell* last;
};

extern "C" __attribute__((noinline)) void step(row* rows, row* end) {
    for (row* r = rows; r != end; ++r)
        for (cell* c = r->first; c != r->last; ++c) {
            int alive = 0;
            for (cell** p = c->first; p != c->last; ++p)
                if ((*p)->alive)
                    ++alive;
            if (c->alive)
                c->next = alive == 2 || alive == 3;
            else
                c->next = alive == 3;
        }
    for (row* r = rows; r != end; ++r)
        for (cell* c = r->first; c != r->last; ++c)
            c->alive = c->next;
}
