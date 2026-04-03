#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

int   main( void)
{
   @autoreleasepool
   {
      NSMutableString  *ms;

      // initWithCapacity:
      ms = [[[NSMutableString alloc] initWithCapacity:32] autorelease];
      mulle_printf( "initWithCapacity empty length: %lu\n", (unsigned long)[ms length]);

      // appendString:
      [ms appendString:@"Hello"];
      mulle_printf( "after append Hello: %s\n", [ms UTF8String]);
      [ms appendString:@", World"];
      mulle_printf( "after append World: %s\n", [ms UTF8String]);

      // mulleAppendUTF8String:
      [ms mulleAppendUTF8String:" foo"];
      mulle_printf( "after mulleAppendUTF8: %s\n", [ms UTF8String]);

      // appendFormat:
      [ms appendFormat:@" %d", 42];
      mulle_printf( "after appendFormat: %s\n", [ms UTF8String]);

      // setString: resets content
      [ms setString:@"Reset"];
      mulle_printf( "after setString: %s\n", [ms UTF8String]);

      // replaceCharactersInRange:withString: (replace middle chars)
      [ms setString:@"Hello World"];
      [ms replaceCharactersInRange:NSMakeRange(6, 5)
                        withString:@"Mulle"];
      mulle_printf( "after replace World->Mulle: %s\n", [ms UTF8String]);

      // replaceCharactersInRange:withString: (insert at front — range len 0)
      [ms replaceCharactersInRange:NSMakeRange(0, 0)
                        withString:@"Say: "];
      mulle_printf( "after insert at front: %s\n", [ms UTF8String]);

      // deleteCharactersInRange:
      [ms setString:@"Hello World"];
      [ms deleteCharactersInRange:NSMakeRange(5, 6)];
      mulle_printf( "after delete ' World': %s\n", [ms UTF8String]);

      // substringWithRange:
      [ms setString:@"Hello World"];
      {
         NSString  *sub = [ms substringWithRange:NSMakeRange(6, 5)];
         mulle_printf( "substringWithRange(6,5): %s\n", [sub UTF8String]);
      }

      // mulleStringByRemovingPrefix:
      [ms setString:@"Hello World"];
      {
         NSString  *stripped = [ms mulleStringByRemovingPrefix:@"Hello "];
         mulle_printf( "removePrefix 'Hello ': %s\n", [stripped UTF8String]);
         // non-matching prefix returns self
         NSString  *unchanged = [ms mulleStringByRemovingPrefix:@"Foo"];
         mulle_printf( "removePrefix 'Foo' (no match): %s\n", [unchanged UTF8String]);
      }

      // mulleStringByRemovingSuffix:
      [ms setString:@"Hello World"];
      {
         NSString  *stripped = [ms mulleStringByRemovingSuffix:@" World"];
         mulle_printf( "removeSuffix ' World': %s\n", [stripped UTF8String]);
         NSString  *unchanged = [ms mulleStringByRemovingSuffix:@"Bar"];
         mulle_printf( "removeSuffix 'Bar' (no match): %s\n", [unchanged UTF8String]);
      }

      // mulleGetUTF8Characters:
      [ms setString:@"Test"];
      {
         char       buf[16];
         NSUInteger len;

         len = [ms mulleGetUTF8Characters:buf
                                maxLength:sizeof(buf) - 1];
         buf[len] = 0;
         mulle_printf( "mulleGetUTF8Characters: %s\n", buf);
      }

      // getCharacters:
      [ms setString:@"ABC"];
      {
         unichar  buf[4];
         [ms getCharacters:buf];
         mulle_printf( "getChars: %c%c%c\n", (char)buf[0], (char)buf[1], (char)buf[2]);
      }

      // mulleCompactedString
      [ms setString:@"Hello"];
      [ms appendString:@" World"];
      {
         NSString  *compacted = [ms mulleCompactedString];
         mulle_printf( "compacted: %s\n", [compacted UTF8String]);
      }

      // initWithStrings: (array of strings)
      {
         NSString  *parts[3];
         parts[0] = @"foo";
         parts[1] = @"bar";
         parts[2] = @"baz";
         NSMutableString  *ms2 = [[[NSMutableString alloc] initWithStrings:parts
                                                                     count:3] autorelease];
         mulle_printf( "initWithStrings 3: %s\n", [ms2 UTF8String]);
      }

      // initWithFormat:
      {
         NSMutableString  *ms3 = [[[NSMutableString alloc] initWithFormat:@"%d-%d", 1, 2] autorelease];
         mulle_printf( "initWithFormat: %s\n", [ms3 UTF8String]);
      }

      // mulleInitWithUTF8Characters:length:
      {
         char  buf[] = {'m','u','l','l','e'};
         NSMutableString  *ms4 = [[[NSMutableString alloc] mulleInitWithUTF8Characters:buf
                                                                                length:5] autorelease];
         mulle_printf( "mulleInitWithUTF8Chars: %s\n", [ms4 UTF8String]);
      }

      // stringByAppendingString: on mutable
      [ms setString:@"Hello"];
      {
         NSString  *result = [ms stringByAppendingString:@" World"];
         mulle_printf( "stringByAppendingString: %s\n", [result UTF8String]);
      }

      // copy of mutable string
      [ms setString:@"CopyMe"];
      {
         NSString  *immutable = [[ms copy] autorelease];
         mulle_printf( "copy immutable: %s\n", [immutable UTF8String]);
         mulle_printf( "copy isKindOfString: %d\n", (int)[immutable isKindOfClass:[NSString class]]);
      }
   }
   return( 0);
}
