// A binary tree insertion loop. The node pointer is live on the paths that
// add a node, so the next node needs its own register and a copy each time
// round the loop. Both descents take the copy at the loop header.
struct node {
    node* left;
    node* right;
    int key;
};

extern "C" node* make_node(int key);
extern "C" node* tree;

extern "C" __attribute__((noinline)) void insert_all(const int* keys, int count) {
    for (int i = 0; i < count; ++i) {
        const int key = keys[i];
        node* at = tree;
        for (;;) {
            if (key > at->key) {
                node* next = at->left;
                if (!next) {
                    at->left = make_node(key);
                    break;
                }
                at = next;
            } else if (key < at->key) {
                node* next = at->right;
                if (!next) {
                    at->right = make_node(key);
                    break;
                }
                at = next;
            } else
                break;
        }
    }
}
