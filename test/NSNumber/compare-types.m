#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <limits.h>
#include <stdint.h>


static char   *comparison_string( NSComparisonResult r)
{
   if( r < 0)
      return( "<");
   if( r > 0)
      return( ">");
   return( "=");
}


int   main( void)
{
   @autoreleasepool
   {
      NSNumber             *a;
      NSNumber             *b;
      NSComparisonResult   result;
      int                  failures = 0;

      //
      // int32 vs int32 (large values, not tagged pointer range)
      //
      a = [NSNumber numberWithInt:INT32_MAX];
      b = [NSNumber numberWithInt:INT32_MAX];
      result = [a compare:b];
      mulle_printf( "int32(%d) compare int32(%d) : %s\n",
                   [a intValue], [b intValue], comparison_string( result));
      if( result != NSOrderedSame) { mulle_fprintf( stderr, "fail: equal int32\n"); failures++; }

      a = [NSNumber numberWithInt:INT32_MIN];
      b = [NSNumber numberWithInt:INT32_MAX];
      result = [a compare:b];
      mulle_printf( "int32(%d) compare int32(%d) : %s\n",
                   [a intValue], [b intValue], comparison_string( result));
      if( result != NSOrderedAscending) { mulle_fprintf( stderr, "fail: int32_min < int32_max\n"); failures++; }

      result = [b compare:a];
      mulle_printf( "int32(%d) compare int32(%d) : %s\n",
                   [b intValue], [a intValue], comparison_string( result));
      if( result != NSOrderedDescending) { mulle_fprintf( stderr, "fail: int32_max > int32_min\n"); failures++; }

      //
      // int64 vs int64
      //
      a = [NSNumber numberWithLongLong:(long long) INT32_MAX + 1LL];
      b = [NSNumber numberWithLongLong:(long long) INT32_MAX + 2LL];
      result = [a compare:b];
      mulle_printf( "int64(%lld) compare int64(%lld) : %s\n",
                   [a longLongValue], [b longLongValue], comparison_string( result));
      if( result != NSOrderedAscending) { mulle_fprintf( stderr, "fail: int64 ascending\n"); failures++; }

      a = [NSNumber numberWithLongLong:INT64_MIN];
      b = [NSNumber numberWithLongLong:INT64_MAX];
      result = [a compare:b];
      mulle_printf( "int64(min) compare int64(max) : %s\n", comparison_string( result));
      if( result != NSOrderedAscending) { mulle_fprintf( stderr, "fail: int64 min < max\n"); failures++; }

      a = [NSNumber numberWithLongLong:INT64_MAX];
      b = [NSNumber numberWithLongLong:INT64_MAX];
      result = [a compare:b];
      mulle_printf( "int64(max) compare int64(max) : %s\n", comparison_string( result));
      if( result != NSOrderedSame) { mulle_fprintf( stderr, "fail: int64 max == max\n"); failures++; }

      //
      // uint32 vs uint32 (UINT32_MAX forces _MulleObjCUInt32Number)
      //
      a = [NSNumber numberWithUnsignedInt:(unsigned int) UINT32_MAX];
      b = [NSNumber numberWithUnsignedInt:(unsigned int) UINT32_MAX];
      result = [a compare:b];
      mulle_printf( "uint32(max) compare uint32(max) : %s\n", comparison_string( result));
      if( result != NSOrderedSame) { mulle_fprintf( stderr, "fail: uint32 max == max\n"); failures++; }

      a = [NSNumber numberWithUnsignedInt:1000000000U];
      b = [NSNumber numberWithUnsignedInt:(unsigned int) UINT32_MAX];
      result = [a compare:b];
      mulle_printf( "uint32(1000000000) compare uint32(max) : %s\n", comparison_string( result));
      if( result != NSOrderedAscending) { mulle_fprintf( stderr, "fail: uint32 < max\n"); failures++; }

      //
      // float vs float
      //
      a = [NSNumber numberWithFloat:1.5f];
      b = [NSNumber numberWithFloat:2.5f];
      result = [a compare:b];
      mulle_printf( "float(1.5) compare float(2.5) : %s\n", comparison_string( result));
      if( result != NSOrderedAscending) { mulle_fprintf( stderr, "fail: float 1.5 < 2.5\n"); failures++; }

      a = [NSNumber numberWithFloat:3.0f];
      b = [NSNumber numberWithFloat:3.0f];
      result = [a compare:b];
      mulle_printf( "float(3.0) compare float(3.0) : %s\n", comparison_string( result));
      if( result != NSOrderedSame) { mulle_fprintf( stderr, "fail: float 3.0 == 3.0\n"); failures++; }

      //
      // double vs double
      //
      a = [NSNumber numberWithDouble:100.5];
      b = [NSNumber numberWithDouble:99.9];
      result = [a compare:b];
      mulle_printf( "double(100.5) compare double(99.9) : %s\n", comparison_string( result));
      if( result != NSOrderedDescending) { mulle_fprintf( stderr, "fail: double 100.5 > 99.9\n"); failures++; }

      a = [NSNumber numberWithDouble:-1.0];
      b = [NSNumber numberWithDouble:1.0];
      result = [a compare:b];
      mulle_printf( "double(-1.0) compare double(1.0) : %s\n", comparison_string( result));
      if( result != NSOrderedAscending) { mulle_fprintf( stderr, "fail: double -1 < 1\n"); failures++; }

      //
      // cross-type: int32 vs double
      //
      a = [NSNumber numberWithInt:INT32_MAX];
      b = [NSNumber numberWithDouble:(double) INT32_MAX];
      result = [a compare:b];
      mulle_printf( "int32(max) compare double(max) : %s\n", comparison_string( result));

      a = [NSNumber numberWithInt:INT32_MAX];
      b = [NSNumber numberWithDouble:1e20];
      result = [a compare:b];
      mulle_printf( "int32(max) compare double(1e20) : %s\n", comparison_string( result));
      if( result != NSOrderedAscending) { mulle_fprintf( stderr, "fail: int32max < 1e20\n"); failures++; }

      //
      // cross-type: int32 vs float
      //
      a = [NSNumber numberWithInt:INT32_MAX];
      b = [NSNumber numberWithFloat:1.0f];
      result = [a compare:b];
      mulle_printf( "int32(max) compare float(1.0) : %s\n", comparison_string( result));
      if( result != NSOrderedDescending) { mulle_fprintf( stderr, "fail: int32max > 1.0\n"); failures++; }

      //
      // isEqualToNumber: cross-type
      //
      a = [NSNumber numberWithInt:42];
      b = [NSNumber numberWithDouble:42.0];
      mulle_printf( "isEqualToNumber int(42) double(42.0) : %s\n",
                   [a isEqualToNumber:b] ? "YES" : "NO");

      a = [NSNumber numberWithInt:INT32_MAX];
      b = [NSNumber numberWithDouble:(double) INT32_MAX];
      mulle_printf( "isEqualToNumber int32(max) double(max) : %s\n",
                   [a isEqualToNumber:b] ? "YES" : "NO");

      a = [NSNumber numberWithInt:42];
      b = [NSNumber numberWithFloat:42.0f];
      mulle_printf( "isEqualToNumber int(42) float(42.0) : %s\n",
                   [a isEqualToNumber:b] ? "YES" : "NO");

      a = [NSNumber numberWithLongLong:(long long) INT32_MAX + 1LL];
      b = [NSNumber numberWithDouble:(double) ((long long) INT32_MAX + 1LL)];
      mulle_printf( "isEqualToNumber int64(int32max+1) double(int32max+1) : %s\n",
                   [a isEqualToNumber:b] ? "YES" : "NO");

      //
      // isEqual: on bool numbers
      //
      a = [NSNumber numberWithBool:YES];
      b = [NSNumber numberWithBool:YES];
      mulle_printf( "isEqual bool(YES) bool(YES) : %s\n",
                   [a isEqual:b] ? "YES" : "NO");

      a = [NSNumber numberWithBool:NO];
      b = [NSNumber numberWithInt:0];
      mulle_printf( "isEqualToNumber bool(NO) int(0) : %s\n",
                   [a isEqualToNumber:b] ? "YES" : "NO");

      return( failures);
   }
}
