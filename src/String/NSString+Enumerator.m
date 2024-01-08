//
//  NSString.m
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
#import "NSString+Enumerator.h"

// std-c and dependencies
#import "import-private.h"



@implementation NSString( Enumerator)

// default can't do it
- (NSUInteger) _mulleFastGetData:(struct mulle_data *) data
{
   return( 0);
}


- (NSUInteger) mulleGetCharacters:(unichar *) buf
                        fromIndex:(NSUInteger) index
                        maxLength:(NSUInteger) maxLength
{
   NSUInteger   length;

   length = [self length];
   if( index >= length)
      return( 0);

   length -= index;
   if( length > maxLength)
      length = maxLength;

   [self getCharacters:buf
                 range:NSMakeRange( index, length)];
   return( length);
}


static unichar   mulle_get_char_as_unichar( void *s)
{
   return( (unichar) *(char *) s);
}


static unichar   mulle_get_utf16_as_unichar( void *s)
{
   return( (unichar) *(mulle_utf16_t *) s);
}


static unichar   mulle_get_utf32_as_unichar( void *s)
{
   return( (unichar) *(mulle_utf32_t *) s);
}



void   _MulleStringEnumeratorInit( struct MulleStringEnumerator *rover, NSString *s)
{
   NSUInteger          n;
   struct mulle_data   data;

   MULLE_C_ASSERT( sizeof( struct MulleStringEnumerator) <= 128);

   rover->_start    =
   rover->_curr     =
   rover->_sentinel = NULL;
   s                = [s mulleCompactedString];
   rover->_size     = [s _mulleFastGetData:&data];
   rover->_get      = mulle_get_utf32_as_unichar;

   if( rover->_size)
   {
      rover->_start    =
      rover->_curr     = data.bytes;
      rover->_sentinel = &((char *) data.bytes)[ data.length];

      if( rover->_size == sizeof( char))
         rover->_get = mulle_get_char_as_unichar;
      else
         if( rover->_size == sizeof( mulle_utf16_t))
            rover->_get = mulle_get_utf16_as_unichar;
      return;
   }

   n = [s mulleGetCharacters:rover->_buf
                   fromIndex:0
                   maxLength:MulleStringEnumeratorNumberOfCharacters];

   // if we get MulleStringEnumeratorNumberOfCharacters, then
   // `s` is not TPS, which can't be... (you'd need to resurrect
   // the paging code...)

   assert( n < MulleStringEnumeratorNumberOfCharacters);

   rover->_start    =
   rover->_curr     = rover->_buf;
   rover->_sentinel = &((unichar *) rover->_curr)[ n];
   rover->_size     = 4;
}


- (NSString *) mulleCompactedString
{
   return( self);
}

@end

