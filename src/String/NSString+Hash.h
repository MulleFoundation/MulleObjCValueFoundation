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


static inline NSRange   MulleObjCGetHashStringRange( NSUInteger length)
{
   NSUInteger   offset;

   offset = 0;
   if( length > 32)
   {
      offset = length - 32;
      length = 32;
   }
   return( NSMakeRange( offset, length));
}


//
// If these are defined elsewhere you can change the hash used for strings
// globally.
// TODO: move into own file

#ifndef mulle_hash_init32_nsstring
# define mulle_hash_init32_nsstring   0x811c9dc5 // 0x811c9dc5
#endif

#ifndef mulle_hash_init64_nsstring
# define mulle_hash_init64_nsstring   0xcbf29ce484222325ULL // NV1A_64_INIT
#endif


static inline uintptr_t   mulle_hash_init_nsstring( void)
{
   if( sizeof( uintptr_t) == sizeof( uint32_t))
      return( (uintptr_t) mulle_hash_init32_nsstring);
   return( (uintptr_t) mulle_hash_init64_nsstring);
}


#ifndef _mulle_ascii_hash_nsstring
# define _mulle_ascii_hash_nsstring           _mulle_fnv1a
#endif
#ifndef _mulle_ascii_hash_chained_nsstring
# define _mulle_ascii_hash_chained_nsstring   _mulle_fnv1a_chained
#endif

#ifndef _mulle_utf16_15bit_hash_nsstring
# define _mulle_utf16_15bit_hash_nsstring     _mulle_utf16_15bit_fnv1a
#endif
#ifndef _mulle_utf16_15bit_hash_chained_nsstring
# define _mulle_utf16_15bit_hash_chained_nsstring   _mulle_utf16_15bit_fnv1a_chained
#endif

#ifndef _mulle_utf32_hash_nsstring
# define _mulle_utf32_hash_nsstring           _mulle_utf32_fnv1a
#endif
#ifndef _mulle_utf32_hash_chained_nsstring
# define _mulle_utf32_hash_chained_nsstring   _mulle_utf32_fnv1a_chained
#endif

#ifndef _mulle_char5_hash_nsstring
# define _mulle_char5_hash_nsstring           _mulle_char5_fnv1a
#endif

#ifndef _mulle_char7_hash_nsstring
# define _mulle_char7_hash_nsstring           _mulle_char7_fnv1a
#endif


// mulle_utf16_t characters must be 15 bit and no surrogates
MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
uintptr_t   _mulle_utf16_15bit_fnv1a( mulle_utf16_t *buf, size_t len);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
uintptr_t   _mulle_utf16_15bit_fnv1a_chained( mulle_utf16_t *buf, size_t len, uintptr_t hash);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
uintptr_t   _mulle_utf32_fnv1a( mulle_utf32_t *buf, size_t len);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
uintptr_t   _mulle_utf32_fnv1a_chained( mulle_utf32_t *buf, size_t len, uintptr_t hash);


static inline NSUInteger   MulleObjCStringHashRangeASCII( char *buf, NSRange range)
{
   uintptr_t   hash;

   if( ! buf)
      return( -1);
   hash  = _mulle_ascii_hash_nsstring( &buf[ range.location], range.length);
   return( (NSUInteger) hash);
}


static inline NSUInteger   MulleObjCStringHashRangeUTF16Bit15( mulle_utf16_t *buf, NSRange range)
{
   uintptr_t   hash;

   if( ! buf)
      return( -1);
   hash = _mulle_utf16_15bit_hash_nsstring( &buf[ range.location], range.length);
   // hash = (hash << 4) | (hash >> (sizeof( uintptr_t) * 8 - 4));
   return( (NSUInteger) hash);
}


static inline NSUInteger   MulleObjCStringHashRangeUTF32( mulle_utf32_t *buf, NSRange range)
{
   uintptr_t   hash;

   if( ! buf)
      return( -1);
   hash = _mulle_utf32_hash_nsstring( &buf[ range.location], range.length);
   // hash = (hash << 4) | (hash >> (sizeof( uintptr_t) * 8 - 4));
   return( (NSUInteger) hash);
}


static inline NSUInteger   MulleObjCStringHashASCII( char *buf, NSUInteger length)
{
   NSRange   range;

   range = MulleObjCGetHashStringRange( length);
   return( MulleObjCStringHashRangeASCII( buf, range));
}


static inline NSUInteger   MulleObjCStringHashUTF16Bit15( mulle_utf16_t *buf, NSUInteger length)
{
   NSRange   range;

   range = MulleObjCGetHashStringRange( length);
   return( MulleObjCStringHashRangeUTF16Bit15( buf, range));
}


static inline NSUInteger   MulleObjCStringHashUTF32( mulle_utf32_t *buf, NSUInteger length)
{
   NSRange   range;

   range = MulleObjCGetHashStringRange( length);
   return( MulleObjCStringHashRangeUTF32( buf, range));
}
