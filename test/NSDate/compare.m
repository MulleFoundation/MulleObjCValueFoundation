#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>

static inline char   *_NSComparisonResultUTF8String( NSComparisonResult result)
{
   return( result < 0 ? "<" : (result > 0 ? ">" : "="));
}

#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


static void    test( NSDate *a, NSDate *b)
{
   NSTimeInterval   a_i;
   NSTimeInterval   b_i;

   printf( "   ");
   {
      if( a)
         printf( "%.1f", [a timeIntervalSinceReferenceDate]);
      else
         printf( "*nil*");

      printf( " %s ", _NSComparisonResultUTF8String( [a compare:b]));

      if( b)
         printf( "%.1f", [b timeIntervalSinceReferenceDate]);
      else
         printf( "*nil*");
   }
   printf( "\n");
}


int   main( void)
{
   NSDate   *value1;
   NSDate   *value2;
   NSDate   *value3;

   value1 = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:-1.5] autorelease];
   value2 = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:0] autorelease];
   value3 = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:1.5] autorelease];

   printf( "nil\n");
   test( nil, nil);
   test( nil, value1);
   test( nil, value2);
   test( nil, value3);

   printf( "1\n");
   test( value1, nil);
   test( value1, value1);
   test( value1, value2);
   test( value1, value3);

   printf( "2\n");
   test( value2, nil);
   test( value2, value1);
   test( value2, value2);
   test( value2, value3);

   printf( "3\n");
   test( value3, nil);
   test( value3, value1);
   test( value3, value2);
   test( value3, value3);

   return( 0);
}
