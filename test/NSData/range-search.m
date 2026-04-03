#ifdef __MULLE_OBJC__
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

// haystack: "hello world hello"
// needle: "hello"  "world"  "xyz"

static unsigned char haystack[] = { 'h','e','l','l','o',' ','w','o','r','l','d',' ','h','e','l','l','o' };
static unsigned char needle_hello[] = { 'h','e','l','l','o' };
static unsigned char needle_world[] = { 'w','o','r','l','d' };
static unsigned char needle_xyz[]   = { 'x','y','z' };

int   main( void)
{
   NSData   *hdata;
   NSData   *nhello;
   NSData   *nworld;
   NSData   *nxyz;
   NSRange   fullRange;
   NSRange   result;

   hdata  = [NSData dataWithBytes:haystack length:17];
   nhello = [NSData dataWithBytes:needle_hello length:5];
   nworld = [NSData dataWithBytes:needle_world length:5];
   nxyz   = [NSData dataWithBytes:needle_xyz length:3];

   fullRange = NSMakeRange( 0, 17);

   // forward search - finds first "hello" at offset 0
   result = [hdata rangeOfData:nhello
                       options:0
                         range:fullRange];
   printf( "forward hello: loc=%lu len=%lu\n",
           (unsigned long) result.location,
           (unsigned long) result.length);

   // forward search - finds "world" at offset 6
   result = [hdata rangeOfData:nworld
                       options:0
                         range:fullRange];
   printf( "forward world: loc=%lu len=%lu\n",
           (unsigned long) result.location,
           (unsigned long) result.length);

   // forward search - not found
   result = [hdata rangeOfData:nxyz
                       options:0
                         range:fullRange];
   printf( "forward xyz: loc=%lu len=%lu\n",
           (unsigned long) result.location,
           (unsigned long) result.length);

   // backward search - finds last "hello" at offset 12
   result = [hdata rangeOfData:nhello
                       options:NSDataSearchBackwards
                         range:fullRange];
   printf( "backward hello: loc=%lu len=%lu\n",
           (unsigned long) result.location,
           (unsigned long) result.length);

   // backward search - not found
   result = [hdata rangeOfData:nxyz
                       options:NSDataSearchBackwards
                         range:fullRange];
   printf( "backward xyz: loc=%lu len=%lu\n",
           (unsigned long) result.location,
           (unsigned long) result.length);

   // anchored forward - "hello" at start of range (offset 0) -> found
   result = [hdata rangeOfData:nhello
                       options:NSDataSearchAnchored
                         range:fullRange];
   printf( "anchored-fwd hello at 0: loc=%lu len=%lu\n",
           (unsigned long) result.location,
           (unsigned long) result.length);

   // anchored forward - "world" is NOT at start -> not found
   result = [hdata rangeOfData:nworld
                       options:NSDataSearchAnchored
                         range:fullRange];
   printf( "anchored-fwd world at 0: loc=%lu len=%lu\n",
           (unsigned long) result.location,
           (unsigned long) result.length);

   // anchored backward (end of range) - "hello" at end offset 12 -> found
   result = [hdata rangeOfData:nhello
                       options:(NSDataSearchAnchored | NSDataSearchBackwards)
                         range:fullRange];
   printf( "anchored-bwd hello at end: loc=%lu len=%lu\n",
           (unsigned long) result.location,
           (unsigned long) result.length);

   // anchored backward - "world" NOT at end -> not found
   result = [hdata rangeOfData:nworld
                       options:(NSDataSearchAnchored | NSDataSearchBackwards)
                         range:fullRange];
   printf( "anchored-bwd world at end: loc=%lu len=%lu\n",
           (unsigned long) result.location,
           (unsigned long) result.length);

   // search within sub-range - find "world" in range [6, 5]
   {
      NSRange subRange = NSMakeRange( 6, 5);
      result = [hdata rangeOfData:nworld
                          options:0
                            range:subRange];
      printf( "sub-range world in [6,5]: loc=%lu len=%lu\n",
              (unsigned long) result.location,
              (unsigned long) result.length);
   }

   // search within sub-range where needle not present
   {
      NSRange subRange = NSMakeRange( 0, 5);
      result = [hdata rangeOfData:nworld
                          options:0
                            range:subRange];
      printf( "sub-range world in [0,5]: loc=%lu len=%lu\n",
              (unsigned long) result.location,
              (unsigned long) result.length);
   }

   // needle longer than search range -> not found
   {
      NSRange subRange = NSMakeRange( 0, 3);
      result = [hdata rangeOfData:nhello
                          options:0
                            range:subRange];
      printf( "needle longer than range: loc=%lu len=%lu\n",
              (unsigned long) result.location,
              (unsigned long) result.length);
   }

   // empty needle -> not found (length=0 returns NSNotFound per implementation)
   {
      NSData *empty = [NSData data];
      result = [hdata rangeOfData:empty
                          options:0
                            range:fullRange];
      printf( "empty needle: loc=%lu len=%lu\n",
              (unsigned long) result.location,
              (unsigned long) result.length);
   }

   return( 0);
}
