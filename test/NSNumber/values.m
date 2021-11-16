#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>

static inline char   *_NSComparisonResultUTF8String( NSComparisonResult result)
{
   return( result < 0 ? "<" : (result > 0 ? ">" : "="));
}


static inline char   *_MulleBoolUTF8String( BOOL result)
{
   return( result ? "YES" : "NO");
}


#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <float.h>
#include <math.h>


// some harmless values :)
static double  values[] =
{
   0.8,
   12.2,
   7/10.0,
   1848.0,
   FLT_MIN,
   FLT_MIN-0.00001,
   FLT_MAX,
   FLT_MAX+0.00001,
   1.2e-63,
   1.2e+63
};


#define sizeof_array( array) ( sizeof( array) / sizeof( array[ 0]))

int   main( void)
{
   NSNumber             *nr1;
   NSNumber             *nr2;
   NSInteger            i;
   NSInteger            j;
   NSComparisonResult   result;
   BOOL                 flag;

   for( i = 0; i < sizeof_array( values); i++)
   {
      nr1 = [NSNumber numberWithDouble:values[ i]];
      for( j = i + 1; j < sizeof_array( values); j++)
      {
         nr2 = [NSNumber numberWithDouble:values[ j]];

         printf( "C: %g <op> %g :",
                     values[ i],
                     values[ j]);
         if( values[ i] < values[ j])
            printf( " <");
         if( values[ i] == values[ j])
            printf( " ==");
         if( values[ i] != values[ j])
            printf( " !=");
         if( values[ i] > values[ j])
            printf( " >");
         printf( "\n");

         printf( "C: %g <op> %g :",
                     values[ j],
                     values[ i]);
         if( values[ j] < values[ i])
            printf( " <");
         if( values[ j] == values[ i])
            printf( " ==");
         if( values[ j] != values[ i])
            printf( " !=");
         if( values[ j] > values[ i])
            printf( " >");
         printf( "\n");


         result = [nr1 compare:nr2];
         printf( "   [%g compare:%g] : %s\n",
                     values[ i],
                     values[ j],
                     _NSComparisonResultUTF8String( result));

         result = [nr2 compare:nr1];
         printf( "   [%g compare:%g] : %s\n",
                     values[ j],
                     values[ i],
                     _NSComparisonResultUTF8String( result));

         flag = [nr1 isEqual:nr2];
         printf( "   [%g isEqual:%g] : %s\n",
                     values[ i],
                     values[ j],
                     _MulleBoolUTF8String( flag));

         flag = [nr2 isEqual:nr1];
         printf( "   [%g isEqual:%g] : %s\n",
                     values[ j],
                     values[ i],
                     _MulleBoolUTF8String( flag));

         flag = [nr1 isEqualToNumber:nr2];
         printf( "   [%g isEqualToNumber:%g] : %s\n",
                     values[ i],
                     values[ j],
                     _MulleBoolUTF8String( flag));

         flag = [nr2 isEqualToNumber:nr1];
         printf( "   [%g isEqualToNumber:%g] : %s\n",
                     values[ j],
                     values[ i],
                     _MulleBoolUTF8String( flag));
      }
   }
   return( 0);
}
