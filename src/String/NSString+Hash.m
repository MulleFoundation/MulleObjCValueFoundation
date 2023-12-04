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
#import "NSString+Hash.h"

// std-c and dependencies
#import "import-private.h"



#define FNV1A_32_PRIME   0x01000193
#define FNV1A_64_PRIME   0x0100000001b3ULL
#define FNV1A_32_INIT    0x811c9dc5
#define FNV1A_64_INIT    0xcbf29ce484222325ULL



uint32_t   _mulle_utf16_15bit_fnv1a_chained_32( mulle_utf16_t *buf, size_t len, uint32_t hash)
{
   mulle_utf16_t   *s;
   mulle_utf16_t   *sentinel;

   s        = buf;
   sentinel = &s[ len];

   /*
    * FNV-1A hash each octet in the buffer
    */
   while( s < sentinel)
   {
      hash ^= (uint32_t) *s++;
      hash *= FNV1A_32_PRIME;
   }

   return( hash);
}


uint64_t   _mulle_utf16_15bit_fnv1a_chained_64( mulle_utf16_t *buf, size_t len, uint64_t hash)
{
   mulle_utf16_t   *s;
   mulle_utf16_t   *sentinel;

   s        = buf;
   sentinel = &s[ len];

   /*
    * FNV-1 hash each octet in the buffer
    */
   while( s < sentinel)
   {
      hash ^= (uint64_t) *s++;
      hash *= FNV1A_64_PRIME;
   }

   return( hash);
}


uintptr_t   _mulle_utf16_15bit_fnv1a_chained( mulle_utf16_t *buf, size_t len, uintptr_t hash)
{
   if( sizeof( uintptr_t) == sizeof( uint32_t))
      return( (uintptr_t) _mulle_utf16_15bit_fnv1a_chained_32( buf, len, hash));
   return( (uintptr_t) _mulle_utf16_15bit_fnv1a_chained_64( buf, len, hash));
}


uint32_t   _mulle_utf32_fnv1a_chained_32( mulle_utf32_t *buf, size_t len, uint32_t hash)
{
   mulle_utf32_t   *s;
   mulle_utf32_t   *sentinel;

   s        = buf;
   sentinel = &s[ len];

   /*
    * FNV-1A hash each octet in the buffer
    */
   while( s < sentinel)
   {
      hash ^= (uint32_t) *s++;
      hash *= FNV1A_32_PRIME;
   }

   return( hash);
}


uint64_t   _mulle_utf32_fnv1a_chained_64( mulle_utf32_t *buf, size_t len, uint64_t hash)
{
   mulle_utf32_t   *s;
   mulle_utf32_t   *sentinel;

   s        = buf;
   sentinel = &s[ len];

   /*
    * FNV-1 hash each octet in the buffer
    */
   while( s < sentinel)
   {
      hash ^= (uint64_t) *s++;
      hash *= FNV1A_64_PRIME;
   }

   return( hash);
}


uintptr_t   _mulle_utf32_fnv1a_chained( mulle_utf32_t *buf, size_t len, uintptr_t hash)
{
   if( sizeof( uintptr_t) == sizeof( uint32_t))
      return( (uintptr_t) _mulle_utf32_fnv1a_chained_32( buf, len, hash));
   return( (uintptr_t) _mulle_utf32_fnv1a_chained_64( buf, len, hash));
}



static inline uint32_t   _mulle_utf16_15bit_fnv1a_32( mulle_utf16_t *buf, size_t len)
{
   return( _mulle_utf16_15bit_fnv1a_chained_32( buf, len, FNV1A_32_INIT));
}


static inline uint64_t   _mulle_utf16_15bit_fnv1a_64( mulle_utf16_t *buf, size_t len)
{
   return( _mulle_utf16_15bit_fnv1a_chained_64( buf, len, FNV1A_64_INIT));
}


uintptr_t   _mulle_utf16_15bit_fnv1a( mulle_utf16_t *buf, size_t len)
{
   if( sizeof( uintptr_t) == sizeof( uint32_t))
      return( (uintptr_t) _mulle_utf16_15bit_fnv1a_32( buf, len));
   return( (uintptr_t) _mulle_utf16_15bit_fnv1a_64( buf, len));
}


static inline uint32_t   _mulle_utf32_fnv1a_32( mulle_utf32_t *buf, size_t len)
{
   return( _mulle_utf32_fnv1a_chained_32( buf, len, FNV1A_32_INIT));
}


static inline uint64_t   _mulle_utf32_fnv1a_64( mulle_utf32_t *buf, size_t len)
{
   return( _mulle_utf32_fnv1a_chained_64( buf, len, FNV1A_64_INIT));
}


uintptr_t   _mulle_utf32_fnv1a( mulle_utf32_t *buf, size_t len)
{
   if( sizeof( uintptr_t) == sizeof( uint32_t))
      return( (uintptr_t) _mulle_utf32_fnv1a_32( buf, len));
   return( (uintptr_t) _mulle_utf32_fnv1a_64( buf, len));
}

