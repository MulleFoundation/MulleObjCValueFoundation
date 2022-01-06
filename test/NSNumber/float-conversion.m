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

int   main( void)
{
   NSNumber    *nr;
   NSString    *s;
   NSInteger   i;
   float       value;
   float       converted;

   for( i = 0; i < sizeof_array( values); i++)
   {
      value      = values[ i];
      nr         = [NSNumber numberWithFloat:value];
      s          = [nr stringValue];
      converted  = [s floatValue];
      if( value != converted && ! (isnan( value) && isnan( converted)))
      {
         fprintf( stderr, "fail: %g -> %s -> %g\n", value, [s UTF8String], converted);
         return( 1);
      }
   }
   return( 0);
}
