#include <time.h>
#include "ptoc.h"

void timestamp(integer* day,  integer* month, integer* year, 
	       integer* hour, integer* min,   integer* sec)
{
    time_t ctime; 
    struct tm* tmp;

    time(&ctime);
    tmp = localtime(&ctime);

    *day = tmp->tm_mday; 
    *month = tmp->tm_mon + 1;
    *year = 1900 + tmp->tm_year; 
    *hour = tmp->tm_hour;
    *min = tmp->tm_min;
    *sec = tmp->tm_sec;
}

real get_realtime() 
{
    time_t ctime; 
    struct tm* tmp;

    time(&ctime);
    tmp = localtime(&ctime);

    return (real)tmp->tm_hour + (real)tmp->tm_min / 60.0; 
}

integer round(real x) 
{
    return x >= 0 ? trunc(x + 0.5) : trunc(x - 0.5); 
}

#define CIRCULAR_BUFFER_SIZE  4096

char* lpsz(int low, int high, const char* str) 
{ 
    static char buffer[CIRCULAR_BUFFER_SIZE];
    static int pos = 0;
    int  size = high - low + 1;
    char *ptr;

    if (pos + size >= sizeof(buffer)) pos = 0;
    ptr = &buffer[pos];
    pos += size + 1;
    memcpy(ptr, str, size);
    ptr[size] = '\0';
    return ptr;
}


