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
      NSNumber   *nr;
      int        failures = 0;

      //
      // numberWithBool:
      //
      nr = [NSNumber numberWithBool:YES];
      mulle_printf( "bool YES  : boolValue=%d intValue=%d objCType=%s\n",
                   (int) [nr boolValue],
                   [nr intValue],
                   [nr objCType]);

      nr = [NSNumber numberWithBool:NO];
      mulle_printf( "bool NO   : boolValue=%d intValue=%d objCType=%s\n",
                   (int) [nr boolValue],
                   [nr intValue],
                   [nr objCType]);

      //
      // numberWithChar:
      //
      nr = [NSNumber numberWithChar:(char) 127];
      mulle_printf( "char 127  : charValue=%d intValue=%d longValue=%ld longLongValue=%lld doubleValue=%g\n",
                   (int) [nr charValue],
                   [nr intValue],
                   [nr longValue],
                   [nr longLongValue],
                   [nr doubleValue]);

      nr = [NSNumber numberWithChar:(char) -1];
      mulle_printf( "char -1   : charValue=%d intValue=%d\n",
                   (int) [nr charValue],
                   [nr intValue]);

      //
      // numberWithShort:
      //
      nr = [NSNumber numberWithShort:(short) 32767];
      mulle_printf( "short max : shortValue=%d intValue=%d\n",
                   (int) [nr shortValue],
                   [nr intValue]);

      nr = [NSNumber numberWithShort:(short) -32768];
      mulle_printf( "short min : shortValue=%d intValue=%d\n",
                   (int) [nr shortValue],
                   [nr intValue]);

      //
      // numberWithInt: with large values (forces _MulleObjCInt32Number)
      //
      nr = [NSNumber numberWithInt:INT32_MAX];
      mulle_printf( "int32 max : intValue=%d longValue=%ld longLongValue=%lld doubleValue=%g boolValue=%d objCType=%s\n",
                   [nr intValue],
                   [nr longValue],
                   [nr longLongValue],
                   [nr doubleValue],
                   (int) [nr boolValue],
                   [nr objCType]);

      nr = [NSNumber numberWithInt:INT32_MIN];
      mulle_printf( "int32 min : intValue=%d longValue=%ld longLongValue=%lld doubleValue=%g\n",
                   [nr intValue],
                   [nr longValue],
                   [nr longLongValue],
                   [nr doubleValue]);

      if( [nr intValue] != INT32_MIN)
      {
         mulle_fprintf( stderr, "fail: INT32_MIN roundtrip\n");
         failures++;
      }

      //
      // numberWithLong:
      //
      nr = [NSNumber numberWithLong:(long) INT32_MAX];
      mulle_printf( "long max  : longValue=%ld intValue=%d\n",
                   [nr longValue],
                   [nr intValue]);

      //
      // numberWithLongLong: with value > INT32_MAX (forces _MulleObjCInt64Number)
      //
      nr = [NSNumber numberWithLongLong:(long long) INT32_MAX + 1LL];
      mulle_printf( "llong big : longLongValue=%lld intValue=%d charValue=%d unsignedIntValue=%u objCType=%s\n",
                   [nr longLongValue],
                   [nr intValue],
                   (int) [nr charValue],
                   [nr unsignedIntValue],
                   [nr objCType]);

      nr = [NSNumber numberWithLongLong:(long long) INT64_MIN];
      mulle_printf( "llong min : longLongValue=%lld boolValue=%d\n",
                   [nr longLongValue],
                   (int) [nr boolValue]);

      //
      // numberWithUnsignedChar:
      //
      nr = [NSNumber numberWithUnsignedChar:(unsigned char) 255];
      mulle_printf( "uchar 255 : unsignedCharValue=%u intValue=%d\n",
                   (unsigned) [nr unsignedCharValue],
                   [nr intValue]);

      //
      // numberWithUnsignedShort:
      //
      nr = [NSNumber numberWithUnsignedShort:(unsigned short) 65535];
      mulle_printf( "ushort max: unsignedShortValue=%u intValue=%d\n",
                   (unsigned) [nr unsignedShortValue],
                   [nr intValue]);

      //
      // numberWithUnsignedInt: UINT32_MAX forces _MulleObjCUInt32Number
      //
      nr = [NSNumber numberWithUnsignedInt:(unsigned int) UINT32_MAX];
      mulle_printf( "uint max  : unsignedIntValue=%u unsignedLongValue=%lu unsignedLongLongValue=%llu doubleValue=%g objCType=%s\n",
                   [nr unsignedIntValue],
                   [nr unsignedLongValue],
                   [nr unsignedLongLongValue],
                   [nr doubleValue],
                   [nr objCType]);

      if( [nr unsignedIntValue] != UINT32_MAX)
      {
         mulle_fprintf( stderr, "fail: UINT32_MAX roundtrip\n");
         failures++;
      }

      //
      // numberWithUnsignedLong:
      //
      nr = [NSNumber numberWithUnsignedLong:(unsigned long) UINT32_MAX];
      mulle_printf( "ulong max : unsignedLongValue=%lu longLongValue=%lld\n",
                   [nr unsignedLongValue],
                   [nr longLongValue]);

      //
      // numberWithUnsignedLongLong: value > UINT32_MAX forces _MulleObjCUInt64Number
      //
      nr = [NSNumber numberWithUnsignedLongLong:(unsigned long long) UINT32_MAX + 1ULL];
      mulle_printf( "ullong big: unsignedLongLongValue=%llu longLongValue=%lld objCType=%s\n",
                   [nr unsignedLongLongValue],
                   [nr longLongValue],
                   [nr objCType]);

      nr = [NSNumber numberWithUnsignedLongLong:(unsigned long long) UINT64_MAX];
      mulle_printf( "ullong max: unsignedLongLongValue=%llu boolValue=%d\n",
                   [nr unsignedLongLongValue],
                   (int) [nr boolValue]);

      //
      // numberWithInteger: / numberWithUnsignedInteger:
      //
      nr = [NSNumber numberWithInteger:(NSInteger) INT32_MAX];
      mulle_printf( "integer   : integerValue=%ld\n", (long) [nr integerValue]);

      nr = [NSNumber numberWithUnsignedInteger:(NSUInteger) UINT32_MAX];
      mulle_printf( "uinteger  : unsignedIntegerValue=%lu\n", (unsigned long) [nr unsignedIntegerValue]);

      //
      // numberWithFloat: / numberWithDouble: / numberWithLongDouble:
      //
      nr = [NSNumber numberWithFloat:1.5f];
      mulle_printf( "float 1.5 : floatValue=%g doubleValue=%g objCType=%s\n",
                   (double) [nr floatValue],
                   [nr doubleValue],
                   [nr objCType]);

      nr = [NSNumber numberWithDouble:3.14];
      mulle_printf( "double pi : floatValue=%g doubleValue=%g objCType=%s\n",
                   (double) [nr floatValue],
                   [nr doubleValue],
                   [nr objCType]);



      //
      // unsigned accessor methods on _MulleObjCInt32Number
      //
      nr = [NSNumber numberWithInt:INT32_MAX];
      mulle_printf( "int32 unsigned accessors: "
                   "unsignedCharValue=%u unsignedShortValue=%u unsignedIntValue=%u "
                   "unsignedLongValue=%lu unsignedIntegerValue=%lu unsignedLongLongValue=%llu\n",
                   (unsigned) [nr unsignedCharValue],
                   (unsigned) [nr unsignedShortValue],
                   [nr unsignedIntValue],
                   [nr unsignedLongValue],
                   (unsigned long) [nr unsignedIntegerValue],
                   [nr unsignedLongLongValue]);

      //
      // signed accessor methods on _MulleObjCUInt32Number
      //
      nr = [NSNumber numberWithUnsignedInt:(unsigned int) UINT32_MAX];
      mulle_printf( "uint32 signed accessors: "
                   "charValue=%d shortValue=%d intValue=%d longValue=%ld integerValue=%ld longLongValue=%lld\n",
                   (int) [nr charValue],
                   (int) [nr shortValue],
                   [nr intValue],
                   [nr longValue],
                   (long) [nr integerValue],
                   [nr longLongValue]);

      //
      // initWithBool: directly
      //
      nr = [[NSNumber alloc] initWithBool:YES];
      mulle_printf( "initWithBool YES: boolValue=%d\n", (int) [nr boolValue]);
      [nr autorelease];

      nr = [[NSNumber alloc] initWithBool:NO];
      mulle_printf( "initWithBool NO: boolValue=%d\n", (int) [nr boolValue]);
      [nr autorelease];

      //
      // isEqual: cross-type
      //
      NSNumber   *a = [NSNumber numberWithInt:42];
      NSNumber   *b = [NSNumber numberWithDouble:42.0];
      mulle_printf( "isEqual int(42) double(42.0): %s\n",
                   [a isEqual:b] ? "YES" : "NO");

      a = [NSNumber numberWithInt:INT32_MAX];
      b = [NSNumber numberWithLongLong:(long long) INT32_MAX];
      mulle_printf( "isEqual int32max llong(int32max): %s\n",
                   [a isEqual:b] ? "YES" : "NO");

      return( failures);
   }
}
