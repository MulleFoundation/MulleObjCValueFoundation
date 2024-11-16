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
#import "NSString.h"

// other files in this library
#import "NSString+Hash.h"
#import "NSString+ClassCluster.h"
#import "_MulleObjCValueTaggedPointer.h"
#import "_MulleObjCTaggedPointerChar5String.h"
#import "_MulleObjCTaggedPointerChar7String.h"
#import "_MulleObjCASCIIString.h"
#import "_MulleObjCUTF16String.h"
#import "_MulleObjCUTF32String.h"

// std-c and dependencies
#import "import-private.h"

#import <ctype.h>
#import <string.h>
#import <MulleObjC/mulle-objc-universefoundationinfo-private.h>

#if MULLE__UTF_VERSION < ((1 << 20) | (0 << 8) | 0)
# error "mulle_utf is too old"
#endif


@implementation NSObject( _NSString)

- (BOOL) __isNSString
{
   return( NO);
}

@end


@interface NSObject( Initialize)

+ (void) initialize;

@end


@implementation NSString

#pragma mark - Patch string class into runtime

static char   *stringToUTF8( NSString *s)
{
   return( [s UTF8String]);
}


// keep global for gdb
MULLE_C_NEVER_INLINE
NSString  *_NSNewStringFromCString( char *s)
{
   return( [[NSString alloc] initWithUTF8String:s]);
}


static NSString   *UTF8ToString( char *s)
{
   return( [_NSNewStringFromCString(  s) autorelease]);
}


+ (void) load
{
   struct _mulle_objc_universefoundationinfo   *config;

   config = _mulle_objc_universe_get_universefoundationinfo( MulleObjCObjectGetUniverse( self));

   config->string.charsfromobject = (char *(*)( void *)) stringToUTF8;
   config->string.objectfromchars = (void *(*)( char *)) UTF8ToString;
}


- (BOOL) __isNSString
{
   return( YES);
}


# pragma mark - Class cluster support

// here and not in +Classcluster for +initialize

enum _NSStringClassClusterStringSize
{
   _NSStringClassClusterStringSize0         = 0,
   _NSStringClassClusterStringSizeOther     = 1,
   _NSStringClassClusterStringSize256OrLess = 2,
#ifdef HAVE_FIXED_LENGTH_ASCII_SUBCLASSES
   _NSStringClassClusterStringSize3         = 3,
   _NSStringClassClusterStringSize7         = 4,
   _NSStringClassClusterStringSize11        = 5,
   _NSStringClassClusterStringSize15        = 6,
#endif
   _NSStringClassClusterStringSizeMax
};


//
// it is useful for coverage, to make all possible subclasses known here
// Otherwise someone might only test with 255 bytes strings and it
// will crash with larger byte strings. Arguably that's something that should
// be tested, but _MulleObjC11LengthASCIIString may be fairly obscure to hit
// though.
//
+ (void) initialize
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;

   if( self != [NSString class])
      return;

   // no need for this
   // [super initialize]; // get MulleObjCClassCluster initialize

   assert( _MULLE_OBJC_FOUNDATIONINFO_N_STRINGSUBCLASSES >= _NSStringClassClusterStringSizeMax);

   universe = MulleObjCObjectGetUniverse( self);
   config   = _mulle_objc_universe_get_universefoundationinfo( universe);

   //
   // as we are the root class of this class cluster, we initialize before the
   // others. So we don't want to trigger subclasses +initialize with "class"
   // because that would recurse down back to us.
   //
   config->stringsubclasses[ 0] = NULL;
   config->stringsubclasses[ _NSStringClassClusterStringSize256OrLess] =
      mulle_objc_universe_lookup_infraclass_nofail( universe, @selector( _MulleObjCTinyASCIIString));
   config->stringsubclasses[ _NSStringClassClusterStringSizeOther]     =
      mulle_objc_universe_lookup_infraclass_nofail( universe, @selector( _MulleObjCGenericASCIIString));

#ifdef HAVE_FIXED_LENGTH_ASCII_SUBCLASSES
   config->stringsubclasses[ _NSStringClassClusterStringSize3]  =
      mulle_objc_universe_lookup_infraclass_nofail( universe, @selector( _MulleObjC03LengthASCIIString));
   config->stringsubclasses[ _NSStringClassClusterStringSize7]  =
      mulle_objc_universe_lookup_infraclass_nofail( universe, @selector( _MulleObjC07LengthASCIIString));
   config->stringsubclasses[ _NSStringClassClusterStringSize11] =
      mulle_objc_universe_lookup_infraclass_nofail( universe, @selector( _MulleObjC11LengthASCIIString));
   config->stringsubclasses[ _NSStringClassClusterStringSize15] =
      mulle_objc_universe_lookup_infraclass_nofail( universe, @selector( _MulleObjC15LengthASCIIString));
#endif
}


#pragma mark - class cluster selection

static enum _NSStringClassClusterStringSize   MulleObjCStringClassIndexForLength( NSUInteger length)
{
   //
   // if we hit the length exactly then avoid adding extra 4 zero bytes
   // by using subclass. Diminishing returns with larger strings...
   // Depends also on the granularity of the mallocer
   //
   switch( length)
   {
      case 00 : return( _NSStringClassClusterStringSize0);
#ifdef HAVE_FIXED_LENGTH_ASCII_SUBCLASSES
      case 03 : return( _NSStringClassClusterStringSize3);
      case 07 : return( _NSStringClassClusterStringSize7);
      case 11 : return( _NSStringClassClusterStringSize11);
      case 15 : return( _NSStringClassClusterStringSize15);
#endif
   }
   if( length < 0x100 + 1)
      return( _NSStringClassClusterStringSize256OrLess);
   return( _NSStringClassClusterStringSizeOther);
}


//
// TODO: need a function for ZeroTerminated ASCII string
//
NSString  *_MulleObjCNewASCIIStringWithASCIICharacters( char *s,
                                                        NSUInteger length,
                                                        struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_universefoundationinfo   *config;
   enum _NSStringClassClusterStringSize        classIndex;

   classIndex = MulleObjCStringClassIndexForLength( length);
   assert( classIndex);

   config = _mulle_objc_universe_get_universefoundationinfo( universe);
   return( [(Class) config->stringsubclasses[ classIndex] newWithASCIICharacters:s
                                                                          length:length]);
}


NSString  *_MulleObjCNewASCIIStringWithUTF32Characters( mulle_utf32_t *s,
                                                        NSUInteger length,
                                                        struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_universefoundationinfo   *config;
   enum _NSStringClassClusterStringSize        classIndex;

   classIndex = MulleObjCStringClassIndexForLength( length);
   assert( classIndex);

   config = _mulle_objc_universe_get_universefoundationinfo( universe);
   return( [(Class) config->stringsubclasses[ classIndex] newWithUTF32Characters:s
                                                                         length:length]);
}


# pragma mark - convenience constructors

// obsolete
+ (NSString *) string
{
   NSString   *obj;

   // written like this for debuggability (TAO)
   obj = [self alloc];
   obj = [obj init];
   obj = [obj autorelease];
   return( obj);
}


+ (instancetype) stringWithCharacters:(unichar *) s
                               length:(NSUInteger) len;
{
   NSString   *obj;

   // written like this for debuggability (TAO)
   obj = [self alloc];
   obj = [obj initWithCharacters:s
                          length:len];
   obj = [obj autorelease];
   return( obj);
}


+ (instancetype) mulleStringWithCharactersNoCopy:(unichar *) s
                                          length:(NSUInteger) len
                                       allocator:(struct mulle_allocator *) allocator;
{
   NSString   *obj;

   // written like this for debuggability (TAO)
   obj = [self alloc];
   obj = [obj mulleInitWithCharactersNoCopy:s
                                    length:len
                                 allocator:allocator];
   obj = [obj autorelease];
   return( obj);
}


// keep UTF8String: as (char *)
+ (instancetype) stringWithUTF8String:(char *) s
{
   NSString   *obj;

   // written like this for debuggability (TAO)
   obj = [self alloc];
   obj = [obj initWithUTF8String:s];
   obj = [obj autorelease];
   return( obj);
}


+ (instancetype) mulleStringWithUTF8Characters:(char *) s
                                        length:(NSUInteger) len
{
   NSString   *obj;

   // written like this for debuggability (TAO)
   obj = [self alloc];
   obj = [obj mulleInitWithUTF8Characters:s
                                   length:len];
   obj = [obj autorelease];
   return( obj);
}


+ (instancetype) mulleStringWithUTF8CharactersNoCopy:(char *) s
                                              length:(NSUInteger) len
                                           allocator:(struct mulle_allocator *) allocator
{
   assert( s);
   assert( len);
   NSString   *obj;

   // written like this for debuggability (TAO)
   obj = [self alloc];
   obj = [obj mulleInitWithUTF8CharactersNoCopy:s
                                         length:len
                                      allocator:allocator];
   obj = [obj autorelease];
   return( obj);
}


+ (instancetype) stringWithString:(NSString *) s

{
   NSString   *obj;

   // written like this for debuggability (TAO)
   obj = [self alloc];
   obj = [obj initWithString:s];
   obj = [obj autorelease];
   return( obj);
}


#pragma mark - generic init

- (instancetype) init
{
   // subclasses (e.g. NSMutableString must implement init)
   assert( [self class] == [NSString class]);
   return( [self initWithUTF8String:""]);
}


- (instancetype) initWithString:(NSString *) other
{
   char   *s;

   assert( [self __isClassClusterObject]);

   s = [other UTF8String];
   return( [self initWithUTF8String:s]);
}


#pragma mark - generic code


- (NSString *) stringValue
{
   return( self);
}


- (NSString *) description
{
   return( self);
}


- (NSString *) mulleDebugContentsDescription      MULLE_OBJC_THREADSAFE_METHOD
{
   return( self);
}


MULLE_C_NEVER_INLINE
struct mulle_utf8data  MulleStringUTF8Data( NSString *self,
                                               struct mulle_utf8data space)
{
   struct mulle_utf8data   data;

   if( [self mulleFastGetUTF8Data:&data])
      return( data);

   if( space.length >= 4)
   {
      // for TPS and other small strings try to grab into local area
      data.length = [self mulleGetUTF8Characters:(char *) space.characters
                                       maxLength:space.length];

      // If we are unlucky, than the following scenario pans out. We have a
      // space = 6 and our string is abc\xx\xx\xx\xx. So we will only get 3 back.
      // We have to reduce the space.length by the worst case to figure out if the
      // string was truncated. Worst case is 4. So reduce space.length by 3
      // truncated. TODO: for combined emoji we would need to fix thisif
      // mulleGetUTF8Characters:maxLength: becomes smarter.
      //
      if( data.length < space.length - 3)
      {
         data.characters = space.characters;
         return( data);
      }
   }

   // probably exhausted so use painful slow code
   data.characters = [self UTF8String];
   data.length     = [self mulleUTF8StringLength];

   return( data);
}


// - (NSUInteger) mulleGetUTF8Characters:(char *) buf
//                             maxLength:(NSUInteger) maxLength
// {
//    struct mulle_utf8data   data;
//    NSUInteger               length;
//
//    data   = MulleStringUTF8Data( self,
//                                     mulle_utf8data_make( buf, maxLength));
//    length = data.length <= maxLength ? data.length : maxLength;
//    if( data.characters != buf)
//       memcpy( buf, data.characters, length);
//    assert( ! memchr( buf, 0, length));
//    return( length);
// }


- (NSUInteger) mulleGetUTF8Characters:(char *) buf
                            maxLength:(NSUInteger) maxLength
                                range:(NSRange) range
{
   NSString   *s;

   s = [self substringWithRange:range];
   return( [s mulleGetUTF8Characters:buf
                           maxLength:maxLength]);
}


//
// string always zero terminates
// buffer must be large enough to contain maxLength - 1 chars plus a
// terminating zero char (which this method adds).
//
- (NSUInteger) mulleGetUTF8String:(char *) buf
                       bufferSize:(NSUInteger) size
{
   NSUInteger   length;

   assert( buf);

   length = [self mulleGetUTF8Characters:buf
                               maxLength:size];
   if( length >= size)
      length = size - 1;
   buf[ length] = 0;

   return( length);
}


- (void) mulleGetUTF8String:(char *) buf
{
   [self mulleGetUTF8String:buf
                 bufferSize:ULONG_MAX];
}


- (void) mulleGetUTF8Characters:(char *) buf
{
   [self mulleGetUTF8Characters:buf
                      maxLength:LONG_MAX];
}


- (void) getCharacters:(unichar *) buf
{
   [self getCharacters:buf
                 range:NSRangeMake( 0, [self length])];  // don't use -1!
}


- (BOOL) mulleFastGetASCIIData:(struct mulle_asciidata *) space
{
   return( NO);
}

//
// this could be non-ascii in case of compiler generated strings
//
- (BOOL) mulleFastGetUTF8Data:(struct mulle_utf8data *) space
{
   return( NO);
}


- (BOOL) mulleFastGetUTF16Data:(struct mulle_utf16data *) space
{
   return( NO);
}


- (BOOL) mulleFastGetUTF32Data:(struct mulle_utf32data *) space
{
   return( NO);
}


- (char *) UTF8String
{
   // backwards compatibility, actual subclasses SHOULD override
   char           *buf;
   char           *dst;
   NSUInteger     length;
   NSUInteger     size;
   NSUInteger     used;
   unichar        *src;
   unichar        *sentinel;
   unichar        c;

   length = [self length];

   // allocator NULL ? Well the block doesn't really belong to the class as an
   // instance variable, so...
   size = length * 4 + 1; // unichar explodes max to 4 bytes
   buf  = mulle_allocator_malloc( NULL, size);
   [self getCharacters:(unichar *) buf
                 range:NSRangeMake( 0, length)];

   // mulle_utf32_t can't become larger than 4 bytes max
   // so we can actually inplace convert

   assert( sizeof( unichar) >= 4);

   src      = (unichar *) buf;
   sentinel = &src[ length];
   dst      = buf;

   while( src < sentinel)
   {
      c   = *src++;
      dst = mulle_utf32_as_utf8( c, dst);
   }
   *dst = 0;

   used = dst - buf;
   if( size - used >= 64)  // don't care about waste on small strings
      buf = mulle_allocator_realloc( NULL, buf, used + 1);

   MulleObjCAutoreleaseAllocation( buf, NULL);
   return( buf);
}


- (NSUInteger) mulleUTF8StringLength
{
   return( strlen( [self UTF8String]));
}


+ (BOOL) mulleAreValidUTF8Characters:(char *) buf
                              length:(NSUInteger) len
{
   struct mulle_utf_information  info;

   if( mulle_utf8_information( buf, len, &info))
      return( NO);

   return( YES);
}


#pragma mark - substringing

/*
 * memo: for substringing, we know that the contents are sane, therefore
 * the sanitization steps should be skipped. This is more or less the task
 * of the string subclasses though.
 */
- (NSString *) substringFromIndex:(NSUInteger) index
{
   NSRange   range;

   range = NSRangeMake( index, [self length] - index);
   return( [self substringWithRange:range]);
}


- (NSString *) substringToIndex:(NSUInteger) index
{
   NSRange   range;

   range = NSRangeMake( 0, index);
   return( [self substringWithRange:range]);
}


- (NSString *) substringWithRange:(NSRange) range
{
   struct mulle_allocator   *allocator;
   void                     *bytes;
   NSUInteger               length;

   length = [self length];
   range  = MulleObjCValidateRangeAgainstLength( range, length);

   if( ! range.location && range.length == length)
      return( self);

   if( ! range.length)
      return( @"");

   allocator = MulleObjCInstanceGetAllocator( self);
   bytes     = mulle_allocator_malloc( allocator, range.length * sizeof( unichar));

   [self getCharacters:bytes
                 range:range];

   return( [[[NSString alloc] mulleInitWithCharactersNoCopy:bytes
                                                     length:range.length
                                                  allocator:allocator] autorelease]);
}


// subclasses oughta override this, but NSMutableString uses it
- (NSUInteger) hash
{
   NSRange      range;
   NSUInteger   length;

   length = [self length];
   range  = MulleObjCGetHashStringRange( length);
   {
      unichar   tmp[ range.length];

      [self getCharacters:tmp
                    range:range];
      range.location = 0;
      return( MulleObjCStringHashRangeUTF32( tmp, range));
   }
}


//***************************************************
// LAYER 4 - code that works "optimally" on all
//           subclasses and probably need not be
//           overridden
//***************************************************
/*
 * some generic stuff, irregardless of UTF or C
 */

#pragma mark - hash and equality

- (BOOL) isEqual:(id) other
{
   if( self == other)
      return( YES);
   if( ! [other __isNSString])
      return( NO);
   return( [self isEqualToString:other]);
}


static BOOL   hasPrefix( NSString *self, NSString *prefix, NSUInteger prefixLength)
{
   auto unichar   buf[ 32];
   auto unichar   prefix_buf[ 32];
   NSRange        range;

   range.location = 0;
   while( prefixLength)
   {
      range.length = prefixLength > 32 ? 32 : prefixLength;
      [self getCharacters:buf
                    range:range];
      [prefix getCharacters:prefix_buf
                      range:range];
      if( memcmp( prefix_buf, buf, range.length * sizeof( unichar)))
         return( NO);

      prefixLength   -= range.length;
      range.location += range.length;
   }
   return( YES);
}


static BOOL   hasSuffix( NSString *self, NSUInteger length,
                         NSString *suffix, NSUInteger suffixLength)
{
   auto unichar   suffix_buf[ 32];
   auto unichar   buf[ 32];
   NSRange        range;
   NSRange        suffixRange;

   assert( suffixLength <= length);

   range.location       = length - suffixLength;
   range.length         = suffixLength;
   suffixRange.location = 0;
   suffixRange.length   = suffixLength;

   while( suffixLength)
   {
      range.length = suffixLength > 32 ? 32 : suffixLength;
      [self getCharacters:buf
                    range:range];
      [suffix getCharacters:suffix_buf
                      range:suffixRange];
      if( memcmp( suffix_buf, buf, range.length * sizeof( unichar)))
         return( NO);

      suffixLength         -= range.length;
      range.location       += range.length;
      suffixRange.location += suffixRange.length;
   }
   return( YES);
}



- (BOOL) isEqualToString:(NSString *) other
{
   NSUInteger   length;

   length = [self length];
   if( length != [other length])
      return( NO);

   return( hasPrefix( self, other, length));
}


- (id) copy
{
   return( [self retain]);
}



#pragma mark - simplest substring

- (BOOL) hasPrefix:(NSString *) prefix
{
   NSUInteger   prefixLength;
   NSUInteger   length;

   length       = [self length];
   prefixLength = [prefix length];
   if( length < prefixLength)
      return( NO);

   return( hasPrefix( self, prefix, prefixLength));
}


- (BOOL) hasSuffix:(NSString *) suffix
{
   NSUInteger   suffixLength;
   NSUInteger   length;

   length       = [self length];
   suffixLength = [suffix length];
   if( length < suffixLength)
      return( NO);

   return( hasSuffix( self, length, suffix, suffixLength));
}


#pragma mark - numerical values

static char   *mulleUTF8StringWithLeadingSpacesRemoved( NSString *self)
{
   char      *s;
   char      *old;
   unichar   c;

   s = [self UTF8String];
   assert( s);

   while( *s)
   {
      old = s;
      c   = _mulle_utf8_next_utf32character( &s);

      if( ! isspace( c))
         return( old);
   }
   return( s);
}


//
// the C functions are assumed to work with ASCII only anyway
//
- (double) doubleValue
{
   return( strtod( (char *) mulleUTF8StringWithLeadingSpacesRemoved( self), NULL));
}


- (long double) mulleLongDoubleValue
{
   return( strtold( (char *) mulleUTF8StringWithLeadingSpacesRemoved( self), NULL));
}


- (float) floatValue
{
   return( strtof( (char *) mulleUTF8StringWithLeadingSpacesRemoved( self), NULL));
}


- (int) intValue
{
   return( (int) strtol( (char *) mulleUTF8StringWithLeadingSpacesRemoved( self), NULL, 0));
}


- (long long) longLongValue
{
   return( strtoll( (char *) mulleUTF8StringWithLeadingSpacesRemoved( self), NULL, 0));
}


- (NSInteger) integerValue
{
   return( strtol( (char *) mulleUTF8StringWithLeadingSpacesRemoved( self), NULL, 0));
}


- (BOOL) boolValue
{
   char  *s;

   s = (char *) mulleUTF8StringWithLeadingSpacesRemoved( self);

   if( *s == '+' || *s == '-')
      ++s;
   while( *s == '0')
      ++s;

   switch( *s)
   {
   case '1' :
   case '2' :
   case '3' :
   case '4' :
   case '5' :
   case '6' :
   case '7' :
   case '8' :
   case '9' :
   case 'Y' :
   case 'y' :
   case 'T' :
   case 't' :
      return( YES);
   }
   return( NO);
}


@end


