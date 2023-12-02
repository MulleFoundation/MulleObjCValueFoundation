#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


static void    test( NSString *s)
{
   unichar   c;

   NSStringFor( s, c)
   {
      mulle_printf( "%.1lS", &c);
   }
   mulle_printf( "\n");
}


int   main( void)
{
   NSMutableString   *s;

   test( nil);
   test( @"");
   test( @"small");
   test( @"longer");
   test( @"VfL Bochum 1848");
   test( @"This is a very long string, that hopefully requires a second fetch from the NSString.");

   s = [NSMutableString string];
   [s appendString:@"This"];
   [s appendString:@" is an even longer string,"];
   [s appendString:@" that hopefully requires a second fetch from the NSString."];
   test( s);

   return( 0);
}
