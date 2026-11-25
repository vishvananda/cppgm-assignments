static int host_pointer_value = 41;
static int host_function_value = 67;

int *selected_pointer = &host_pointer_value;

int *selected_function(void)
{
    return &host_function_value;
}
