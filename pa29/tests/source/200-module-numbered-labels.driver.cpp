extern "C" int branch_over_section();
extern "C" int count_with_numbered_loop();
extern "C" void numbered_result();
extern "C" int numbered_forward;
extern "C" int numbered_backward;

int main()
{
    const long target = reinterpret_cast<long>(&numbered_result);
    return branch_over_section() != 39 || count_with_numbered_loop() != 21
        || numbered_forward != target - reinterpret_cast<long>(&numbered_forward)
        || numbered_backward != target - reinterpret_cast<long>(&numbered_backward);
}
