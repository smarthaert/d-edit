#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>

#include "nmtbl.h"
#include "token.h"
#include "trnod.h"
#include "util.h"


memory_allocator heap;

void error(const char* fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    fprintf(stderr, "error: ");
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    putc('\n',stderr);
    exit (EXIT_FAILURE);
}

void error(int line, int pos, const char* file, const char* fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    fprintf(stderr, "%s:%d %d error: ", file, line, pos);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    putc('\n',stderr);
    exit (EXIT_FAILURE);
}

void error(token* tkn, const char* fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);

    while(tkn->tag == TKN_GEN) tkn = tkn->next;

    fprintf(stderr, "%s:%d %d error: ", tkn->fname, tkn->line, tkn->pos );
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    putc('\n',stderr);
    exit (EXIT_FAILURE);
}

void warning(const char* fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    fprintf(stderr, "warning: ");
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    putc('\n',stderr);
}

void warning(int line, int pos, const char* file, const char* fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    fprintf(stderr, "%s:%d %d warning: ", file, line, pos);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    putc('\n',stderr);
}

void warning(token* tkn, const char* fmt, ...)
{
    va_list ap;

    while(tkn->tag == TKN_GEN) tkn = tkn->next;

    va_start(ap, fmt);
    fprintf(stderr, "%s:%d %d warning: ", tkn->fname, tkn->line, tkn->pos );
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    putc('\n',stderr);
}

extern "C" char* strdup(const char* s) 
{
    return strcpy((char*)heap.alloc(strlen(s)+1), s);
}

