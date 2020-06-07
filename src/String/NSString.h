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


//
// NSString is outside of NSObject, the most fundamental class
// since its totally pervasive in all other classes.
// The implementation in MulleObjCValueFoundation is slightly schizophrenic.
// On the character level anything below UTF-32 is just misery.
// But UTF-8 is basically what is being used (for I/O).
//
// The MulleObjCValueFoundation deals with UTF32 and UTF8.
// UTF-16 is treated just an optimized storage medium for UTF strings.
//
// A CString is a string with a zero terminator in the C locale,
// this particular library does not deal with locales, so the concept
// is postponed until POSIX is introduced. (Truth be told, c locales suck)
//
// To support unichar somewhat efficiently
//
//    o make unichar UTF-32
//    o store strings in three formats
//        1. ASCII (7 bit)
//        2. UTF-16 (15 bit only) (w/o surrogate pairs)
//        3. UTF-32, everything else
//    o strings that are not ASCII, store their UTF8 representation when
//      needed.
//
// As an external exchange format UTF8 is the law, forget the others.
//

//
// when dealing with the filesystem (open/stat) use -fileSystemRepresentation
// defined by a layer upwards of MulleObjCValueFoundation
// when interfacing with the OS (log messages) or C use cString
// in all other cases use UTF8String
//

@interface NSString : NSObject < MulleObjCClassCluster, NSCopying, MulleObjCValue>
{
}

+ (instancetype) string;
+ (instancetype) stringWithString:(NSString *) other;

- (instancetype) initWithString:(NSString *) s;

- (NSString *) description;

- (NSString *) substringWithRange:(NSRange) range;
- (NSString *) substringFromIndex:(NSUInteger) index;
- (NSString *) substringToIndex:(NSUInteger) index;

- (double) doubleValue;
- (float) floatValue;
- (int) intValue;
- (long long) longLongValue;
- (NSInteger) integerValue;
- (BOOL) boolValue;

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
- (BOOL) mulleFastGetASCIIData:(struct mulle_ascii_data *) space;

// returns NO, if UTF8 data can not be provided w/o conversion.
// You will get pointers into private memory, which is not necessarily
// 0 terminated.

- (BOOL) mulleFastGetUTF8Data:(struct mulle_utf8_data *) space;
- (BOOL) mulleFastGetUTF16Data:(struct mulle_utf16_data *) space;
- (BOOL) mulleFastGetUTF32Data:(struct mulle_utf32_data *) space;


+ (instancetype) mulleStringWithCharactersNoCopy:(unichar *) s
                                          length:(NSUInteger) len
                                       allocator:(struct mulle_allocator *) allocator;
+ (instancetype) mulleStringWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                              length:(NSUInteger) len
                                           allocator:(struct mulle_allocator *) allocator;

//
// UTF8
// keep "old" UTF8Strings methods using char *
+ (instancetype) mulleStringWithUTF8Characters:(mulle_utf8_t *) s
                                        length:(NSUInteger) len;

// characters are not zero terminated
- (void) mulleGetUTF8Characters:(mulle_utf8_t *) buf;

+ (BOOL) mulleAreValidUTF8Characters:(mulle_utf8_t *) buffer
                          length:(NSUInteger) length;

// strings are zero terminated, zero stored in
// buf[ size - 1]
//
- (NSUInteger) mulleGetUTF8String:(mulle_utf8_t *) buf
                       bufferSize:(NSUInteger) size;
- (void) mulleGetUTF8String:(mulle_utf8_t *) buf;

@end


@interface NSString( Subclasses)

- (unichar) :(NSUInteger) index;
- (unichar) characterAtIndex:(NSUInteger) index;
- (NSUInteger) length;

- (void) getCharacters:(unichar *) buffer
                 range:(NSRange) range;
- (NSUInteger) mulleGetUTF8Characters:(mulle_utf8_t *) buffer
                            maxLength:(NSUInteger) length;

@end


@interface NSString ( Future)

- (NSString *) stringByAppendingString:(NSString *) other;

- (instancetype) stringByPaddingToLength:(NSUInteger) length
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

// the
static inline NSUInteger   _mulle_fnv1a_utf8( mulle_utf8_t *buf, size_t len)
{
   return( _mulle_objc_fnv1a( buf, len));
}


uintptr_t   _mulle_fnv1a_utf16( mulle_utf16_t *buf, size_t len);
uintptr_t   _mulle_fnv1a_utf32( mulle_utf32_t *buf, size_t len);


static inline NSUInteger   MulleObjCStringHashRangeUTF8( mulle_utf8_t *buf, NSRange range)
{
   uintptr_t   hash;

   if( ! buf)
      return( -1);
   hash  = _mulle_fnv1a_utf8( &buf[ range.location], range.length);
   // hash = (hash << 4) | (hash >> (sizeof( uintptr_t) * 8 - 4));
   return( (NSUInteger) hash);
}


static inline NSUInteger   MulleObjCStringHashRangeASCII( char *buf, NSRange range)
{
   return( MulleObjCStringHashRangeUTF8( (mulle_utf8_t *) buf, range));
}


static inline NSUInteger   MulleObjCStringHashRangeUTF16( mulle_utf16_t *buf, NSRange range)
{
   uintptr_t   hash;

   if( ! buf)
      return( -1);
   hash = _mulle_fnv1a_utf16( &buf[ range.location], range.length);
   // hash = (hash << 4) | (hash >> (sizeof( uintptr_t) * 8 - 4));
   return( (NSUInteger) hash);
}


static inline NSUInteger   MulleObjCStringHashRangeUTF32( mulle_utf32_t *buf, NSRange range)
{
   uintptr_t   hash;

   if( ! buf)
      return( -1);
   hash = _mulle_fnv1a_utf32( &buf[ range.location], range.length);
   // hash = (hash << 4) | (hash >> (sizeof( uintptr_t) * 8 - 4));
   return( (NSUInteger) hash);
}


static inline NSUInteger   MulleObjCStringHashASCII( char *buf, NSUInteger length)
{
   NSRange   range;

   range = MulleObjCGetHashStringRange( length);
   return( MulleObjCStringHashRangeASCII( buf, range));
}


static inline NSUInteger   MulleObjCStringHashUTF8( mulle_utf8_t *buf, NSUInteger length)
{
   NSRange   range;

   range = MulleObjCGetHashStringRange( length);
   return( MulleObjCStringHashRangeUTF8( buf, range));
}


static inline NSUInteger   MulleObjCStringHashUTF16( mulle_utf16_t *buf, NSUInteger length)
{
   NSRange   range;

   range = MulleObjCGetHashStringRange( length);
   return( MulleObjCStringHashRangeUTF16( buf, range));
}


static inline NSUInteger   MulleObjCStringHashUTF32( mulle_utf32_t *buf, NSUInteger length)
{
   NSRange   range;

   range = MulleObjCGetHashStringRange( length);
   return( MulleObjCStringHashRangeUTF32( buf, range));
}


// a safe version to get converted or raw UTF8 characters from a string
struct mulle_utf8_data   MulleStringGetUTF8Data( NSString *self, struct mulle_utf8_data space);

