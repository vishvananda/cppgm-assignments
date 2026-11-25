struct chain {
    struct chain *next;
    struct chain *prev;
};

int main(void)
{
    static struct chain head = { &head, &head };
    static struct chain tail = { &head, &tail };
    return head.next != &head || head.prev != &head || tail.next != &head || tail.prev != &tail;
}
