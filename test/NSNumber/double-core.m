#include <stdio.h>
#include <float.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>

// need 17 on linux to get back and forth conversion
int ACCURACY=17;


union dll
{
   double    d;
   uint64_t  ll;
};


static void   print_column( union dll v, char *name)
{
   auto char   buf[ 64];
   union dll   check;

   printf( "0x%016llx : %0.*g", (unsigned long long) v.ll, ACCURACY, v.d);
   if( name)
      printf( " (%s)", name);

   sprintf( buf, "%0.*g", ACCURACY, v.d);
   check.d = strtod( buf, NULL);
   if( check.d != v.d && ! (isnan( check.d) && isnan( v.d)))
      printf( " ***FAIL*** (%s -> 0x%016llx : %0.17g)",
                     buf, (unsigned long long) check.ll, check.d);
   printf( "\n");
}


static inline void   pd( double d)
{
   union dll  v;

   v.d = d;
   print_column( v, NULL);
}


static inline void   pdn( double d, char *name)
{
   union dll  v;

   v.d = d;
   print_column( v, name);
}

static inline void   pll( uint64_t ll)
{
   union dll  v;

   v.ll = ll;
   print_column( v, NULL);
}





int   main( int argc, char *argv[])
{
   union dll   v;

   if( argc == 2)
      ACCURACY = atoi( argv[ 1]);

   pdn( DBL_MIN, "DBL_MIN");
   pdn( -DBL_MIN, "-DBL_MIN");
   pdn( DBL_MAX, "DBL_MAX");
   pdn( -DBL_MAX, "-DBL_MAX");
   pdn( INFINITY, "INFINITY");
   pdn( -INFINITY, "-INFINITY");
   pdn( NAN, "NAN");
   pdn( -NAN, "-NAN");

   pd( 0);
   pd( 1);
   pd( 1.9999999999999998L);
   pd( 1.9999999999999999);
   pd( 2);
   pd( 2.0000000000000001L);
   pd( -1);
   pd( -2);

   return( 0);
}

