extern "C" const char* get_text(bool);

int main()
{
    return get_text(false)[0] != 'f' || get_text(true)[0] != 'l';
}
