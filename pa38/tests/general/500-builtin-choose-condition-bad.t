int select_value(int condition)
{
    return __builtin_choose_expr(condition, 1, 2);
}
