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
#import "import.h"

enum
{
   NSCaseInsensitiveSearch         = 0x001,
   NSLiteralSearch                 = 0x002,
   NSBackwardsSearch               = 0x004,
   NSAnchoredSearch                = 0x008,
   NSNumericSearch                 = 0x040,
};
typedef NSUInteger   NSStringCompareOptions;


typedef mulle_utf32_t  unichar;

#include "mulle-chardata.h"


//
// NSString is outside of NSObject, the most fundamental class
// since its totally pervasive in all other classes.
// The implementation in MulleObjCValueFoundation is slightly schizophrenic.
// On the character level anything below UTF-32 is just misery.
// But UTF-8 is what is being used for I/O almost exclusively.
//
// The MulleObjCValueFoundation deals with UTF32 and UTF8.
// UTF-16 is treated just an optimized storage medium for UTF32 strings.
//
// A CString is a string with a zero terminator in the character set of the
// current C locale. This particular library (MulleObjCValueFoundation)
// does not deal with locales, so the concept is postponed until POSIX is
// introduced (MulleObjCOSFoundation). (Truth be told, c locales suck)
//
// To support unichar somewhat efficiently
//
//    o make unichar UTF-32
//    o store strings in three formats only!!!
//        1. ASCII (7 bit)
//        2. UTF-16 (15 bit only) (w/o surrogate pairs)
//        3. UTF-32, everything else
//
// As an external exchange format UTF8 is the law, forget the others.
//

//
// When dealing with the filesystem (open/stat) use -fileSystemRepresentation
// defined by a layer upwards of MulleObjCValueFoundation
// when interfacing with the OS (log messages) or C use cString
// in all other cases use UTF8String
//

@interface NSString : NSObject < MulleObjCClassCluster, NSCopying, MulleObjCValue>
{
}

// obsolete convenience: use +object!, must be typed for NSScanner ...
+ (instancetype) string;

// As it turns out for class clusters, instance type is not really helpful
// when implementing a subclass as you may want to return a class of a different
// class (e.g. @"" from [AString new] as length is 0).
// As NSMutableString is a subclass of NSString, a type of NSString
// is also not helpful for initWithString: which can be used by both. The
// solution is to type it to "id" or re-declare everything in NSMutableString.
//
+ (instancetype) stringWithString:(NSString *) other;

- (instancetype) initWithString:(NSString *) s;

- (NSString *) description;

- (NSString *) substringWithRange:(NSRange) range;
- (NSString *) substringFromIndex:(NSUInteger) index;
- (NSString *) substringToIndex:(NSUInteger) index;

- (BOOL) boolValue;
- (int) intValue;
- (NSInteger) integerValue;
- (long long) longLongValue;

- (float) floatValue;
- (double) doubleValue;
- (long double) mulleLongDoubleValue;

- (BOOL) isEqualToString:(NSString *) other;

//
// UTF32
//
+ (instancetype) stringWithCharacters:(unichar *) s
                               length:(NSUInteger) len;

- (void) getCharacters:(unichar *) buffer;

//
// UTF8
// keep "old" UTF8Strings methods using char *
+ (instancetype) stringWithUTF8String:(char *) s;

- (char *) UTF8String;


- (BOOL) hasPrefix:(NSString *) prefix;
- (BOOL) hasSuffix:(NSString *) suffix;

@end


@interface NSString( MulleAdditions)

- (NSUInteger) mulleUTF8StringLength;

// returns NO, if ASCII data could not be provided. You will get pointers
// into private memory, which is not necessarily 0 terminated
- (BOOL) mulleFastGetASCIIData:(struct mulle_asciidata *) space;

// returns NO, if UTF8 data can not be provided w/o conversion.
// You will get pointers into private memory, which is not necessarily
// 0 terminated.

- (BOOL) mulleFastGetUTF8Data:(struct mulle_utf8data *) space;
- (BOOL) mulleFastGetUTF16Data:(struct mulle_utf16data *) space;
- (BOOL) mulleFastGetUTF32Data:(struct mulle_utf32data *) space;


+ (instancetype) mulleStringWithCharactersNoCopy:(unichar *) s
                                          length:(NSUInteger) len
                                       allocator:(struct mulle_allocator *) allocator;
+ (instancetype) mulleStringWithUTF8CharactersNoCopy:(char *) s
                                              length:(NSUInteger) len
                                           allocator:(struct mulle_allocator *) allocator;

//
// UTF8
// keep "old" UTF8Strings methods using char *
+ (instancetype) mulleStringWithUTF8Characters:(char *) s
                                        length:(NSUInteger) len;

// characters are not zero terminated
- (void) mulleGetUTF8Characters:(char *) buf;

// returns actual UTF8 length
- (NSUInteger) mulleGetUTF8Characters:(char *) buf
                            maxLength:(NSUInteger) maxLength;
- (NSUInteger) mulleGetUTF8Characters:(char *) buf
                            maxLength:(NSUInteger) maxLength
                                range:(NSRange) range;

+ (BOOL) mulleAreValidUTF8Characters:(char *) buffer
                          length:(NSUInteger) length;

// strings are zero terminated, zero stored in
// buf[ size - 1]
//
- (NSUInteger) mulleGetUTF8String:(char *) buf
                       bufferSize:(NSUInteger) size;
- (void) mulleGetUTF8String:(char *) buf;

@end


@interface NSString( Subclasses)

- (unichar) :(NSUInteger) index;
- (unichar) characterAtIndex:(NSUInteger) index;
- (NSUInteger) length;

- (void) getCharacters:(unichar *) buffer
                 range:(NSRange) range;
- (NSUInteger) mulleGetUTF8Characters:(char *) buffer
                            maxLength:(NSUInteger) length;

@end


@interface NSString ( Future)

- (NSString *) stringByAppendingString:(NSString *) other;

- (NSString *) stringByPaddingToLength:(NSUInteger) length
                            withString:(NSString *) other
                       startingAtIndex:(NSUInteger) index;

- (NSString *) stringByReplacingOccurrencesOfString:(NSString *) search
                                         withString:(NSString *) replacement
                                            options:(NSUInteger) options
                                              range:(NSRange) range;

- (NSString *) stringByReplacingOccurrencesOfString:(NSString *) search
                                         withString:(NSString *) replacement;

- (NSString *) stringByReplacingCharactersInRange:(NSRange) range
                                       withString:(NSString *) replacement;


// if prefix or suffix don't match, return self, otherwise the substring
- (NSString *) mulleStringByRemovingPrefix:(NSString *) other;
- (NSString *) mulleStringByRemovingSuffix:(NSString *) other;

@end


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


//
// A safe version to get converted or raw UTF8 characters from a string.
// The returned data always represents the whole string, space may be used
// for temporary storage, but may not if its too small. Therefore the returned
// data is only valid as long as space isn't touched
//
MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
struct mulle_utf8data   MulleStringGetUTF8Data( NSString *self,
                                                struct mulle_utf8data space);

