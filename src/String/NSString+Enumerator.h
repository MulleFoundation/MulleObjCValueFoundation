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
- (NSString *) mulleCompactedString;

@end


//
// Originally, this Enumerator supported "paging" into _buf. To support non
// contiguous strings (for NSMutableString). But as we `compact` the
// NSMutableString before enumeration, this is no longer necessary. So the
// only ones who need _buf are TPS strings. Luckily their size is known to be
// 12 at most (mulle_char5_maxlength64). So it is guaranteed that the full
// character range is available in the enumerator. This makes writing parsers
// much easier, that for instance need to backtrack..
//
#define MulleStringEnumeratorNumberOfCharacters    (mulle_char5_maxlength64+1)

struct MulleStringEnumerator
{
   void          *_curr;
   void          *_start;
   void          *_sentinel;
   NSUInteger    _size;
   unichar       (*_get)( void *curr);
   //NSString      *_string;  // no longer needed
   unichar       _buf[ MulleStringEnumeratorNumberOfCharacters];
};


void   _MulleStringEnumeratorInit( struct MulleStringEnumerator *rover, NSString *s);



static inline void   MulleStringEnumeratorRestart( struct MulleStringEnumerator *rover)
{
   if( rover)
      rover->_curr = rover->_start;
}


static inline void   MulleStringEnumeratorFinish( struct MulleStringEnumerator *rover)
{
   if( rover)
      rover->_curr = rover->_sentinel;
}



static inline void
   _MulleStringEnumeratorInitReverse( struct MulleStringEnumerator *rover, NSString *self)
{
   _MulleStringEnumeratorInit( rover, self);
   MulleStringEnumeratorFinish( rover);  // sic!
}



// "Next" reads the current character if available and moves the rover one
// character ahead.
//
// v      v
// c..   c..
static inline BOOL   MulleStringEnumeratorNext( struct MulleStringEnumerator *rover, unichar *c)
{
   if( ! rover)
      return( NO);

   if( MULLE_C_UNLIKELY( rover->_curr == rover->_sentinel))
      return( NO);

   if( c)
      *c = (*rover->_get)( rover->_curr);
   rover->_curr = &((char *) rover->_curr)[ rover->_size];
   return( YES);
}


//   v        v
// dc..  ->  d...
// _MulleStringEnumeratorUndoNext can be useful for parsers, who maintain
// look ahead
//
static inline BOOL   _MulleStringEnumeratorUndoNext( struct MulleStringEnumerator *rover,
                                                     unichar *c,
                                                     unichar *d)
{
   char   *q;

   if( MULLE_C_UNLIKELY( rover->_curr == rover->_start))
   {
      if( c)
         *c = -1;
      if( d)
         *d = 0;
      return( NO);
   }

   q = &((char *) rover->_curr)[ - (int) rover->_size * 2];

   if( MULLE_C_UNLIKELY( q < (char *) rover->_start))
   {
      if( c)
         *c = (rover->_curr != rover->_start) ? (*rover->_get)( rover->_start) : 0;
      if( d)
         *d = 0;
      rover->_curr = rover->_start;
      return( YES);
   }

   rover->_curr = q;
   if( d)
      *d = (*rover->_get)( rover->_curr);
   rover->_curr = &((char *) rover->_curr)[ rover->_size];
   if( c)
      *c = (*rover->_get)( rover->_curr);
   return( YES);
}



//
// "Previous" moves the rover character one character down (if available)
// and reads the character.
//
//  v    v
// c..   c..
//
static inline BOOL
   MulleStringEnumeratorPrevious( struct MulleStringEnumerator *rover,
                                  unichar *c)
{
   if( ! rover)
      return( NO);

   if( MULLE_C_UNLIKELY( rover->_curr == rover->_start))
      return( NO);

   rover->_curr = &((char *) rover->_curr)[ - (int) rover->_size];
   if( c)
      *c = (*rover->_get)( rover->_curr);
   return( YES);
}


//
// The next "previous" will return what the previous "previous" returned..
//
static inline BOOL
   _MulleStringEnumeratorUndoPrevious( struct MulleStringEnumerator *rover,
                                       unichar *c,
                                       unichar *d)
{
   char   *q;

   if( MULLE_C_UNLIKELY( rover->_curr == rover->_sentinel))
   {
      if( c)
         *c = -1;
      if( d)
         *d = 0;
      return( NO);
   }

   q = &((char *) rover->_curr)[ rover->_size];

   if( MULLE_C_UNLIKELY( q == (char *) rover->_sentinel))
   {
      // so we are at the beginning now, with nothing read
      if( c)
         *c = 0;
      if( d)
         *d = 0;
      rover->_curr = q;
      return( YES);
   }

   rover->_curr = q;
   if( c)
      *c = (*rover->_get)( rover->_curr);

   q = &((char *) rover->_curr)[ rover->_size];
   if( d)
      *d = (q < (char *) rover->_sentinel) ? (*rover->_get)( q) : 0;
   return( YES);
}


static inline BOOL   MulleStringEnumeratorHasCharacters( struct MulleStringEnumerator *rover)
{
   if( ! rover)
      return( NO);

   return( rover->_curr < rover->_sentinel);
}


static inline NSUInteger   MulleStringEnumeratorGetIndex( struct MulleStringEnumerator *rover)
{
   unsigned int   shift;

   if( ! rover)
      return( 0);

   shift = (unsigned int) rover->_size >> 1;  // 4->2  2->1  1->0
   return( ((char *) rover->_curr - (char *) rover->_start) >> shift);
}



static inline void   MulleStringEnumeratorDone( struct MulleStringEnumerator *rover)
{
}




// because `s` could be a constant string, we play off `c` to generate
// unique identifiers, as this has to be a variable

#define MulleStringFor( s, c)                                              \
   assert( sizeof( c) == sizeof( unichar));                                \
   for( struct MulleStringEnumerator   rover__ ## c,                       \
           *rover___  ## c ## __i = (_MulleStringEnumeratorInit( &rover__ ## c, s), (void *) 0); \
        ! rover___  ## c ## __i;                                           \
        rover___ ## c ## __i = (MulleStringEnumeratorDone( &rover__ ## c), \
                               (void *) 1))                                \
      while( MulleStringEnumeratorNext( &rover__ ## c, &c))


#define MulleStringReverseFor( s, c)                                       \
   assert( sizeof( c) == sizeof( unichar));                                \
   for( struct MulleStringEnumerator   rover__ ## c,                       \
           *rover___  ## c ## __i = (_MulleStringEnumeratorInitReverse( &rover__ ## c, s), (void *) 0); \
        ! rover___  ## c ## __i;                                           \
        rover___ ## c ## __i = (MulleStringEnumeratorDone( &rover__ ## c), \
                               (void *) 1))                                \
      while( MulleStringEnumeratorPrevious( &rover__ ## c, &c))



#define MulleStringForGetEnumerator( c)   (&rover__ ## c)
