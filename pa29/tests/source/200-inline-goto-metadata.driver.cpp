extern "C" int branch_with_metadata(int);
extern "C" const int branch_metadata_record[];

int main()
{
    return branch_with_metadata(0) != 13 || branch_with_metadata(1) != 72
        || branch_metadata_record[0] == 0 || branch_metadata_record[1] == 0;
}
