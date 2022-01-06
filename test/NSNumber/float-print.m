#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <limits.h>
#include <float.h>
#include <math.h>

#ifndef M_PI
#define M_PI (3.14159265358979323846264338327950288)
#endif /* M_PI */


static float  values[] =
{
   -INFINITY,
   FLT_MIN,
   -M_PI,
   -18.48,
   -1.0,
    -1.0/ 3,
    0,
    1,
    1.0/ 3,
   18.48,
   M_PI,
   FLT_MAX,
   INFINITY,
   NAN
};

#define sizeof_array( array) ( sizeof( array) / sizeof( array[ 0]))

// more voodoo test code
int   main( void)
{
   NSNumber    *nr;
   NSNumber    *nr2;
   NSInteger   i;
   float       value;
   double      dvalue;

   for( i = 0; i < sizeof_array( values); i++)
   {
      value  = values[ i];
      dvalue = (double) value;
      nr     = [NSNumber numberWithFloat:value];
      nr2    = [NSNumber numberWithDouble:value];

      if( ([nr doubleValue] != value || [nr2 doubleValue] != value) && ! (isnan( value)))
      {
         fprintf( stderr, "value double fail: %g -> %g / %g\n", value, [nr doubleValue],  [nr2 doubleValue]);
         return( 1);
      }

      if( ([nr floatValue] != value || [nr2 floatValue] != value) && ! (isnan( value)))
      {
         fprintf( stderr, "value float fail: %g -> %g / %g\n", value, [nr floatValue],  [nr2 floatValue]);
         return( 1);
      }

      if( ([nr doubleValue] != dvalue || [nr2 doubleValue] != dvalue) && ! (isnan( dvalue)))
      {
         fprintf( stderr, "dvalue double fail: %g -> %g / %g\n", dvalue, [nr doubleValue],  [nr2 doubleValue]);
         return( 1);
      }

      if( ([nr floatValue] != dvalue || [nr2 floatValue] != dvalue) && ! (isnan( dvalue)))
      {
         fprintf( stderr, "dvalue float fail: %g -> %g / %g\n", dvalue, [nr floatValue],  [nr2 floatValue]);
         return( 1);
      }
   }
   return( 0);
}
