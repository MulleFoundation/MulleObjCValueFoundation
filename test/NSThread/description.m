#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
# import <MulleObjC/NSDebug.h>
#endif

int   main( void)
{
   @autoreleasepool
   {
      NSThread  *thread;

      thread = [NSThread currentThread];

      // description — returns stringWithUTF8String:[self UTF8String]
      {
         NSString  *desc = [thread description];
         mulle_printf( "description isKindOfNSString: %d\n",
            (int)[desc isKindOfClass:[NSString class]]);
         mulle_printf( "description non-empty: %d\n",
            (int)([desc length] > 0));
      }

      // mulleTestDescription — same as description
      {
         NSString  *desc = [thread mulleTestDescription];
         mulle_printf( "mulleTestDescription isKindOfNSString: %d\n",
            (int)[desc isKindOfClass:[NSString class]]);
      }

      // debugDescription — format is <ClassName ptr "name">
      // Use MulleObjCDebugElideAddressOutput to suppress the pointer
      {
         MulleObjCDebugElideAddressOutput = YES;
         NSString  *dbg = [thread debugDescription];

         mulle_printf( "debugDescription non-empty: %d\n",
            (int)([dbg length] > 0));
         mulle_printf( "debugDescription is string: %d\n",
            (int)[dbg isKindOfClass:[NSString class]]);
      }

      // mulleDebugContentsDescription — returns nil
      {
         NSString  *contents = [thread mulleDebugContentsDescription];
         mulle_printf( "mulleDebugContentsDescription nil: %d\n",
            (int)(contents == nil));
      }
   }
   return( 0);
}
