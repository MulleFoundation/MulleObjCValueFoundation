#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


void   test( NSString *pattern)
{
   NSUInteger                     length;
   NSUInteger                     copy_length;
   unichar                        a;
   unichar                        b;
   unichar                        c;
   unichar                        d;
   unichar                        *p;
   unichar                        *memo;
   unichar                        *sentinel;
   NSRange                        range;
   struct MulleStringEnumerator   *rover;
   NSString                       *translated;

   length = [pattern length];
   mulle_alloca_do( copy, unichar, length * 3)
   {
      p = copy;
      d = 0;
      MulleStringFor( pattern, c)
      {
         if( d == '\\')
         {
            if( c != '(' && c != ')')
               *p++ = d;
            *p++ = c;
         }
         else
            switch( c)
            {
            case '\\' :
               break;

            //
            // we have to change *x to [!x]*x, can be problematic though,
            // if we get *[x-z]... hmmm
            //
            case '*'  :
               rover = MulleStringForGetEnumerator( c);
               if( ! MulleStringEnumeratorNext( rover, &a))
                  break;

               // so we have
               if( a == '[')
               {
                  // memorize output and then copy at the back
                  memo = p;
                  *p++ = '[';

                  if( ! MulleStringEnumeratorNext( rover, &a))
                     abort();

                  if( a != '!')
                  {
                     *p++ = '^';
                     *p++ = a;
                  }

                  b = a;
                  while( MulleStringEnumeratorNext( rover, &a))
                  {
                     *p++ = a;
                     if( b == '\\')
                        continue;
                     if( a == ']')
                        break;
                  }

                  if( a != ']')
                     abort();

                  sentinel = p;

                  *p++ = '*';

                  // now copy pattern again worst case is *[x] to [^x]*[x]
                  // 4 to 8, two times larger
                  *p++ = *memo++;
                  if( *memo != '^')
                     *p++ = '^';
                  do
                  {
                     a    = *memo++;
                     *p++ = a;
                  }
                  while( memo < sentinel);

                  c = a;
               }
               else
               {
                  // we read *a and explode to [^a]*a, three times larger
                  b    = 0;
                  *p++ = '[';
                  *p++ = '^';
                  if( a == '\\')
                  {
                     *p++ = a;
                     if( ! MulleStringEnumeratorNext( rover, &b))
                        abort();
                     *p++ = b;
                  }
                  *p++ = ']';
                  *p++ = '*';
                  *p++ = a;
                  if( b)
                     *p++ = b;

                  c = b;
               }
               break;

            case '?'  :
               *p++ = '.';
               break;

            // char(s) that need escaping
            case '^'  :
            case '$'  :
            case '.'  :
               *p++ = '\\';
               *p++ = c;
               break;

            case '!'  :
               // gotta check for
               if( d == '[')
               {
                  // check if we don't get \\[
                  if( &p[ -2] < copy || p[ -2] != '\\')
                     *p++ = '^';
                  else
                     *p++ = c;
               }
               else
                  *p++ = c;   // replace [!  with ]
               break;

            default :
               *p++ = c;
            }
         d = c;
      }

      // if we have a trailing '\\', we pass it on to error later on
      if( d == '\\')
         *p++ = d;

      copy_length = p - copy;
      assert( copy_length <= length * 3);

      translated = [NSString mulleStringWithCharactersNoCopy:copy
                                                      length:copy_length
                                                   allocator:NULL];
      mulle_printf( "\"%@\" -> \"%@\"\n", pattern, translated);
   }
}


int   main( void)
{
   NSMutableString   *s;

   test( @"");
   test( @"?");
   test( @"*");
   test( @"*.*");
   test( @"a*b");
   test( @"a?[b]c*d");
   test( @"a*[!b-c]d");
   test( @"a*\\[!b]");
   test( @"\\a\\*\\[\\!\\b-c\\]d");

   return( 0);
}
