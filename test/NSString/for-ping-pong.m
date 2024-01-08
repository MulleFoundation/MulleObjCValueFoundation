#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


static void    test( NSString *s)
{
   struct MulleStringEnumerator   rover;
   unichar      c, d;

   _MulleStringEnumeratorInit( &rover, s);

   if( MulleStringEnumeratorNext( &rover, &c))
      mulle_printf( "n:'%lC'\n", c);

   if( MulleStringEnumeratorPrevious( &rover, &c))
      mulle_printf( "p:'%lC'\n", c);

   if( MulleStringEnumeratorPrevious( &rover, &c))
      mulle_printf( "p:'%lC'\n", c);

   if( MulleStringEnumeratorNext( &rover, &c))
      mulle_printf( "n:'%lC'\n", c);

   if( MulleStringEnumeratorNext( &rover, &c))
      mulle_printf( "n:'%lC'\n", c);

   if( MulleStringEnumeratorNext( &rover, &c))
      mulle_printf( "n:'%lC'\n", c);

   if( MulleStringEnumeratorPrevious( &rover, &c))
      mulle_printf( "p:'%lC'\n", c);

   if( MulleStringEnumeratorPrevious( &rover, &c))
      mulle_printf( "p:'%lC'\n", c);

   if( MulleStringEnumeratorPrevious( &rover, &c))
      mulle_printf( "p:'%lC'\n", c);

   MulleStringEnumeratorDone( &rover);
}



int   main( void)
{
   test( @"VfL");

   return( 0);
}
