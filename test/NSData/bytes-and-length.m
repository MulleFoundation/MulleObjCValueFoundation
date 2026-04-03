#ifdef __MULLE_OBJC__
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

#include <string.h>

int   main( void)
{
   NSData       *data;
   NSData       *copy;
   unsigned char buf[ 64];
   NSRange       range;
   NSUInteger    len;
   unsigned char *bytes;

   // empty data (length=0 -> _MulleObjCZeroBytesData)
   data = [NSData data];
   printf( "empty length: %lu\n", (unsigned long) [data length]);
   printf( "isNSData: %d\n", (int) [data __isNSData]);
   printf( "isNSMutableData: %d\n", (int) [data __isNSMutableData]);

   // 8-byte data -> _MulleObjCEightBytesData
   {
      unsigned char src8[ 8] = { 1, 2, 3, 4, 5, 6, 7, 8 };
      data = [NSData dataWithBytes:src8 length:8];
      printf( "8-byte length: %lu\n", (unsigned long) [data length]);
      bytes = (unsigned char *) [data bytes];
      printf( "8-byte[0]: %d\n", (int) bytes[ 0]);
      printf( "8-byte[7]: %d\n", (int) bytes[ 7]);
   }

   // 16-byte data -> _MulleObjCSixteenBytesData
   {
      unsigned char src16[ 16] = { 10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25 };
      data = [NSData dataWithBytes:src16 length:16];
      printf( "16-byte length: %lu\n", (unsigned long) [data length]);
      bytes = (unsigned char *) [data bytes];
      printf( "16-byte[0]: %d\n", (int) bytes[ 0]);
      printf( "16-byte[15]: %d\n", (int) bytes[ 15]);
   }

   // tiny data (1-256 bytes) -> _MulleObjCTinyData
   {
      unsigned char src4[ 4] = { 'a', 'b', 'c', 'd' };
      data = [NSData dataWithBytes:src4 length:4];
      printf( "tiny length: %lu\n", (unsigned long) [data length]);
      bytes = (unsigned char *) [data bytes];
      printf( "tiny[0]: %c\n", bytes[ 0]);
      printf( "tiny[3]: %c\n", bytes[ 3]);
   }

   // medium data (257..65792) -> _MulleObjCMediumData
   {
      unsigned char src300[ 300];
      memset( src300, 0xAB, 300);
      src300[ 0]   = 0x11;
      src300[ 299] = 0x22;
      data = [NSData dataWithBytes:src300 length:300];
      printf( "medium length: %lu\n", (unsigned long) [data length]);
      bytes = (unsigned char *) [data bytes];
      printf( "medium[0]: 0x%02x\n", (unsigned int) bytes[ 0]);
      printf( "medium[299]: 0x%02x\n", (unsigned int) bytes[ 299]);
   }

   // large data (>65792) -> _MulleObjCAllocatorData
   {
      unsigned char src70k[ 70000];
      memset( src70k, 0x55, 70000);
      src70k[ 0]     = 0xAA;
      src70k[ 69999] = 0xBB;
      data = [NSData dataWithBytes:src70k length:70000];
      printf( "large length: %lu\n", (unsigned long) [data length]);
      bytes = (unsigned char *) [data bytes];
      printf( "large[0]: 0x%02x\n", (unsigned int) bytes[ 0]);
      printf( "large[69999]: 0x%02x\n", (unsigned int) bytes[ 69999]);
   }

   // initWithData: from immutable -> shares bytes (NoCopy path)
   {
      unsigned char src8[ 8] = { 1, 2, 3, 4, 5, 6, 7, 8 };
      NSData *orig = [NSData dataWithBytes:src8 length:8];
      data = [[[NSData alloc] initWithData:orig] autorelease];
      printf( "initWithData immutable length: %lu\n", (unsigned long) [data length]);
      bytes = (unsigned char *) [data bytes];
      printf( "initWithData immutable[0]: %d\n", (int) bytes[ 0]);
   }

   // initWithData: from mutable -> copies bytes
   {
      NSMutableData *mdata = [NSMutableData dataWithLength:5];
      unsigned char *mbytes = (unsigned char *) [mdata mutableBytes];
      mbytes[ 0] = 42;
      mbytes[ 4] = 99;
      data = [[[NSData alloc] initWithData:mdata] autorelease];
      printf( "initWithData mutable length: %lu\n", (unsigned long) [data length]);
      bytes = (unsigned char *) [data bytes];
      printf( "initWithData mutable[0]: %d\n", (int) bytes[ 0]);
      printf( "initWithData mutable[4]: %d\n", (int) bytes[ 4]);
   }

   // dataWithBytesNoCopy:length: (freeWhenDone:NO)
   {
      static unsigned char nocopy[ 4] = { 7, 8, 9, 10 };
      data = [NSData dataWithBytesNoCopy:nocopy length:4 freeWhenDone:NO];
      printf( "nocopy length: %lu\n", (unsigned long) [data length]);
      bytes = (unsigned char *) [data bytes];
      printf( "nocopy[0]: %d\n", (int) bytes[ 0]);
   }

   // getBytes: (no length) - copies all bytes
   {
      unsigned char src8[ 8] = { 11, 22, 33, 44, 55, 66, 77, 88 };
      data = [NSData dataWithBytes:src8 length:8];
      memset( buf, 0, sizeof( buf));
      [data getBytes:buf];
      printf( "getBytes all: %d %d %d %d\n", (int) buf[0], (int) buf[1], (int) buf[6], (int) buf[7]);
   }

   // getBytes:length: - copies partial
   {
      unsigned char src8[ 8] = { 11, 22, 33, 44, 55, 66, 77, 88 };
      data = [NSData dataWithBytes:src8 length:8];
      memset( buf, 0, sizeof( buf));
      [data getBytes:buf length:4];
      printf( "getBytes:4: %d %d %d %d / %d\n", (int) buf[0], (int) buf[1], (int) buf[2], (int) buf[3], (int) buf[4]);
   }

   // getBytes:range: - copies range
   {
      unsigned char src8[ 8] = { 11, 22, 33, 44, 55, 66, 77, 88 };
      data = [NSData dataWithBytes:src8 length:8];
      memset( buf, 0, sizeof( buf));
      range = NSMakeRange( 2, 3);
      [data getBytes:buf range:range];
      printf( "getBytes:range 2,3: %d %d %d / %d\n", (int) buf[0], (int) buf[1], (int) buf[2], (int) buf[3]);
   }

   // mulleCData
   {
      unsigned char src4[ 4] = { 1, 2, 3, 4 };
      data = [NSData dataWithBytes:src4 length:4];
      struct mulle_data cdata = [data mulleCData];
      printf( "mulleCData length: %lu\n", (unsigned long) cdata.length);
      printf( "mulleCData[0]: %d\n", (int) ((unsigned char *) cdata.bytes)[ 0]);
   }

   return( 0);
}
