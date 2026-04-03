#include <stdio.h>
#include <float.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include <mulle-sprintf/mulle-sprintf.h>

int ACCURACY=8;


union fu
{
   float     f;
   uint32_t  u;
};


static void   print_column( union fu v, char *name)
{
   auto char   buf[ 64];
   auto char   out[ 128];
   union fu    check;
   int         len;

   len = mulle_sprintf( out, "0x%08lx : %0.*g", (unsigned long) v.u, ACCURACY, v.f);
   if( name)
      len += mulle_sprintf( &out[ len], " (%s)", name);

   mulle_sprintf( buf, "%0.*g", ACCURACY, v.f);
   check.f = strtod( buf, NULL);
   if( check.f != v.f && ! (isnan( check.f) && isnan( v.f)))
      len += mulle_sprintf( &out[ len], " ***FAIL*** (%s -> 0x%08lx : %0.8g)",
                     buf, (unsigned long) check.u, check.f);
   mulle_sprintf( &out[ len], "\n");
   fputs( out, stdout);
}


static inline void   pf( float d)
{
   union fu  v;

   v.f = d;
   print_column( v, NULL);
}


static inline void   pfn( float d, char *name)
{
   union fu  v;

   v.f = d;
   print_column( v, name);
}

static inline void   pu( uint64_t u)
{
   union fu  v;

   v.u = u;
   print_column( v, NULL);
}


int   main( int argc, char *argv[])
{
   union fu   v;

   if( argc == 2)
      ACCURACY = atoi( argv[ 1]);

   pfn( FLT_MIN, "FLT_MIN");
   pfn( -FLT_MIN, "-FLT_MIN");
   pfn( FLT_MAX, "FLT_MAX");
   pfn( -FLT_MAX, "-FLT_MAX");
   pfn( INFINITY, "INFINITY");
   pfn( -INFINITY, "-INFINITY");
   pfn( NAN, "NAN");
   pfn( -NAN, "-NAN");

   pf( 0);
   pf( 1);
   pf( 1.9999998);
   pf( 1.9999999);
   pf( 2);
   pf( 2.0000001L);
   pf( 2.0000002L);
   pf( -1);
   pf( -2);

   return( 0);
}

