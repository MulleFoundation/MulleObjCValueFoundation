#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int  main( void)
{
   NSNumber     *value1;
   NSNumber     *value2;
   NSUInteger   hash1;
   NSUInteger   hash2;

   // this valgrinded badly once
   value1 = [[NSNumber alloc] initWithDouble:7.0/10];
   hash1  = [value1 hash];

   value2 = [value1 copy];
   hash2  = [value2 hash];

   [value2 release];
   [value1 release];

   return( hash1 != hash2);  // returns 0 if both equal, which is good
}
