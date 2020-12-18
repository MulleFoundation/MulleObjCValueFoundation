#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int   main( void)
{
   NSNumber   *value;

   value = [[NSNumber alloc] initWithInt:1848];
   [value release];

   return( 0);
}
