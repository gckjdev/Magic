//
//  fopen_unix.c
//  Draw
//
//  Created by gckj on 14-9-23.
//
//
#include <stdio.h>

FILE *fopen$UNIX2003( const char *filename, const char *mode )
{
    return fopen(filename, mode);
}

size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d )
{
    return fwrite(a, b, c, d);
}