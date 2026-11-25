namespace std {
class type_info;
}

extern "C" int check_rtti(
    const std::type_info* plain, const std::type_info* pointer, const std::type_info* const_pointer);

extern "C" int observe() {
    return check_rtti(&typeid(void), &typeid(void*), &typeid(const void*));
}
