//
//  NSData+NSString.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "NSData.h"

// other files in this library
#import "NSString.h"

// other libraries of MulleObjCValueFoundation

// std-c and dependencies
#import "import-private.h"

#include <ctype.h>


@implementation NSData( NSString)

static inline unsigned int   hex( unsigned int c)
{
   assert( c >= 0 && c <= 0xf);
   return( c >= 0xa ? c + 'a' - 0xa : c + '0');
}

#define WORD_SIZE   4

- (NSString *) stringValue
{
   NSUInteger               full_lines;
   NSUInteger               i;
   NSUInteger               j;
   NSUInteger               length;
   NSUInteger               lines;
   NSUInteger               remainder;
   char                     *s;
   struct mulle_allocator   *allocator;
   struct mulle_buffer      buffer;
   unsigned char            *bytes;
   unsigned int             value;
   struct mulle_data        data;

   length = [self length];
   if( ! length)
      return( @"<>");

   bytes     = [self bytes];
   allocator = MulleObjCInstanceGetAllocator( self);

   mulle_buffer_init_with_capacity( &buffer, length * 3, allocator);

   mulle_buffer_add_string( &buffer, "<");

   lines      = (length + WORD_SIZE - 1) / WORD_SIZE;
   full_lines = length / WORD_SIZE;

   for( i = 0; i < full_lines; i++)
   {
      s = mulle_buffer_advance( &buffer, 2 * WORD_SIZE);
      for( j = 0;  j < WORD_SIZE; j++)
      {
         value = *bytes++;

         *s++ = (char) hex( value >> 4);
         *s++ = (char) hex( value & 0xF);
      }
      mulle_buffer_add_byte( &buffer, ' ');
   }

   if( i < lines)
   {
      remainder = length - (full_lines * WORD_SIZE);
      s = mulle_buffer_advance( &buffer, 2 * remainder);
      for( j = 0;  j < remainder; j++)
      {
         value = *bytes++;

         *s++ = (char) hex( value >> 4);
         *s++ = (char) hex( value & 0xF);
      }
   }
   else
      mulle_buffer_remove_last_byte( &buffer);

   mulle_buffer_add_byte( &buffer, '>');
   mulle_buffer_add_byte( &buffer, 0);

   mulle_buffer_size_to_fit( &buffer);
   data = mulle_buffer_extract_data( &buffer);
   mulle_buffer_done( &buffer);

   return( [NSString mulleStringWithUTF8CharactersNoCopy:data.bytes
                                                  length:data.length
                                               allocator:allocator]);
}


- (NSString *) description
{
   return( [self stringValue]);
}


- (NSString *) debugDescription
{
   NSUInteger               length;
   struct mulle_allocator   *allocator;
   struct mulle_buffer      buffer;
   unsigned char            *bytes;
   struct mulle_data        data;

   length = [self length];
   if( ! length)
      return( @"<>");

   bytes     = [self bytes];
   allocator = MulleObjCInstanceGetAllocator( self);

   mulle_buffer_init_with_capacity( &buffer, length * 4, allocator);
   mulle_buffer_hexdump( &buffer, bytes, length, 0, 0);
   mulle_buffer_add_byte( &buffer, 0);
   data = mulle_buffer_extract_data( &buffer);
   mulle_buffer_done( &buffer);

   return( [NSString mulleStringWithUTF8CharactersNoCopy:data.bytes
                                                  length:data.length
                                               allocator:allocator]);
}


@end
