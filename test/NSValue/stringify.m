#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int   main( void)
{
   NSValue   *value;
   struct abcd { char a; int b; char c; double d; } x = { '1', 2, 3, 4 };

   value = [NSValue valueWithBytes:&x
                          objCType:@encode( struct abcd)];
   mulle_printf( "%@\n", value);

   return( 0);
}
