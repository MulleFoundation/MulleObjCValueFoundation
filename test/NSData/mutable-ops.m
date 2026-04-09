#ifdef __MULLE_OBJC__
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

#include <string.h>

@interface NSData (Forward)
- (BOOL) __isNSData;
- (BOOL) __isNSMutableData;
@end

int   main( void)
{
   NSMutableData      *mdata;
   NSData             *idata;
   unsigned char      *bytes;
   struct mulle_data   cdata;
   NSRange             range;

   // dataWithCapacity / initWithCapacity
   mdata = [NSMutableData dataWithCapacity:64];
   printf( "capacity initial length: %lu\n", (unsigned long) [mdata length]);
   printf( "isNSMutableData: %d\n", (int) [mdata __isNSMutableData]);
   printf( "isNSData: %d\n", (int) [mdata __isNSData]);

   // dataWithLength / initWithLength - length is correct
   // Note: implementation uses MULLE_BUFFER_NO_ZEROFILL so content is unspecified
   mdata = [NSMutableData dataWithLength:8];
   printf( "dataWithLength:8 length: %lu\n", (unsigned long) [mdata length]);

   // mulleNonZeroedDataWithLength - length set but not zeroed
   mdata = [NSMutableData mulleNonZeroedDataWithLength:16];
   printf( "mulleNonZeroedDataWithLength:16 length: %lu\n", (unsigned long) [mdata length]);

   // appendBytes:length:
   mdata = [NSMutableData dataWithCapacity:0];
   {
      unsigned char src[ 4] = { 1, 2, 3, 4 };
      [mdata appendBytes:src length:4];
      printf( "append length: %lu\n", (unsigned long) [mdata length]);
      bytes = (unsigned char *) [mdata bytes];
      printf( "append[0]: %d\n", (int) bytes[ 0]);
      printf( "append[3]: %d\n", (int) bytes[ 3]);
   }

   // appendData:
   {
      unsigned char src2[ 3] = { 5, 6, 7 };
      NSData *extra = [NSData dataWithBytes:src2 length:3];
      [mdata appendData:extra];
      printf( "after appendData length: %lu\n", (unsigned long) [mdata length]);
      bytes = (unsigned char *) [mdata bytes];
      printf( "after appendData[4]: %d\n", (int) bytes[ 4]);
      printf( "after appendData[6]: %d\n", (int) bytes[ 6]);
   }

   // setLength: - shrink
   [mdata setLength:3];
   printf( "shrink length: %lu\n", (unsigned long) [mdata length]);
   bytes = (unsigned char *) [mdata bytes];
   printf( "shrink[0]: %d\n", (int) bytes[ 0]);
   printf( "shrink[2]: %d\n", (int) bytes[ 2]);

   // setLength: - grow (zero fills)
   [mdata setLength:6];
   printf( "grow length: %lu\n", (unsigned long) [mdata length]);
   bytes = (unsigned char *) [mdata bytes];
   printf( "grow[3] zeroed: %d\n", (int) (bytes[ 3] == 0));
   printf( "grow[5] zeroed: %d\n", (int) (bytes[ 5] == 0));

   // setLength: - zero length
   [mdata setLength:0];
   printf( "zero length: %lu\n", (unsigned long) [mdata length]);

   // increaseLengthBy:
   mdata = [NSMutableData dataWithLength:3];
   bytes = (unsigned char *) [mdata mutableBytes];
   bytes[0] = 0xAA;
   bytes[1] = 0xBB;
   bytes[2] = 0xCC;
   [mdata increaseLengthBy:2];
   printf( "increaseLengthBy length: %lu\n", (unsigned long) [mdata length]);
   bytes = (unsigned char *) [mdata mutableBytes];
   printf( "increaseLengthBy[0]: 0x%02x\n", (unsigned int) bytes[ 0]);
   printf( "increaseLengthBy[3] zeroed: %d\n", (int) (bytes[ 3] == 0));
   printf( "increaseLengthBy[4] zeroed: %d\n", (int) (bytes[ 4] == 0));

   // mutableBytes
   mdata = [NSMutableData dataWithLength:4];
   bytes = (unsigned char *) [mdata mutableBytes];
   bytes[0] = 42;
   bytes[3] = 99;
   printf( "mutableBytes[0]: %d\n", (int) bytes[ 0]);
   printf( "mutableBytes[3]: %d\n", (int) bytes[ 3]);

   // replaceBytesInRange:withBytes: (same length)
   {
      unsigned char orig[ 6] = { 1, 2, 3, 4, 5, 6 };
      unsigned char repl[ 2] = { 10, 20 };
      mdata = [NSMutableData dataWithBytes:orig length:6];
      range = NSMakeRange( 2, 2);
      [mdata replaceBytesInRange:range withBytes:repl];
      bytes = (unsigned char *) [mdata bytes];
      printf( "replace same: len=%lu [2]=%d [3]=%d\n",
              (unsigned long) [mdata length], (int) bytes[ 2], (int) bytes[ 3]);
   }

   // replaceBytesInRange:withBytes:length: - replace with shorter
   {
      unsigned char orig[ 6] = { 1, 2, 3, 4, 5, 6 };
      unsigned char repl[ 1] = { 99 };
      mdata = [NSMutableData dataWithBytes:orig length:6];
      range = NSMakeRange( 1, 3);
      [mdata replaceBytesInRange:range withBytes:repl length:1];
      bytes = (unsigned char *) [mdata bytes];
      printf( "replace shorter: len=%lu [0]=%d [1]=%d [2]=%d [3]=%d\n",
              (unsigned long) [mdata length],
              (int) bytes[ 0], (int) bytes[ 1], (int) bytes[ 2], (int) bytes[ 3]);
   }

   // replaceBytesInRange:withBytes:length: - replace with longer
   {
      unsigned char orig[ 4] = { 1, 2, 3, 4 };
      unsigned char repl[ 3] = { 10, 11, 12 };
      mdata = [NSMutableData dataWithBytes:orig length:4];
      range = NSMakeRange( 1, 1);
      [mdata replaceBytesInRange:range withBytes:repl length:3];
      bytes = (unsigned char *) [mdata bytes];
      printf( "replace longer: len=%lu [0]=%d [1]=%d [2]=%d [3]=%d [4]=%d [5]=%d\n",
              (unsigned long) [mdata length],
              (int) bytes[ 0], (int) bytes[ 1], (int) bytes[ 2],
              (int) bytes[ 3], (int) bytes[ 4], (int) bytes[ 5]);
   }

   // resetBytesInRange:
   {
      unsigned char orig[ 6] = { 1, 2, 3, 4, 5, 6 };
      mdata = [NSMutableData dataWithBytes:orig length:6];
      range = NSMakeRange( 2, 3);
      [mdata resetBytesInRange:range];
      bytes = (unsigned char *) [mdata bytes];
      printf( "reset: len=%lu [1]=%d [2]=%d [3]=%d [4]=%d [5]=%d\n",
              (unsigned long) [mdata length],
              (int) bytes[ 1], (int) bytes[ 2], (int) bytes[ 3],
              (int) bytes[ 4], (int) bytes[ 5]);
   }

   // setData:
   {
      unsigned char src[ 4] = { 7, 8, 9, 10 };
      NSData *newdata = [NSData dataWithBytes:src length:4];
      mdata = [NSMutableData dataWithLength:10];
      [mdata setData:newdata];
      printf( "setData length: %lu\n", (unsigned long) [mdata length]);
      bytes = (unsigned char *) [mdata bytes];
      printf( "setData[0]: %d\n", (int) bytes[ 0]);
      printf( "setData[3]: %d\n", (int) bytes[ 3]);
   }

   // mulleMutableData (struct mulle_data)
   {
      unsigned char src[ 4] = { 11, 22, 33, 44 };
      mdata = [NSMutableData dataWithBytes:src length:4];
      cdata = [mdata mulleMutableData];
      printf( "mulleMutableData length: %lu\n", (unsigned long) cdata.length);
      printf( "mulleMutableData[0]: %d\n", (int) ((unsigned char *) cdata.bytes)[ 0]);
   }

   // mulleCData (from mutable)
   {
      unsigned char src[ 4] = { 55, 66, 77, 88 };
      mdata = [NSMutableData dataWithBytes:src length:4];
      struct mulle_data cd = [mdata mulleCData];
      printf( "mulleCData from mutable length: %lu\n", (unsigned long) cd.length);
      printf( "mulleCData from mutable[0]: %d\n", (int) ((unsigned char *) cd.bytes)[ 0]);
   }

   // mutable copy of immutable data - use initWithData: instead of mutableCopy
   {
      unsigned char src[ 4] = { 1, 2, 3, 4 };
      idata = [NSData dataWithBytes:src length:4];
      NSMutableData *mcopy = [[[NSMutableData alloc] initWithData:idata] autorelease];
      printf( "mutable copy isNSMutableData: %d\n", (int) [mcopy __isNSMutableData]);
      printf( "mutable copy length: %lu\n", (unsigned long) [mcopy length]);
      bytes = (unsigned char *) [mcopy mutableBytes];
      bytes[0] = 99;
      printf( "mutable copy modified[0]: %d\n", (int) ((unsigned char *) [mcopy bytes])[ 0]);
      printf( "original unchanged[0]: %d\n", (int) ((unsigned char *) [idata bytes])[ 0]);
   }

   // copy of mutable data -> immutable
   {
      unsigned char src[ 4] = { 5, 6, 7, 8 };
      mdata = [NSMutableData dataWithBytes:src length:4];
      NSData *immcopy = (NSData *) [[mdata copy] autorelease];
      printf( "copy of mutable isNSMutableData: %d\n", (int) [immcopy __isNSMutableData]);
      printf( "copy of mutable isNSData: %d\n", (int) [immcopy __isNSData]);
   }

   // initWithData: mutable from immutable
   {
      unsigned char src[ 4] = { 1, 2, 3, 4 };
      idata = [NSData dataWithBytes:src length:4];
      NSMutableData *mfromimm = [[[NSMutableData alloc] initWithData:idata] autorelease];
      printf( "initWithData mutable length: %lu\n", (unsigned long) [mfromimm length]);
      printf( "initWithData mutable isNSMutableData: %d\n", (int) [mfromimm __isNSMutableData]);
   }

   // mulleSetLengthDontZero: - shrink to 0
   {
      unsigned char src[ 4] = { 1, 2, 3, 4 };
      mdata = [NSMutableData dataWithBytes:src length:4];
      [mdata mulleSetLengthDontZero:0];
      printf( "mulleSetLengthDontZero:0 length: %lu\n", (unsigned long) [mdata length]);
   }

   // mulleInitNonZeroedDataWithLength: is internally complex; skip direct test

   return( 0);
}
