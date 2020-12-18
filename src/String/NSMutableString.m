//
//  NSMutableString.m
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
#import "NSMutableString.h"

// other files in this library
#import "NSString+ClassCluster.h"
#import "NSString+Sprintf.h"
#import "_MulleObjCUTF32String.h"
#import "_MulleObjCTaggedPointerChar7String.h"
#import "_MulleObjCTaggedPointerChar5String.h"

// other library private stuff

// std-c and dependencies
#import "import-private.h"


@implementation NSObject( _NSMutableString)

- (BOOL) __isNSMutableString
{
   return( NO);
}

@end


@implementation NSMutableString

- (BOOL) __isNSMutableString
{
   return( YES);
}


static void  flush_shadow( NSMutableString *self)
{
   MulleObjCObjectDeallocateMemory( self, self->_shadow);
   self->_shadow = NULL;
}

/*
 *
 */
static void   autoreleaseStorageStrings( NSMutableString *self)
{
   NSUInteger  n;

   n = self->_count;
   self->_count = 0;  // do it now, important for autoreleasepool checks

   _MulleObjCAutoreleaseObjects( self->_storage,
                                 n,
                                 MulleObjCObjectGetUniverse( self));
}


static void   sizeStorageWithCount( NSMutableString *self, unsigned int count)
{
   self->_size = count + count;
   if( self->_size < 4)
      self->_size = 4;

   self->_storage = MulleObjCObjectReallocateNonZeroedMemory( self,
                                                              self->_storage,
                                                              self->_size * sizeof( NSString *));
}


static void   copyStringsAndComputeLength( NSMutableString *self,
                                           NSString **strings,
                                           unsigned int count)
{
   NSUInteger  i;

   self->_length = 0;
   for( i = 0; i < count; i++)
   {
      self->_storage[ i]  = [strings[ i] copy];
      self->_length      += [strings[ i] length];
   }
   self->_count = count;
}


static void   initWithStrings( NSMutableString *self,
                               NSString **strings,
                               unsigned int count)
{
   sizeStorageWithCount( self, count);
   copyStringsAndComputeLength( self, strings, count);
}


static void   shrinkWithStrings( NSMutableString *self,
                                 NSString **strings,
                                 unsigned int count)
{
   autoreleaseStorageStrings( self);
   flush_shadow( self);

   if( count > self->_size || count < self->_size / 4)
      sizeStorageWithCount( self, count);

   copyStringsAndComputeLength( self, strings, count);
}


// as we are "breaking out" of the class cluster, use standard
// allocation

+ (instancetype) alloc
{
   return( NSAllocateObject( self, 0, NULL));
}


+ (instancetype) allocWithZone:(NSZone *) zone
{
   return( NSAllocateObject( self, 0, NULL));
}


- (instancetype) init
{
   return( self);
}


- (instancetype) initWithCapacity:(NSUInteger) n
{
   sizeStorageWithCount( self, (unsigned int) (n >> 1));
   return( self);
}


- (instancetype) initWithString:(NSString *) s
{
   if( s)
      initWithStrings( self, &s, 1);
   return( self);
}


- (instancetype) initWithStrings:(NSString **) strings
                           count:(NSUInteger) count
{
   if( count)
      initWithStrings( self, strings, (unsigned int) count);
   return( self);
}


#pragma mark - tedious code for all these NSString init calls


// need to implement all MulleObjCCStringPlaceholder does
- (instancetype) initWithFormat:(NSString *) format
                mulleVarargList:(mulle_vararg_list) arguments
{
   NSString  *s;

   s = [[NSString alloc] initWithFormat:format
                        mulleVarargList:arguments];
   if( ! s)
   {
      [self release];
      return( nil);
   }

   initWithStrings( self, &s, 1);
   [s release];

   return( self);
}


- (instancetype) initWithFormat:(NSString *) format
                      arguments:(va_list) args
{
   NSString  *s;

   s = [[NSString alloc] initWithFormat:format
                              arguments:args];
   if( ! s)
   {
      [self release];
      return( nil);
   }

   initWithStrings( self, &s, 1);
   [s release];

   return( self);
}



- (instancetype) initWithUTF8String:(char *) cStr
{
   NSString  *s;

   s = [[NSString alloc] initWithUTF8String:cStr];
   if( ! s)
   {
      [self release];
      return( nil);
   }

   initWithStrings( self, &s, 1);
   [s release];

   return( self);
}


- (instancetype) mulleInitWithUTF8Characters:(mulle_utf8_t *) chars
                                      length:(NSUInteger) length
{
   NSString  *s;

   s = [[NSString alloc] mulleInitWithUTF8Characters:chars
                                              length:length];
   if( ! s)
   {
      [self release];
      return( nil);
   }

   initWithStrings( self, &s, 1);
   [s release];

   return( self);
}


- (instancetype) mulleInitWithUTF8CharactersNoCopy:(mulle_utf8_t *) chars
                                            length:(NSUInteger) length
                                      freeWhenDone:(BOOL) flag
{
   NSString  *s;

   s = [[NSString alloc] mulleInitWithUTF8CharactersNoCopy:chars
                                                    length:length
                                              freeWhenDone:flag];
   if( ! s)
   {
      [self release];
      return( nil);
   }

   initWithStrings( self, &s, 1);
   [s release];

   return( self);
}


- (instancetype) mulleInitWithCharactersNoCopy:(unichar *) chars
                                        length:(NSUInteger) length
                                     allocator:(struct mulle_allocator *) allocator
{
   NSString  *s;

   s = [[NSString alloc] mulleInitWithCharactersNoCopy:chars
                                                length:length
                                             allocator:allocator];
   if( ! s)
   {
      [self release];
      return( nil);
   }

   initWithStrings( self, &s, 1);
   [s release];

   return( self);
}


- (instancetype) mulleInitWithUTF8CharactersNoCopy:(mulle_utf8_t *) chars
                                            length:(NSUInteger) length
                                         allocator:(struct mulle_allocator *) allocator
{
   NSString  *s;

   s = [[NSString alloc] mulleInitWithUTF8CharactersNoCopy:chars
                                                length:length
                                          allocator:allocator];
   if( ! s)
   {
      [self release];
      return( nil);
   }

   initWithStrings( self, &s, 1);
   [s release];

   return( self);
}


- (instancetype) mulleInitWithUTF8CharactersNoCopy:(mulle_utf8_t *) chars
                                            length:(NSUInteger) length
                                     sharingObject:(id) object
{
   NSString  *s;

   s = [[NSString alloc] mulleInitWithUTF8CharactersNoCopy:chars
                                                    length:length
                                             sharingObject:object];
   if( ! s)
   {
      [self release];
      return( nil);
   }

   initWithStrings( self, &s, 1);
   [s release];

   return( self);
}


- (instancetype) mulleInitWithCharactersNoCopy:(unichar *) chars
                                        length:(NSUInteger) length
                                 sharingObject:(id) object
{
   NSString  *s;

   s = [[NSString alloc] mulleInitWithCharactersNoCopy:chars
                                            length:length
                                     sharingObject:object];
   if( ! s)
   {
      [self release];
      return( nil);
   }

   initWithStrings( self, &s, 1);
   [s release];

   return( self);
}


#pragma mark - additional convenience constructors

+ (instancetype) stringWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}


- (void) dealloc
{
   MulleObjCMakeObjectsPerformRelease( _storage, _count);

   flush_shadow( self);

   MulleObjCObjectDeallocateMemory( self, self->_storage);
   [super dealloc];
}


#pragma mark - NSCopying

- (id) copy
{
   char                     *s;
   struct mulle_allocator   *allocator;
   unichar                  *buf;
   unichar                  tmp[ 64];

   if( ! _length)
      return( @"");

   // ez and cheap copy, use it
   if( self->_count == 1)
      return( (id) [self->_storage[ 0] copy]);

   allocator = NULL;
   buf       = tmp;
   if( _length > 64)
   {
      allocator = MulleObjCInstanceGetAllocator( self);
      buf       = mulle_allocator_malloc( allocator, _length * sizeof( unichar));
   }
   [self getCharacters:buf];

   if( ! allocator)
   {
#ifdef __MULLE_OBJC_TPS__
      switch( _mulle_utf32_charinfo( tmp, _length))
      {
      case mulle_utf_is_char7 :
         return( MulleObjCTaggedPointerChar7StringWithCharacters( tmp,
                                                                  _length));
      case mulle_utf_is_char5 :
         return( MulleObjCTaggedPointerChar5StringWithCharacters( tmp,
                                                                  _length));
      default :
         break;
      }
#endif
      return( [_MulleObjCGenericUTF32String newWithUTF32Characters:buf
                                                            length:_length]);
   }

   return( [_MulleObjCAllocatorUTF32String newWithUTF32CharactersNoCopy:buf
                                                                 length:_length
                                                              allocator:allocator]);
}


#pragma mark - NSString subclassing

- (NSUInteger) length
{
   return( _length);
}


- (NSUInteger) mulleUTF8StringLength
{
   NSString     **p;
   NSString     **sentinel;
   NSUInteger   length;
   NSString     *s;

   if( _shadow)
      return( _shadowLen);

   length   = 0;
   p        = &_storage[ 0];
   sentinel = &p[ _count];
   while( p < sentinel)
      length += [*p++ mulleUTF8StringLength];
   return( length);
}


- (void) mulleCompact
{
   NSString   *s;

   if( self->_count < 2)
      return;

   // make one big string and use this has first string
   s = [[self copy] autorelease];
   shrinkWithStrings( self, &s, 1);
}


static unichar   characterAtIndex( NSMutableString *self, NSUInteger index)
{
   NSString     **p;
   NSString     **sentinel;
   NSUInteger   length;
   NSString     *s;

   //
   // If someone wants to do characterAtIndex: on a NSMutableString
   // it's going to be painful, if it is composed of many strings. We can make
   // it less painful, if we compact. We don't do this if someone just wants
   // to check the first 8 characters
   //
   if( index >= self->_length)
      MulleObjCThrowInvalidIndexException( index);

   if( index >= 8 && self->_count >= 8)
      [self mulleCompact];
   if( self->_length == 1)
      return( [self->_storage[ 0] characterAtIndex:index]);

   p        = &self->_storage[ 0];
   sentinel = &p[ self->_count];

   // find string containing character
   while( p < sentinel)
   {
      s      = *p++;
      length = [s length];
      if( index < length)
         break;

      index -= length;
   }
   return( [s characterAtIndex:index]);
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   return( characterAtIndex( self, index));
}


- (unichar) :(NSUInteger) index
{
   return( characterAtIndex( self, index));
}


- (void) getCharacters:(unichar *) buf
                 range:(NSRange) inRange
{
   NSString     **p;
   NSString     **sentinel;
   NSUInteger   length;
   NSString     *s;
   NSUInteger   grab_len;
   NSRange      range;

   range    = MulleObjCValidateRangeAgainstLength( inRange, _length);

   p        = &_storage[ 0];
   sentinel = &p[ _count];


   // `s` is first string with `length`
   // range is offset into s + remaining length

   while( range.length)
   {
      s      = *p++;
      length = [s length];

      if( range.location >= length)
      {
         range.location -= length;
         continue;
      }

      grab_len = range.length;
      if( range.location + grab_len > length)
         grab_len = length - range.location;

      [s getCharacters:buf
                 range:NSMakeRange( range.location, grab_len)];

      buf            = &buf[ grab_len];

      range.location = 0;
      range.length  -= grab_len;
   }
}


#pragma mark - Operations

- (void) _reset
{
   shrinkWithStrings( self, NULL, 0);
}


- (void) appendString:(NSString *) s
{
   size_t   len;

   // more convenient really to allow nil
   len = [s length];
   if( ! len)
      return;

   if( _count >= _size)
   {
      _size += _size;
      if( _size < 8)
         _size = 8;
      _storage = MulleObjCObjectReallocateNonZeroedMemory( self,
                                                           _storage,
                                                           _size * sizeof( NSString *));
   }

   _storage[ _count++] = [s copy];
   _length            += len;

   flush_shadow( self);
}


- (void) appendFormat:(NSString *) format, ...
{
   NSString            *s;
   mulle_vararg_list   args;

   mulle_vararg_start( args, format);
   s = [NSString stringWithFormat:format
                  mulleVarargList:args];
   mulle_vararg_end( args);
   [self appendString:s];
}


- (void) mulleAppendFormat:(NSString *) format
           mulleVarargList:(mulle_vararg_list) args
{
   NSString   *s;

   s = [NSString stringWithFormat:format
                  mulleVarargList:args];
   [self appendString:s];
}


- (void) mulleAppendFormat:(NSString *) format
                 arguments:(va_list) args
{
   NSString   *s;

   s = [NSString stringWithFormat:format
                        arguments:args];
   [self appendString:s];
}



- (void) mulleAppendCharacters:(unichar *) buf
                        length:(NSUInteger) length
{
   NSString   *s;

   s = [NSString stringWithCharacters:buf
                               length:length];
   if( s)
      [self appendString:s];
}


- (void) setString:(NSString *) aString
{
   shrinkWithStrings( self, &aString, aString ? 1 : 0);
}


// this is "non"-optimal, just some code to get by
- (void) deleteCharactersInRange:(NSRange) aRange
{
   [self replaceCharactersInRange:aRange
                       withString:@""];
}


//
// maybe overcomplicated: would it be better to make a new coherent
// buffer ?
//
- (void) replaceCharactersInRange:(NSRange) aRange
                       withString:(NSString *) replacement
{
   int           fromStart;
   int           toEnd;
   NSString      *s[ 3];
   unsigned int  i;
   NSRange       subRange;

  //
  // figure out range of substrings that fall in the range
  // create two subranges and add them to the array
  // remove the "split" original
  //
   fromStart = aRange.location == 0;
   toEnd     = aRange.length == [self length];

   i = 0;
   if( ! fromStart)
   {
      subRange.location = 0;
      subRange.length   = aRange.location;
      s[ i++]           = [self substringWithRange:NSMakeRange( 0, aRange.location)];
   }

   if( [replacement length])
      s[ i++] = replacement;

   if( ! toEnd)
   {
      subRange.location = aRange.location + aRange.length;
      subRange.length   = [self length] - subRange.location;
      s[ i++]           = [self substringWithRange:subRange];
   }

   shrinkWithStrings( self, s, i);
}


static void   mulleConvertStringsToUTF8( NSString **strings,
                                         unsigned int n,
                                         struct mulle_buffer *buffer)
{
   NSString       *s;
   mulle_utf8_t   *p;
   id             *sentinel;
   NSUInteger     len;

   sentinel = &strings[ n];
   while( strings < sentinel)
   {
      s   = *strings++;
      len = [s mulleUTF8StringLength];
      p   = mulle_buffer_advance( buffer, len);
      [s mulleGetUTF8Characters:p
                     maxLength:len];
   }
   mulle_buffer_add_byte( buffer, 0);
}


- (NSUInteger) mulleGetUTF8Characters:(mulle_utf8_t *) buf
                            maxLength:(NSUInteger) maxLength
{
   id             *sentinel;
   NSString       **strings;
   NSString       *s;
   NSUInteger     len;
   mulle_utf8_t   *p;

   strings  = _storage;
   sentinel = &strings[ _count];
   p        = buf;

   while( strings < sentinel)
   {
      s   = *strings++;
      len = [s mulleUTF8StringLength];
      if( len > maxLength)
         len = maxLength;

      [s mulleGetUTF8Characters:p
                      maxLength:len];

      p          = &p[ len];
      maxLength -= len;
      if( ! maxLength)
         break;
   }
   return( p - buf);
}


- (char *) UTF8String
{
   char                     tmp[ 0x400];
   struct mulle_allocator   *allocator;
   struct mulle_buffer      buffer;
   struct mulle_data        data;

   if( _shadow)
      return( (char *) _shadow);

   allocator = MulleObjCInstanceGetAllocator( self);

   mulle_buffer_init_with_static_bytes( &buffer, tmp, sizeof( tmp), allocator);
   mulleConvertStringsToUTF8( _storage, _count, &buffer);

   mulle_buffer_size_to_fit( &buffer);
   data = mulle_buffer_extract_data( &buffer);
   mulle_buffer_done( &buffer);

   _shadow    = data.bytes;
   _shadowLen = data.length - 1;    // minus terminating zero
   return( (char *) _shadow);
}


- (id) mutableCopy
{
   return( [[NSMutableString alloc] initWithStrings:_storage
                                              count:_count]);
}

@end


# pragma mark - NSString ( NSMutableString)

@implementation NSString ( NSMutableString)

- (id) mutableCopy
{
   return( [[NSMutableString alloc] initWithString:self]);
}


#pragma mark - mutation constructors

- (NSString *) stringByAppendingString:(NSString *) other
{
   NSString   *strings[ 2] = { self, other };
   //
   // On a followup call of stringByAppendingString: with the returned
   // NSMutableString as "other", "other" will be copied.
   //
   return( [[[NSMutableString alloc] initWithStrings:strings
                                               count:2] autorelease]);
}


- (NSString *) mulleStringByRemovingPrefix:(NSString *) other
{
   if( ! [self hasPrefix:other])
      return( self);
   return( [self substringFromIndex:[other length]]);
}


- (NSString *) mulleStringByRemovingSuffix:(NSString *) other
{
   if( ! [self hasSuffix:other])
      return( self);
   return( [self substringToIndex:[self length] - [other length]]);
}

@end
