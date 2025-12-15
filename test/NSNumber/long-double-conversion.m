#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


#ifdef _C_LNG_DBL

#include <limits.h>
#include <float.h>
#include <math.h>

#ifndef M_PI_LDBL
#define M_PI_LDBL (3.14159265358979323846264338327950288419716939937510582097494459230781640628620899L)
#endif /* M_PI */


static long double  values[] =
{
   -INFINITY,
   LDBL_MIN,
   -M_PI_LDBL,
   -1.0,
    -1.0/ 3,
    0,
    1,
    1.0/ 3,
   M_PI_LDBL,
   LDBL_MAX,
   INFINITY,
   NAN
};

#define sizeof_array( array) ( sizeof( array) / sizeof( array[ 0]))

#endif


int   main( void)
{
#ifdef _C_LNG_DBL
   NSNumber      *nr;
   NSString      *s;
   NSInteger     i;
   long double   value;
   long double   converted;
   union
   {
      unsigned char    bytes[ sizeof( long double)];
      long double      value;
   } v;

   for( i = 0; i < sizeof_array( values); i++)
   {
      value      = values[ i];
      nr         = [NSNumber numberWithLongDouble:value];
      s          = [nr stringValue];
      converted  = [s mulleLongDoubleValue];
      if( value != converted && ! (isnan( value) && isnan( converted)))
      {
         fprintf( stderr, "fail: %Lg -> %s -> %Lg\n", value, [s UTF8String], converted);
         return( 1);
      }
   }
#else
   printf( "_C_LNG_DBL not defined, no test for you!\n");
#endif
   return( 0);
}

