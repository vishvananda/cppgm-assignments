#if __has_attribute(destructor) && __has_attribute(__destructor__)
shutdown_attribute_available
#else
shutdown_attribute_missing
#endif
