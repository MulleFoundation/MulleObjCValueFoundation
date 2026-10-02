#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <limits.h>
#include <float.h>
#include <math.h>
#include <string.h>

#include <mulle-utf/mulle-ascii.h>
#import <MulleObjCValueFoundation/NSNumber-Private.h>

#ifndef M_PI
#define M_PI (3.14159265358979323846264338327950288)
#endif /* M_PI */


static double  values[] =
{
   -INFINITY,
   DBL_MIN,
   -M_PI,
   -1.0,
    -1.0/ 3,
    0,
    1,
    1.0/ 3,
   M_PI,
   DBL_MAX,
   INFINITY,
   NAN
};

#define sizeof_array( array) ( sizeof( array) / sizeof( array[ 0]))


//
// exercise the private conversion used by plist/JSON printers, not just
// -stringValue which takes the NSNumberStringValue path
//
static double   convertToASCII( NSNumber *nr, BOOL *ok)
{
   char                     buf[ 65];
   char                     tmp[ 64];
   struct mulle_asciidata   data;

   data = mulle_asciidata_make( tmp, sizeof( tmp));
   [nr _mulleConvertToASCIICharacters:&data];
   if( ! data.length)
   {
      *ok = NO;
      return( 0.0);
   }

   memcpy( buf, data.characters, data.length);
   buf[ data.length] = 0;
   *ok = YES;
   return( strtod( buf, NULL));
}


int   main( void)
{
   NSNumber    *nr;
   NSString    *s;
   NSInteger   i;
   double      value;
   double      converted;
   BOOL        ok;

   for( i = 0; i < sizeof_array( values); i++)
   {
      value      = values[ i];
      nr         = [NSNumber numberWithDouble:value];
      s          = [nr stringValue];
      converted  = [s doubleValue];
      if( value != converted && ! (isnan( value) && isnan( converted)))
      {
         mulle_fprintf( stderr, "fail: %g -> %s -> %g\n", value, [s UTF8String], converted);
         return( 1);
      }

      converted  = convertToASCII( nr, &ok);
      if( ! ok || (value != converted && ! (isnan( value) && isnan( converted))))
      {
         mulle_fprintf( stderr, "ascii fail: %g -> %g\n", value, converted);
         return( 1);
      }
   }
   return( 0);
}
