#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <float.h>
#include <math.h>


// some harmless strings :)
static char  *strings[] =
{
   "12.2",
   "11.7",
   "11.0000007",
   "11.00000000000005",
   "11.000000000000005",
   "11.0000000000000005"
};


#define sizeof_array( array) ( sizeof( array) / sizeof( array[ 0]))


// On MacOS you can see, that the formatter messes up a valid value in C
//
// 12.2 -> 12.199999999999999 -> @12.2 |-> "12.2" -> 12.199999999999999 |-> "12.2" -> 12.199999999999999 || 12.2 -> 12.199999999999999 -> 12.199999999999999
// 11.7 -> 11.699999999999999 -> @11.7 |-> "11.7" -> 11.699999999999999 |-> "11.7" -> 11.699999999999999 || 11.7 -> 11.699999999999999 -> 11.699999999999999
// 11.0000007 -> 11.000000699999999 -> @11.0000007 |-> "11.0000007" -> 11.000000699999999 |-> "11.0000007" -> 11.000000699999999 || 11.0000007 -> 11.000000699999999 -> 11.000000699999999
// 11.00000000000005 -> 11.00000000000005 -> @11.00000000000005 |-> "11.00000000000005" -> 11.00000000000005 |-> "11.00000000000005" -> 11.00000000000005 || 11.00000000000005 -> 11.00000000000005 -> 11.00000000000005
// *** 11.000000000000005 -> 11.000000000000005 -> @11.00000000000001 |-> "11.00000000000001" -> 11.000000000000011 |-> "11.00000000000001" -> 11.000000000000011 || 11.000000000000005 -> 11.000000000000005 -> 11.000000000000011
// 11.0000000000000005 -> 11 -> @11 |-> "11" -> 11 |-> "11" -> 11 || 11.0000000000000005 -> 11 -> 11

int   main( void)
{
   NSNumber      *nr;
   NSString      *s2;
   NSString      *s3;
   double        v1;
   double        v2;
   double        v3;
   NSUInteger    i;
   char          buf[ 32];

   for( i = 0; i < sizeof_array( strings); i++)
   {
      if( i)
         printf( "\n");

      v1  = strtod( strings[ i], NULL);
      nr  = [NSNumber numberWithDouble:v1];

      s2  = [nr stringValue];
      v2  = [s2 doubleValue];
      s3  = [nr description];
      v3  = [s3 doubleValue];
      printf( "|objc|\"%s\"\n"
              "\t-> (double) %0.17g\n"
              "\t|-> (NSNumber *) @%s\n"
              "\t|-> (NSString *) @\"%s\" (-stringValue)\n"
              "\t|-> (double) %0.17g\n"
              "\t||-> (NSString *) @\"%s\" (-description)\n"
              "\t||-> (double) %0.17g\n",
                   strings[ i],
                   v1,
                   [[nr description] UTF8String],
                   [s2 UTF8String],
                   v2,
                   [s3 UTF8String],
                   v3);
   }
   return( 0);
}
