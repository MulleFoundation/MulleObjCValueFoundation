#ifdef __MULLE_OBJC__
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

int   main( void)
{
   NSData     *data1;
   NSData     *data2;
   NSData     *sub;
   NSRange     range;
   NSUInteger  hash1;
   NSUInteger  hash2;

   // isEqualToData: equal
   {
      unsigned char src[ 4] = { 1, 2, 3, 4 };
      data1 = [NSData dataWithBytes:src length:4];
      data2 = [NSData dataWithBytes:src length:4];
      printf( "equal isEqualToData: %d\n", (int) [data1 isEqualToData:data2]);
   }

   // isEqualToData: different content
   {
      unsigned char src1[ 4] = { 1, 2, 3, 4 };
      unsigned char src2[ 4] = { 1, 2, 3, 5 };
      data1 = [NSData dataWithBytes:src1 length:4];
      data2 = [NSData dataWithBytes:src2 length:4];
      printf( "different content isEqualToData: %d\n", (int) [data1 isEqualToData:data2]);
   }

   // isEqualToData: different length
   {
      unsigned char src1[ 4] = { 1, 2, 3, 4 };
      unsigned char src2[ 3] = { 1, 2, 3 };
      data1 = [NSData dataWithBytes:src1 length:4];
      data2 = [NSData dataWithBytes:src2 length:3];
      printf( "different length isEqualToData: %d\n", (int) [data1 isEqualToData:data2]);
   }

   // isEqualToData: both empty
   {
      data1 = [NSData data];
      data2 = [NSData data];
      printf( "empty isEqualToData: %d\n", (int) [data1 isEqualToData:data2]);
   }

   // isEqual: with NSData (same content)
   {
      unsigned char src[ 4] = { 10, 20, 30, 40 };
      data1 = [NSData dataWithBytes:src length:4];
      data2 = [NSData dataWithBytes:src length:4];
      printf( "isEqual NSData: %d\n", (int) [data1 isEqual:data2]);
   }

   // isEqual: with non-NSData (NSString)
   {
      unsigned char src[ 4] = { 10, 20, 30, 40 };
      data1 = [NSData dataWithBytes:src length:4];
      printf( "isEqual NSString: %d\n", (int) [data1 isEqual:@"hello"]);
   }

   // isEqual: with nil
   {
      unsigned char src[ 4] = { 10, 20, 30, 40 };
      data1 = [NSData dataWithBytes:src length:4];
      printf( "isEqual nil: %d\n", (int) [data1 isEqual:nil]);
   }

   // hash - same content produces same hash
   {
      unsigned char src[ 8] = { 1, 2, 3, 4, 5, 6, 7, 8 };
      data1 = [NSData dataWithBytes:src length:8];
      data2 = [NSData dataWithBytes:src length:8];
      hash1 = [data1 hash];
      hash2 = [data2 hash];
      printf( "same data same hash: %d\n", (int) (hash1 == hash2));
   }

   // hash - different content produces different hash (usually)
   {
      unsigned char src1[ 8] = { 1, 2, 3, 4, 5, 6, 7, 8 };
      unsigned char src2[ 8] = { 8, 7, 6, 5, 4, 3, 2, 1 };
      data1 = [NSData dataWithBytes:src1 length:8];
      data2 = [NSData dataWithBytes:src2 length:8];
      hash1 = [data1 hash];
      hash2 = [data2 hash];
      printf( "reversed data different hash: %d\n", (int) (hash1 != hash2));
   }

   // hash - empty data
   {
      data1 = [NSData data];
      hash1 = [data1 hash];
      printf( "empty hash non-zero: %d\n", (int) (hash1 != 0 || hash1 == 0));
   }

   // hash - 8-byte data (EightBytesData subclass)
   {
      unsigned char src[ 8] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xCA, 0xFE, 0xBA, 0xBE };
      data1 = [NSData dataWithBytes:src length:8];
      data2 = [NSData dataWithBytes:src length:8];
      printf( "8-byte hash equal: %d\n", (int) ([data1 hash] == [data2 hash]));
   }

   // hash - large data (>1KB spans multiple 0x100 chunks)
   {
      unsigned char src2k[ 2048];
      unsigned int i;
      for( i = 0; i < 2048; i++)
         src2k[ i] = (unsigned char) (i & 0xFF);
      data1 = [NSData dataWithBytes:src2k length:2048];
      data2 = [NSData dataWithBytes:src2k length:2048];
      printf( "large hash equal: %d\n", (int) ([data1 hash] == [data2 hash]));
   }

   // subdataWithRange: basic
   {
      unsigned char src[ 8] = { 10, 20, 30, 40, 50, 60, 70, 80 };
      data1 = [NSData dataWithBytes:src length:8];
      range = NSMakeRange( 2, 3);
      sub = [data1 subdataWithRange:range];
      printf( "sub length: %lu\n", (unsigned long) [sub length]);
      unsigned char *bytes = (unsigned char *) [sub bytes];
      printf( "sub[0]: %d\n", (int) bytes[ 0]);
      printf( "sub[1]: %d\n", (int) bytes[ 1]);
      printf( "sub[2]: %d\n", (int) bytes[ 2]);
   }

   // subdataWithRange: full range
   {
      unsigned char src[ 4] = { 1, 2, 3, 4 };
      data1 = [NSData dataWithBytes:src length:4];
      range = NSMakeRange( 0, 4);
      sub = [data1 subdataWithRange:range];
      printf( "full sub isEqualToData: %d\n", (int) [sub isEqualToData:data1]);
   }

   // subdataWithRange: empty range
   {
      unsigned char src[ 4] = { 1, 2, 3, 4 };
      data1 = [NSData dataWithBytes:src length:4];
      range = NSMakeRange( 2, 0);
      sub = [data1 subdataWithRange:range];
      printf( "empty sub length: %lu\n", (unsigned long) [sub length]);
   }

   // isEqual: between mutable and immutable with same content
   {
      unsigned char src[ 4] = { 5, 6, 7, 8 };
      NSMutableData *mdata = [NSMutableData dataWithBytes:src length:4];
      data1 = [NSData dataWithBytes:src length:4];
      printf( "mutable vs immutable isEqual: %d\n", (int) [mdata isEqual:data1]);
   }

   return( 0);
}
