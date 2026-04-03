#ifdef __MULLE_OBJC__
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif


int   main( void)
{
   @autoreleasepool
   {
      NSString   *s;
      Class      cls;
      SEL        sel;

      // NSClassFromString / NSStringFromClass
      cls = NSClassFromString( @"NSString");
      printf( "class: %s\n", cls ? "yes" : "no");

      s = NSStringFromClass( [NSString class]);
      printf( "class name: %s\n", [s UTF8String]);

      // NSSelectorFromString / NSStringFromSelector
      sel = NSSelectorFromString( @"length");
      printf( "selector: %s\n", sel ? "yes" : "no");

      s = NSStringFromSelector( @selector( length));
      printf( "selector name: %s\n", [s UTF8String]);

      // NSStringFromRange
      s = NSStringFromRange( NSMakeRange( 3, 5));
      printf( "range: %s\n", [s UTF8String]);

      // MulleObjCStringByCombiningPrefixAndCapitalizedKey
      s = MulleObjCStringByCombiningPrefixAndCapitalizedKey( @"set", @"name", YES);
      printf( "combined: %s\n", [s UTF8String]);

      s = MulleObjCStringByCombiningPrefixAndCapitalizedKey( @"get", @"value", NO);
      printf( "combined no colon: %s\n", [s UTF8String]);
   }
   return( 0);
}
