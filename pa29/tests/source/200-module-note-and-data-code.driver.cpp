extern "C" unsigned course_note[];
extern "C" unsigned char encoded_code[];

int main()
{
    if (course_note[0] != 6 || course_note[1] != 4 || course_note[2] != 7 || course_note[5] != 27)
        return 1;
    return encoded_code[0] != 0x90 || encoded_code[1] != 0xc3;
}
