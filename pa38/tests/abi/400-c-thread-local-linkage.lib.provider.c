_Thread_local int host_count = 11;
extern _Thread_local int course_count;

int increment_from_host(void)
{
	return ++course_count;
}
