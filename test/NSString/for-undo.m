#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

static void    print_c_d_flag( unichar c, unichar d, BOOL flag)
{
   mulle_printf( "\n\t\t");
   mulle_printf( (c <= 0) ? "%d": "'%lC'", c);
   mulle_printf( " ");
   mulle_printf( (d <= 0) ? "%d": "'%lC'", d);
   mulle_printf( " (%bd)", flag);
}


static void    test( NSString *s, NSUInteger n, NSUInteger m)
{
   struct MulleStringEnumerator   rover;
   NSUInteger   i, j;
   BOOL         flag;
   unichar      c, d;

   mulle_printf( "\"%#s\" (%td, %td)", [s UTF8String], n, m);

   _MulleStringEnumeratorInit( &rover, s);

   if( n)
   {
      mulle_printf( "\n\tnext:");

      for( i = 0; i < n; i++)
      {
         if( MulleStringEnumeratorNext( &rover, &c))
            mulle_printf( "\n\t\t'%lC' ", c);
      }
   }

   if( m)
   {
      mulle_printf( "\n\tundo:");

      for( j = 0; j < m; j++)
      {
         flag = _MulleStringEnumeratorUndoNext( &rover, &c, &d);
         print_c_d_flag( c, d, flag);
      }
   }

   mulle_printf( "\n\tnext:");
      if( MulleStringEnumeratorNext( &rover, &c))
         mulle_printf( "\n\t\t'%lC' ", c);

   MulleStringEnumeratorDone( &rover);

   mulle_printf( "\n\n");
}



int   main( void)
{
   NSUInteger   i, j;

   for( i = 1; i < 4; i++)
      for( j = 1; j < 4; j++)
         test( @"VfL", i, j);

   return( 0);
}
