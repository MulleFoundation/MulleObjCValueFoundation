#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <stdint.h>
#include <string.h>


struct TestPoint
{
   int x;
   int y;
};


struct TestRect
{
   struct TestPoint origin;
   struct TestPoint size;
};


int   main( void)
{
   @autoreleasepool
   {
      NSValue      *v;
      NSValue      *v2;
      int          failures = 0;

      //
      // valueWithPointer: / pointerValue
      //
      void   *ptr = (void *) (uintptr_t) 0x12345678;
      v = [NSValue valueWithPointer:ptr];
      mulle_printf( "pointer objCType : %s\n", [v objCType]);
      mulle_printf( "pointerValue match : %s\n",
                   [v pointerValue] == ptr ? "YES" : "NO");
      if( [v pointerValue] != ptr)
      {
         mulle_fprintf( stderr, "fail: pointerValue roundtrip\n");
         failures++;
      }

      //
      // valueWithRange: / rangeValue
      //
      NSRange   range = NSMakeRange( 5, 10);
      v = [NSValue valueWithRange:range];
      mulle_printf( "range objCType : %s\n", [v objCType]);
      NSRange   out_range = [v rangeValue];
      mulle_printf( "rangeValue location=%lu length=%lu\n",
                   (unsigned long) out_range.location,
                   (unsigned long) out_range.length);
      if( out_range.location != 5 || out_range.length != 10)
      {
         mulle_fprintf( stderr, "fail: rangeValue roundtrip\n");
         failures++;
      }

      //
      // valueWithNonretainedObject: / nonretainedObjectValue
      //
      NSString   *s = @"hello";
      v = [NSValue valueWithNonretainedObject:s];
      mulle_printf( "nonretained objCType : %s\n", [v objCType]);
      id   recovered = [v nonretainedObjectValue];
      mulle_printf( "nonretainedObjectValue match : %s\n",
                   recovered == s ? "YES" : "NO");
      if( recovered != s)
      {
         mulle_fprintf( stderr, "fail: nonretainedObjectValue roundtrip\n");
         failures++;
      }

      //
      // valueWithBytes:objCType: with struct / getValue:
      //
      struct TestPoint   pt  = { 3, 7 };
      struct TestPoint   pt2 = { 0, 0 };
      v = [NSValue valueWithBytes:&pt
                         objCType:@encode( struct TestPoint)];
      mulle_printf( "struct objCType : %s\n", [v objCType]);
      [v getValue:&pt2];
      mulle_printf( "getValue x=%d y=%d\n", pt2.x, pt2.y);
      if( pt2.x != 3 || pt2.y != 7)
      {
         mulle_fprintf( stderr, "fail: getValue struct roundtrip\n");
         failures++;
      }

      //
      // value:withObjCType: (alternate factory)
      //
      struct TestRect   rect     = { { 1, 2 }, { 100, 200 } };
      struct TestRect   rect_out = { { 0, 0 }, { 0, 0 } };
      v = [NSValue value:&rect
            withObjCType:@encode( struct TestRect)];
      [v getValue:&rect_out];
      mulle_printf( "rect getValue origin=(%d,%d) size=(%d,%d)\n",
                   rect_out.origin.x, rect_out.origin.y,
                   rect_out.size.x,   rect_out.size.y);
      if( rect_out.origin.x != 1 || rect_out.size.y != 200)
      {
         mulle_fprintf( stderr, "fail: getValue rect roundtrip\n");
         failures++;
      }

      //
      // isEqualToValue: same type, same value
      //
      NSRange   range2 = NSMakeRange( 5, 10);
      v  = [NSValue valueWithRange:range];
      v2 = [NSValue valueWithRange:range2];
      mulle_printf( "isEqualToValue same range : %s\n",
                   [v isEqualToValue:v2] ? "YES" : "NO");
      if( ! [v isEqualToValue:v2])
      {
         mulle_fprintf( stderr, "fail: isEqualToValue same range\n");
         failures++;
      }

      //
      // isEqualToValue: same type, different value
      //
      NSRange   range3 = NSMakeRange( 1, 2);
      v2 = [NSValue valueWithRange:range3];
      mulle_printf( "isEqualToValue diff range : %s\n",
                   [v isEqualToValue:v2] ? "YES" : "NO");
      if( [v isEqualToValue:v2])
      {
         mulle_fprintf( stderr, "fail: isEqualToValue diff range should be NO\n");
         failures++;
      }

      //
      // isEqual: dispatch
      //
      v  = [NSValue valueWithPointer:ptr];
      v2 = [NSValue valueWithPointer:ptr];
      mulle_printf( "isEqual same pointer : %s\n",
                   [v isEqual:v2] ? "YES" : "NO");
      if( ! [v isEqual:v2])
      {
         mulle_fprintf( stderr, "fail: isEqual same pointer\n");
         failures++;
      }

      //
      // hash — just verify it doesn't crash and returns something
      //
      NSUInteger   h = [v hash];
      mulle_printf( "hash != 0 : %s\n", h != 0 ? "YES" : "NO");

      //
      // _size — called indirectly via getValue:size:
      //
      int   int_val  = 42;
      int   int_out  = 0;
      v = [NSValue valueWithBytes:&int_val
                         objCType:@encode( int)];
      [v getValue:&int_out
             size:sizeof( int)];
      mulle_printf( "getValue:size: int=%d\n", int_out);
      if( int_out != 42)
      {
         mulle_fprintf( stderr, "fail: getValue:size: int\n");
         failures++;
      }

      return( failures);
   }
}
