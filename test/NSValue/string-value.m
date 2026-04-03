#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int   main( void)
{
   @autoreleasepool
   {
      NSValue   *v;
      NSValue   *rv;
      struct TestRect { int x; int y; int w; int h; };
      struct TestRect r = { 1, 2, 3, 4 };

      v = [NSValue valueWithRange:NSMakeRange( 3, 5)];
      mulle_printf( "range description: %s\n", [[v description] UTF8String]);

      rv = [NSValue valueWithBytes:&r objCType:@encode( struct TestRect)];
      mulle_printf( "rect description: %s\n", [[rv description] UTF8String]);
   }

   return( 0);
}
