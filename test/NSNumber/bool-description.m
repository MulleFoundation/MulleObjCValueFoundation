#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int   main( void)
{
   NSNumber   *value;
   NSString   *s;

   value = [NSNumber numberWithBool:YES];
   s     = [value description];
   printf( "%s\n", [s UTF8String]);

   value = [NSNumber numberWithBool:NO];
   s     = [value description];
   printf( "%s\n", [s UTF8String]);

   return( 0);
}
