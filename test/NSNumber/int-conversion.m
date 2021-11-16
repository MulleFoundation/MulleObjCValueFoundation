#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <limits.h>

static int  values[] =
{
   INT_MIN,
   -1.0,
   0,
   1,
   INT_MAX
};


#define sizeof_array( array) ( sizeof( array) / sizeof( array[ 0]))

int   main( void)
{
   NSNumber    *nr;
   NSString    *s;
   NSInteger   i;
   int         value;
   int         converted;

   for( i = 0; i < sizeof_array( values); i++)
   {
      value      = values[ i];
      nr         = [NSNumber numberWithInt:value];
      s          = [nr stringValue];
      converted  = [s intValue];
      if( value != converted)
      {
         fprintf( stderr, "fail: %d -> %s -> %d\n", value, [s UTF8String], converted);
         return( 1);
      }
   }
   return( 0);
}
