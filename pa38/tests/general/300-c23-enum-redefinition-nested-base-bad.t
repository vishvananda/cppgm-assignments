typedef __SIZE_TYPE__ size_type;
enum Fixed : typeof (sizeof (enum Fixed : size_type { value })) { value };
