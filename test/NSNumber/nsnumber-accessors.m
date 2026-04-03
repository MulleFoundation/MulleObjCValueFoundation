#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <limits.h>
#include <stdint.h>

int   main( void)
{
   @autoreleasepool
   {
      NSNumber  *n;

      // char
      n = [NSNumber numberWithChar:(char)-1];
      mulle_printf( "char -1 charValue: %d\n", (int)[n charValue]);
      mulle_printf( "char -1 intValue: %d\n", [n intValue]);
      mulle_printf( "char -1 boolValue: %d\n", (int)[n boolValue]);

      // unsigned char
      n = [NSNumber numberWithUnsignedChar:(unsigned char)200];
      mulle_printf( "uchar 200 unsignedCharValue: %u\n", (unsigned)[n unsignedCharValue]);
      mulle_printf( "uchar 200 intValue: %d\n", [n intValue]);

      // short
      n = [NSNumber numberWithShort:(short)-1000];
      mulle_printf( "short -1000 shortValue: %d\n", (int)[n shortValue]);
      mulle_printf( "short -1000 intValue: %d\n", [n intValue]);

      // unsigned short
      n = [NSNumber numberWithUnsignedShort:(unsigned short)60000];
      mulle_printf( "ushort 60000 unsignedShortValue: %u\n", (unsigned)[n unsignedShortValue]);

      // int (small, uses tagged pointer)
      n = [NSNumber numberWithInt:42];
      mulle_printf( "int 42 intValue: %d\n", [n intValue]);
      mulle_printf( "int 42 shortValue: %d\n", (int)[n shortValue]);
      mulle_printf( "int 42 charValue: %d\n", (int)[n charValue]);
      mulle_printf( "int 42 longValue: %ld\n", [n longValue]);
      mulle_printf( "int 42 floatValue approx: %s\n", [n floatValue] > 41.0f ? "yes" : "no");
      mulle_printf( "int 42 doubleValue approx: %s\n", [n doubleValue] > 41.0 ? "yes" : "no");
      mulle_printf( "int 42 boolValue: %d\n", (int)[n boolValue]);
      mulle_printf( "int 42 unsignedIntValue: %u\n", [n unsignedIntValue]);
      mulle_printf( "int 42 unsignedLongValue: %lu\n", [n unsignedLongValue]);
      mulle_printf( "int 42 integerValue: %ld\n", (long)[n integerValue]);
      mulle_printf( "int 42 unsignedIntegerValue: %lu\n", (unsigned long)[n unsignedIntegerValue]);
      mulle_printf( "int 42 longLongValue: %lld\n", [n longLongValue]);
      mulle_printf( "int 42 unsignedLongLongValue: %llu\n", [n unsignedLongLongValue]);

      // unsigned int (small)
      n = [NSNumber numberWithUnsignedInt:100];
      mulle_printf( "uint 100 unsignedIntValue: %u\n", [n unsignedIntValue]);
      mulle_printf( "uint 100 intValue: %d\n", [n intValue]);

      // long (small)
      n = [NSNumber numberWithLong:1000L];
      mulle_printf( "long 1000 longValue: %ld\n", [n longValue]);

      // unsigned long (small)
      n = [NSNumber numberWithUnsignedLong:999UL];
      mulle_printf( "ulong 999 unsignedLongValue: %lu\n", [n unsignedLongValue]);

      // NSInteger
      n = [NSNumber numberWithInteger:(NSInteger)77];
      mulle_printf( "integer 77 integerValue: %ld\n", (long)[n integerValue]);

      // NSUInteger
      n = [NSNumber numberWithUnsignedInteger:(NSUInteger)88];
      mulle_printf( "uinteger 88 unsignedIntegerValue: %lu\n", (unsigned long)[n unsignedIntegerValue]);

      // long long (small)
      n = [NSNumber numberWithLongLong:(long long)55];
      mulle_printf( "ll 55 longLongValue: %lld\n", [n longLongValue]);

      // unsigned long long (small)
      n = [NSNumber numberWithUnsignedLongLong:(unsigned long long)66];
      mulle_printf( "ull 66 unsignedLongLongValue: %llu\n", [n unsignedLongLongValue]);

      // bool
      n = [NSNumber numberWithBool:YES];
      mulle_printf( "bool YES boolValue: %d\n", (int)[n boolValue]);
      mulle_printf( "bool YES intValue: %d\n", [n intValue]);
      n = [NSNumber numberWithBool:NO];
      mulle_printf( "bool NO boolValue: %d\n", (int)[n boolValue]);

      // int zero
      n = [NSNumber numberWithInt:0];
      mulle_printf( "int 0 boolValue: %d\n", (int)[n boolValue]);

      // initWithBytes: with int32 type
      {
         int32_t  val = 12345;
         n = [[[NSNumber alloc] initWithBytes:&val objCType:@encode(int32_t)] autorelease];
         mulle_printf( "initWithBytes int32 intValue: %d\n", [n intValue]);
      }

      // initWithBytes: with double type
      {
         double  val = 2.718;
         n = [[[NSNumber alloc] initWithBytes:&val objCType:@encode(double)] autorelease];
         mulle_printf( "initWithBytes double approx: %s\n", [n doubleValue] > 2.7 ? "yes" : "no");
      }

      // isEqual: with non-NSNumber
      n = [NSNumber numberWithInt:1];
      mulle_printf( "isEqual nil: %d\n", (int)[n isEqual:nil]);
      mulle_printf( "isEqual string: %d\n", (int)[n isEqual:@"1"]);

      // compare: cross type (tagged int vs tagged int)
      {
         NSNumber  *a = [NSNumber numberWithInt:10];
         NSNumber  *b = [NSNumber numberWithInt:20];
         mulle_printf( "compare 10 vs 20: %s\n",
            [a compare:b] == NSOrderedAscending ? "ascending" : "not-ascending");
         mulle_printf( "compare 20 vs 10: %s\n",
            [b compare:a] == NSOrderedDescending ? "descending" : "not-descending");
         mulle_printf( "compare 10 vs 10: %s\n",
            [a compare:[NSNumber numberWithInt:10]] == NSOrderedSame ? "same" : "not-same");
      }

      // objCType on small numbers
      n = [NSNumber numberWithInt:1];
      mulle_printf( "small int objCType: %s\n", [n objCType]);
   }
   return( 0);
}
