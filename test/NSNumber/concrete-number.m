#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <limits.h>
#include <stdint.h>
#include <math.h>


int   main( void)
{
   @autoreleasepool
   {
      NSNumber          *n32max;
      NSNumber          *n32min;
      NSNumber          *nu32max;
      NSNumber          *n64max;
      NSNumber          *n64min;
      NSNumber          *nu64big;
      NSNumber          *n32a;
      NSNumber          *n32b;
      NSComparisonResult result;

      //
      // INT32 concrete path (INT32_MAX forces concrete subclass)
      //
      n32max = [NSNumber numberWithInt:INT32_MAX];
      mulle_printf( "int32max intValue: %d\n", [n32max intValue]);
      mulle_printf( "int32max integerValue: %ld\n", (long) [n32max integerValue]);
      mulle_printf( "int32max longLongValue: %lld\n", [n32max longLongValue]);
      mulle_printf( "int32max unsignedLongLongValue: %llu\n", [n32max unsignedLongLongValue]);
      mulle_printf( "int32max doubleValue: %g\n", [n32max doubleValue]);
      mulle_printf( "int32max floatValue: %g\n", (double) [n32max floatValue]);
      mulle_printf( "int32max charValue: %d\n", (int) [n32max charValue]);
      mulle_printf( "int32max shortValue: %d\n", (int) [n32max shortValue]);
      mulle_printf( "int32max longValue: %ld\n", [n32max longValue]);
      mulle_printf( "int32max boolValue: %d\n", (int) [n32max boolValue]);
      mulle_printf( "int32max objCType: %s\n", [n32max objCType]);
      mulle_printf( "int32max hash nonzero: %s\n", [n32max hash] != 0 ? "yes" : "no");

      n32min = [NSNumber numberWithInt:INT32_MIN];
      mulle_printf( "int32min intValue: %d\n", [n32min intValue]);
      mulle_printf( "int32min longLongValue: %lld\n", [n32min longLongValue]);
      mulle_printf( "int32min doubleValue: %g\n", [n32min doubleValue]);
      mulle_printf( "int32min boolValue: %d\n", (int) [n32min boolValue]);
      mulle_printf( "int32min objCType: %s\n", [n32min objCType]);

      //
      // INT32 compare: tests
      //
      result = [n32max compare:n32min];
      mulle_printf( "int32max vs int32min: %s\n", result == NSOrderedDescending ? "descending" : "not-descending");

      result = [n32min compare:n32max];
      mulle_printf( "int32min vs int32max: %s\n", result == NSOrderedAscending ? "ascending" : "not-ascending");

      n32a = [NSNumber numberWithInt:INT32_MAX];
      result = [n32max compare:n32a];
      mulle_printf( "int32max vs int32max: %s\n", result == NSOrderedSame ? "same" : "not-same");

      mulle_printf( "int32max isEqual same: %s\n",
         [n32max isEqual:n32a] ? "yes" : "no");
      mulle_printf( "int32max isEqual diff: %s\n",
         [n32max isEqual:n32min] ? "yes" : "no");
      mulle_printf( "int32max isEqualToNumber same: %s\n",
         [n32max isEqualToNumber:n32a] ? "yes" : "no");
      mulle_printf( "int32max isEqualToNumber diff: %s\n",
         [n32max isEqualToNumber:n32min] ? "yes" : "no");

      //
      // UINT32 concrete path
      //
      nu32max = [NSNumber numberWithUnsignedInt:UINT32_MAX];
      mulle_printf( "uint32max intValue: %d\n", [nu32max intValue]);
      mulle_printf( "uint32max unsignedLongLongValue: %llu\n", [nu32max unsignedLongLongValue]);
      mulle_printf( "uint32max doubleValue: %g\n", [nu32max doubleValue]);
      mulle_printf( "uint32max boolValue: %d\n", (int) [nu32max boolValue]);
      mulle_printf( "uint32max objCType: %s\n", [nu32max objCType]);
      mulle_printf( "uint32max hash nonzero: %s\n", [nu32max hash] != 0 ? "yes" : "no");

      result = [nu32max compare:n32max];
      mulle_printf( "uint32max vs int32max: %s\n", result == NSOrderedDescending ? "descending" : "not-descending");

      //
      // INT64 concrete path
      //
      n64max = [NSNumber numberWithLongLong:INT64_MAX];
      mulle_printf( "int64max longLongValue: %lld\n", [n64max longLongValue]);
      mulle_printf( "int64max integerValue nonzero: %s\n", [n64max integerValue] != 0 ? "yes" : "no");
      mulle_printf( "int64max doubleValue: %g\n", [n64max doubleValue]);
      mulle_printf( "int64max floatValue: %g\n", (double) [n64max floatValue]);
      mulle_printf( "int64max boolValue: %d\n", (int) [n64max boolValue]);
      mulle_printf( "int64max objCType: %s\n", [n64max objCType]);
      mulle_printf( "int64max hash nonzero: %s\n", [n64max hash] != 0 ? "yes" : "no");

      n64min = [NSNumber numberWithLongLong:INT64_MIN];
      mulle_printf( "int64min longLongValue: %lld\n", [n64min longLongValue]);
      mulle_printf( "int64min objCType: %s\n", [n64min objCType]);

      result = [n64max compare:n64min];
      mulle_printf( "int64max vs int64min: %s\n", result == NSOrderedDescending ? "descending" : "not-descending");

      result = [n64min compare:n64max];
      mulle_printf( "int64min vs int64max: %s\n", result == NSOrderedAscending ? "ascending" : "not-ascending");

      n32b = [NSNumber numberWithLongLong:INT64_MAX];
      result = [n64max compare:n32b];
      mulle_printf( "int64max vs int64max copy: %s\n", result == NSOrderedSame ? "same" : "not-same");

      mulle_printf( "int64max isEqual same: %s\n",
         [n64max isEqual:n32b] ? "yes" : "no");
      mulle_printf( "int64max isEqual diff: %s\n",
         [n64max isEqual:n64min] ? "yes" : "no");

      //
      // UINT64 concrete path (large value > INT64_MAX)
      //
      nu64big = [NSNumber numberWithUnsignedLongLong:(uint64_t) UINT64_MAX];
      mulle_printf( "uint64max unsignedLongLongValue: %llu\n", [nu64big unsignedLongLongValue]);
      mulle_printf( "uint64max boolValue: %d\n", (int) [nu64big boolValue]);
      mulle_printf( "uint64max objCType: %s\n", [nu64big objCType]);
      mulle_printf( "uint64max hash nonzero: %s\n", [nu64big hash] != 0 ? "yes" : "no");

      //
      // Cross-type compare: int32 vs int64
      //
      n32a = [NSNumber numberWithInt:INT32_MAX];
      n64max = [NSNumber numberWithLongLong:INT64_MAX];
      result = [n64max compare:n32a];
      mulle_printf( "int64max vs int32max: %s\n", result == NSOrderedDescending ? "descending" : "not-descending");

      result = [n32a compare:n64max];
      mulle_printf( "int32max vs int64max: %s\n", result == NSOrderedAscending ? "ascending" : "not-ascending");

      //
      // stringValue tests (exercises _MulleObjCConcreteNumber+NSString)
      //
      n32max = [NSNumber numberWithInt:INT32_MAX];
      mulle_printf( "int32max stringValue: %s\n", [[n32max stringValue] UTF8String]);

      n32min = [NSNumber numberWithInt:INT32_MIN];
      mulle_printf( "int32min stringValue: %s\n", [[n32min stringValue] UTF8String]);

      nu32max = [NSNumber numberWithUnsignedInt:UINT32_MAX];
      mulle_printf( "uint32max stringValue: %s\n", [[nu32max stringValue] UTF8String]);

      n64max = [NSNumber numberWithLongLong:INT64_MAX];
      mulle_printf( "int64max stringValue: %s\n", [[n64max stringValue] UTF8String]);

      n64min = [NSNumber numberWithLongLong:INT64_MIN];
      mulle_printf( "int64min stringValue: %s\n", [[n64min stringValue] UTF8String]);

      nu64big = [NSNumber numberWithUnsignedLongLong:(uint64_t) UINT64_MAX];
      mulle_printf( "uint64max stringValue: %s\n", [[nu64big stringValue] UTF8String]);

      //
      // getValue: test
      //
      {
         int32_t   v32;
         [n32max getValue:&v32];
         mulle_printf( "int32max getValue: %d\n", v32);
      }
      {
         int64_t   v64;
         [n64max getValue:&v64];
         mulle_printf( "int64max getValue: %lld\n", v64);
      }
      {
         uint32_t  vu32;
         [nu32max getValue:&vu32];
         mulle_printf( "uint32max getValue: %u\n", (unsigned) vu32);
      }
      {
         uint64_t  vu64;
         [nu64big getValue:&vu64];
         mulle_printf( "uint64max getValue: %llu\n", vu64);
      }

      //
      // Bool number tests
      //
      {
         NSNumber  *bYES = [NSNumber numberWithBool:YES];
         NSNumber  *bNO  = [NSNumber numberWithBool:NO];

         mulle_printf( "boolYES boolValue: %d\n",  (int) [bYES boolValue]);
         mulle_printf( "boolYES intValue: %d\n",   [bYES intValue]);
         mulle_printf( "boolYES longLongValue: %lld\n", [bYES longLongValue]);
         mulle_printf( "boolYES charValue: %d\n",  (int) [bYES charValue]);
         mulle_printf( "boolYES doubleValue approx: %s\n",
            [bYES doubleValue] == 1.0 ? "yes" : "no");
         mulle_printf( "boolYES floatValue approx: %s\n",
            [bYES floatValue] == 1.0f ? "yes" : "no");
         mulle_printf( "boolYES objCType: %s\n",   [bYES objCType]);
         mulle_printf( "boolYES hash nonzero: %s\n", [bYES hash] != 0 ? "yes" : "no");
         mulle_printf( "boolYES __mulleIsBoolNumber: %d\n",
            (int) [bYES __mulleIsBoolNumber]);

         {
            char  gv;
            [bYES getValue:&gv];
            mulle_printf( "boolYES getValue: %d\n", (int) gv);
         }

         mulle_printf( "boolNO boolValue: %d\n",  (int) [bNO boolValue]);
         mulle_printf( "boolNO intValue: %d\n",   [bNO intValue]);
         mulle_printf( "boolNO longLongValue: %lld\n", [bNO longLongValue]);
         mulle_printf( "boolNO charValue: %d\n",  (int) [bNO charValue]);
         mulle_printf( "boolNO doubleValue zero: %s\n",
            [bNO doubleValue] == 0.0 ? "yes" : "no");
         mulle_printf( "boolNO floatValue zero: %s\n",
            [bNO floatValue] == 0.0f ? "yes" : "no");
         mulle_printf( "boolNO objCType: %s\n",   [bNO objCType]);
         mulle_printf( "boolNO __mulleIsBoolNumber: %d\n",
            (int) [bNO __mulleIsBoolNumber]);

         mulle_printf( "boolYES vs boolNO descending: %s\n",
            [bYES compare:bNO] == NSOrderedDescending ? "yes" : "no");
         mulle_printf( "boolNO vs boolYES ascending: %s\n",
            [bNO compare:bYES] == NSOrderedAscending ? "yes" : "no");
         mulle_printf( "boolYES isEqual boolYES: %s\n",
            [bYES isEqual:[NSNumber numberWithBool:YES]] ? "yes" : "no");
         mulle_printf( "boolYES isEqual boolNO: %s\n",
            [bYES isEqual:bNO] ? "yes" : "no");
         mulle_printf( "boolYES isEqualToNumber boolYES: %s\n",
            [bYES isEqualToNumber:[NSNumber numberWithBool:YES]] ? "yes" : "no");
         mulle_printf( "boolYES isEqualToNumber boolNO: %s\n",
            [bYES isEqualToNumber:bNO] ? "yes" : "no");
      }

      //
      // Float number tests
      //
      {
         NSNumber  *fPos = [NSNumber numberWithFloat:3.14f];
         NSNumber  *fNeg = [NSNumber numberWithFloat:-2.5f];
         NSNumber  *fNaN = [NSNumber numberWithFloat:NAN];
         float      fv;

         mulle_printf( "float3.14 floatValue in (3,3.2): %s\n",
            [fPos floatValue] > 3.0f && [fPos floatValue] < 3.2f ? "yes" : "no");
         mulle_printf( "float3.14 doubleValue in (3,3.2): %s\n",
            [fPos doubleValue] > 3.0 && [fPos doubleValue] < 3.2 ? "yes" : "no");
         mulle_printf( "float3.14 integerValue: %ld\n", (long) [fPos integerValue]);
         mulle_printf( "float3.14 longLongValue: %lld\n", [fPos longLongValue]);
         mulle_printf( "float3.14 unsignedLongLongValue: %llu\n", [fPos unsignedLongLongValue]);
         mulle_printf( "float3.14 unsignedIntegerValue: %lu\n",
            (unsigned long) [fPos unsignedIntegerValue]);
         mulle_printf( "float3.14 objCType: %s\n", [fPos objCType]);
         mulle_printf( "float3.14 hash nonzero: %s\n", [fPos hash] != 0 ? "yes" : "no");
         [fPos getValue:&fv];
         mulle_printf( "float3.14 getValue in (3,3.2): %s\n",
            fv > 3.0f && fv < 3.2f ? "yes" : "no");

         mulle_printf( "float-2.5 floatValue in (-2.6,-2.4): %s\n",
            [fNeg floatValue] > -2.6f && [fNeg floatValue] < -2.4f ? "yes" : "no");
         mulle_printf( "float-2.5 longLongValue: %lld\n", [fNeg longLongValue]);

         mulle_printf( "floatNaN objCType: %s\n", [fNaN objCType]);
      }

      //
      // Double number tests
      //
      {
         NSNumber  *dPos = [NSNumber numberWithDouble:3.14];
         NSNumber  *dNeg = [NSNumber numberWithDouble:-2.5];
         NSNumber  *dNaN = [NSNumber numberWithDouble:NAN];
         double     dv;

         mulle_printf( "double3.14 doubleValue in (3,3.2): %s\n",
            [dPos doubleValue] > 3.0 && [dPos doubleValue] < 3.2 ? "yes" : "no");
         mulle_printf( "double3.14 floatValue in (3,3.2): %s\n",
            [dPos floatValue] > 3.0f && [dPos floatValue] < 3.2f ? "yes" : "no");
         mulle_printf( "double3.14 longLongValue: %lld\n", [dPos longLongValue]);
         mulle_printf( "double3.14 integerValue: %ld\n", (long) [dPos integerValue]);
         mulle_printf( "double3.14 unsignedLongLongValue: %llu\n",
            [dPos unsignedLongLongValue]);
         mulle_printf( "double3.14 unsignedIntegerValue: %lu\n",
            (unsigned long) [dPos unsignedIntegerValue]);
         mulle_printf( "double3.14 objCType: %s\n", [dPos objCType]);
         mulle_printf( "double3.14 hash nonzero: %s\n", [dPos hash] != 0 ? "yes" : "no");
         [dPos getValue:&dv];
         mulle_printf( "double3.14 getValue in (3,3.2): %s\n",
            dv > 3.0 && dv < 3.2 ? "yes" : "no");

         mulle_printf( "double-2.5 doubleValue in (-2.6,-2.4): %s\n",
            [dNeg doubleValue] > -2.6 && [dNeg doubleValue] < -2.4 ? "yes" : "no");
         mulle_printf( "double-2.5 longLongValue: %lld\n", [dNeg longLongValue]);

         mulle_printf( "doubleNaN objCType: %s\n", [dNaN objCType]);
      }

      //
      // UINT32 unsigned accessor coverage
      //
      {
         NSNumber *u32 = [NSNumber numberWithUnsignedInt:UINT32_MAX];
         mulle_printf( "uint32max charValue: %d\n",          (int) [u32 charValue]);
         mulle_printf( "uint32max shortValue: %d\n",         (int) [u32 shortValue]);
         mulle_printf( "uint32max unsignedCharValue: %u\n",  (unsigned) [u32 unsignedCharValue]);
         mulle_printf( "uint32max unsignedShortValue: %u\n", (unsigned) [u32 unsignedShortValue]);
         mulle_printf( "uint32max unsignedIntValue: %u\n",   [u32 unsignedIntValue]);
         mulle_printf( "uint32max unsignedLongValue nonzero: %s\n", [u32 unsignedLongValue] != 0 ? "yes" : "no");
         mulle_printf( "uint32max unsignedIntegerValue nonzero: %s\n", [u32 unsignedIntegerValue] != 0 ? "yes" : "no");
         mulle_printf( "uint32max longValue nonzero: %s\n", [u32 longValue] != 0 ? "yes" : "no");
         mulle_printf( "uint32max integerValue nonzero: %s\n", (long) [u32 integerValue] != 0 ? "yes" : "no");
         mulle_printf( "uint32max boolValue: %d\n",          (int) [u32 boolValue]);
      }

      //
      // UINT64 unsigned accessor coverage
      //
      {
         NSNumber *u64 = [NSNumber numberWithUnsignedLongLong:(uint64_t) UINT64_MAX];
         mulle_printf( "uint64max charValue: %d\n",          (int) [u64 charValue]);
         mulle_printf( "uint64max shortValue: %d\n",         (int) [u64 shortValue]);
         mulle_printf( "uint64max unsignedCharValue: %u\n",  (unsigned) [u64 unsignedCharValue]);
         mulle_printf( "uint64max unsignedShortValue: %u\n", (unsigned) [u64 unsignedShortValue]);
         mulle_printf( "uint64max unsignedIntValue: %u\n",   [u64 unsignedIntValue]);
         mulle_printf( "uint64max unsignedLongValue nonzero: %s\n", [u64 unsignedLongValue] != 0 ? "yes" : "no");
         mulle_printf( "uint64max unsignedIntegerValue nonzero: %s\n", [u64 unsignedIntegerValue] != 0 ? "yes" : "no");
         mulle_printf( "uint64max longValue nonzero: %s\n", [u64 longValue] != 0 ? "yes" : "no");
         mulle_printf( "uint64max integerValue nonzero: %s\n", (long) [u64 integerValue] != 0 ? "yes" : "no");
         mulle_printf( "uint64max boolValue: %d\n",          (int) [u64 boolValue]);
      }

      //
      // INT32 unsigned accessor coverage
      //
      {
         NSNumber *i32 = [NSNumber numberWithInt:INT32_MAX];
         mulle_printf( "int32max unsignedCharValue: %u\n",   (unsigned) [i32 unsignedCharValue]);
         mulle_printf( "int32max unsignedShortValue: %u\n",  (unsigned) [i32 unsignedShortValue]);
         mulle_printf( "int32max unsignedIntValue: %u\n",    [i32 unsignedIntValue]);
         mulle_printf( "int32max unsignedLongValue nonzero: %s\n", [i32 unsignedLongValue] != 0 ? "yes" : "no");
         mulle_printf( "int32max unsignedIntegerValue nonzero: %s\n", [i32 unsignedIntegerValue] != 0 ? "yes" : "no");
      }

      //
      // INT64 unsigned accessor coverage
      //
      {
         NSNumber *i64 = [NSNumber numberWithLongLong:INT64_MAX];
         mulle_printf( "int64max unsignedCharValue: %u\n",   (unsigned) [i64 unsignedCharValue]);
         mulle_printf( "int64max unsignedShortValue: %u\n",  (unsigned) [i64 unsignedShortValue]);
         mulle_printf( "int64max unsignedIntValue: %u\n",    [i64 unsignedIntValue]);
      }
   }
   return( 0);
}
