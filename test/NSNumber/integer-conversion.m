#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <limits.h>

static NSInteger  values[] =
{
   NSIntegerMin,
   -1.0,
   0,
   1,
   NSIntegerMax
};


#define sizeof_array( array) ( sizeof( array) / sizeof( array[ 0]))

int   main( void)
{
   NSNumber    *nr;
   NSString    *s;
   NSInteger   i;
   NSInteger   value;
   NSInteger   converted;

   for( i = 0; i < sizeof_array( values); i++)
   {
      value      = values[ i];
      nr         = [NSNumber numberWithInteger:value];
      s          = [nr stringValue];
      converted  = [s integerValue];
      if( value != converted)
      {
         fprintf( stderr, "fail: %ld -> %s -> %ld\n", (long) value, [s UTF8String], (long) converted);
         return( 1);
      }
   }
   return( 0);
}
