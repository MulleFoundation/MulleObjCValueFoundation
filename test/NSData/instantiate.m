#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int   main( void)
{
   NSData   *value;

   value = [[NSData instantiate] init];

   return( 0);
}
