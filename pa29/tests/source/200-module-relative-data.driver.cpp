extern "C" void entry_target();
extern "C" int entry_delta;
extern "C" short delta_size;
extern "C" int supplied_delta;
extern "C" void supplied_target() {}

int main()
{
    const long base = reinterpret_cast<long>(&entry_delta);
    return entry_delta != reinterpret_cast<long>(&entry_target) - base
        || delta_size != 4
        || supplied_delta != reinterpret_cast<long>(&supplied_target) - base + 16;
}
