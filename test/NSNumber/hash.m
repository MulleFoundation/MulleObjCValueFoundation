#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int  main( void)
{
   NSNumber      *value;
   NSUInteger    hash;
   int           fails;

   fails = 0;
   value = [NSNumber numberWithInt:1848];
   hash  = [value hash];

   value = [NSNumber numberWithInt:1849];
   if( [value hash] == hash)
   {
      printf( "numberWithInt:1848 and numberWithInt:1849 should differ\n");
      fails++;
   }
   value = [NSNumber numberWithInteger:1848];
   if( [value hash] != hash)
   {
      printf( "numberWithInt: and numberWithInteger: differ\n");
      fails++;
   }

   value = [NSNumber numberWithUnsignedInteger:1848];
   if( [value hash] != hash)
   {
      printf( "numberWithInt: and numberWithUnsignedInteger: differ\n");
      fails++;
   }

   value = [NSNumber numberWithDouble:1848.0];
   if( [value hash] != hash)
   {
      printf( "numberWithInt: and numberWithDouble: differ\n");
      fails++;
   }

   value = [NSNumber numberWithLongDouble:1848.0];
   if( [value hash] != hash)
   {
      printf( "numberWithInt: and numberWithLongDouble: differ\n");
      fails++;
   }

   return( fails);
}
