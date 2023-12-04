//
//  NSString.h
//  MulleObjCValueFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "NSString.h"


@interface NSString( Enumerator)

- (NSUInteger) mulleGetCharacters:(unichar *) buf
                        fromIndex:(NSUInteger) index
                        maxLength:(NSUInteger) maxLength;

// will return 0 if not available
- (NSUInteger) _mulleFastGetData:(struct mulle_data *) data;

// used by NSMutableString, others do nuthin but return self,
// NSMutableString will compact itself, but returns it's internal NSString
- (NSString *) mulleCompact;

@end


//
// this could be platform specific, but try to not go lower than 8 on 64 bit
// Memo: to enumerate ranges we would need another `_n` entry, but I don't
//       think enumerating subranges will be common.
//
#define NSStringEnumeratorNumberOfCharacters    22

struct NSStringEnumerator
{
   void          *_curr;                  // 8 byte
   void          *_sentinel;              // 8 byte
   // NSUInteger _size;
   unichar       (*_next)( void **curr);  // 8 byte
   NSUInteger    _i;                      // 8 byte
   NSString      *_string;                // 8 byte, if set use copy/else direct ?
   unichar       _buf[ NSStringEnumeratorNumberOfCharacters]; // 128 - 40 / 4
};


//
// because this is static inline, I don't feel bad pushing 256 bytes
// via the "stack", it should be all for naught. Notice that the address
// of _buf (but not the content) will change when returning by value(!)
// so don't reference _buf in here
static inline struct NSStringEnumerator   NSStringEnumerate( NSString *self)
{
   struct NSStringEnumerator   rover;

   rover._curr     = NULL;
   rover._sentinel = NULL;
   rover._next     = 0;
   rover._i        = 0;
   rover._string   = [self mulleCompact];  // needed for NSMutableString

   // try to avoid zeroing _buf uselessly, though compiler will probably
   // get teary eyed
   return( rover);
}


static inline unichar   mulle_get_char_as_unichar( void **s)
{
   char   *p_c;
   char   **pp_c;
   char   c;

   pp_c  = (char **) s;
   p_c   = *pp_c;
   c     = *p_c++;
   *s    = p_c;
   return( c);
}


static inline unichar   mulle_get_utf16_as_unichar( void **s)
{
   mulle_utf16_t   *p_c;
   mulle_utf16_t   **pp_c;
   mulle_utf16_t   c;

   pp_c  = (mulle_utf16_t **) s;
   p_c   = *pp_c;
   c     = *p_c++;
   *s    = p_c;
   return( c);
}


static inline unichar   mulle_get_utf32_as_unichar( void **s)
{
   mulle_utf32_t   *p_c;
   mulle_utf32_t   **pp_c;
   mulle_utf32_t   c;

   pp_c  = (mulle_utf32_t **) s;
   p_c   = *pp_c;
   c     = *p_c++;
   *s    = p_c;
   return( c);
}

//
// alternative version, but the indirect jump oughta be better because of
// less branching and much less code
//
static inline unichar   mulle_get_varsized_unichar( void **s, unsigned int size)
{
   if( size == sizeof( char))
      return( mulle_get_char_as_unichar( s));

   if( size == sizeof( mulle_utf32_t))
      return( mulle_get_utf32_as_unichar( s));

   return( mulle_get_utf16_as_unichar( s));
}


static inline BOOL   NSStringEnumeratorNext( struct NSStringEnumerator *rover, unichar *c)
{
   extern BOOL  _NSStringEnumeratorFill( struct NSStringEnumerator *rover);
   unichar   d;

   if( ! rover)
      return( NO);

   if( MULLE_C_UNLIKELY( rover->_curr == rover->_sentinel))
   {
      if( ! _NSStringEnumeratorFill( rover))
         return( NO);
   }

   // d = mulle_get_varsized_unichar( &rover->_curr, rover->_size);
   d = (*rover->_next)( &rover->_curr);
   if( c)
      *c = d;
   return( YES);
}


static inline void   NSStringEnumeratorDone( struct NSStringEnumerator *rover)
{
}

// because `s` could be a constant string, we play off `c` to generate
// unique identifiers, as this has to be a variable

#define NSStringFor( s, c)                                              \
   assert( sizeof( c) == sizeof( unichar));                             \
   for( struct NSStringEnumerator                                       \
           rover__ ## c = NSStringEnumerate( s),                        \
           *rover___  ## c ## __i = (void *) 0;                         \
        ! rover___  ## c ## __i;                                        \
        rover___ ## c ## __i = (NSStringEnumeratorDone( &rover__ ## c), \
                               (void *) 1))                             \
      while( NSStringEnumeratorNext( &rover__ ## c, &c))

