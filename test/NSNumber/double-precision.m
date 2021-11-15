#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <float.h>
#include <math.h>


static double values[] =
{
   0.8,
   8.2,
   8.3,
   11.7,
   11.07,
   11.007,
   11.0007,
   11.00007,
   11.000007,
   11.0000007,
   11.00000007,
   11.000000007,
   11.0000000007,
   11.00000000007,
   11.000000000007,
   11.0000000000007,
   11.00000000000007,
   11.000000000000007
};


#define sizeof_array( array) ( sizeof( array) / sizeof( array[ 0]))


int   main( void)
{
   NSNumber    *nr;
   NSUInteger  i;

   for( i = 0; i < sizeof_array( values); i++)
   {
      nr  = [NSNumber numberWithDouble:values[ i]];
      
      printf( "%%0.17g=%0.17g --- %%0.16g=%0.16g --- %%g=%g ::: description=%s\n", 
			values[ i], 
			values[ i], 
			values[ i], 
			[[nr description] UTF8String]);
   }
   return( 0);
}
