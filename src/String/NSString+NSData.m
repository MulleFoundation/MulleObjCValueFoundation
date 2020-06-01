//
//  NSString+NSData.m
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

#import "NSString+NSData.h"

// other files in this library
#import "NSMutableData.h"
#import "NSString+ClassCluster.h"
#import "_MulleObjCUTF16String.h"
#import "_MulleObjCTaggedPointerChar5String.h"
#import "_MulleObjCTaggedPointerChar7String.h"

// std-c and dependencies
#import "import-private.h"


enum
{
   big_end_first    = 0,
   little_end_first = 1,
   native_end_first = 2
};



@implementation NSString (NSData)


// defaults

- (NSStringEncoding) fastestEncoding
{
   return( NSUTF8StringEncoding);
}


- (NSStringEncoding) smallestEncoding
{
   return( NSUTF8StringEncoding);
}



#pragma mark -
#pragma mark Export


// move convenient for subclasses
- (BOOL) _getBytes:(void *) buffer
         maxLength:(NSUInteger) maxLength
        usedLength:(NSUInteger *) usedLength
          encoding:(NSStringEncoding) encoding
           options:(NSStringEncodingConversionOptions) options
{
   NSUInteger   length;
   void         *bytes;
   NSData       *data;

   data   = [self dataUsingEncoding:encoding];
   bytes  = [data bytes];
   length = [data length];

   // do maxLength (in unichar)

   if( length > maxLength)
      length = maxLength;

   // do usedLength (in unichar)
   if( usedLength)
      *usedLength = length;

   memcpy( buffer, bytes, length);
   return( YES);
}


- (BOOL) getBytes:(void *) buffer
        maxLength:(NSUInteger) maxLength
       usedLength:(NSUInteger *) usedLength
         encoding:(NSStringEncoding) encoding
          options:(NSStringEncodingConversionOptions) options
            range:(NSRange) range
   remainingRange:(NSRangePointer) leftover
{
   NSUInteger   length;
   NSString     *s;

   if( ! range.length)
      return( YES);

   length = [self length];
   range  = MulleObjCValidateRangeAgainstLength( range, length);

   // do leftover (in unichar)
   if( leftover)
   {
      leftover->location = range.location + range.length;
      leftover->length   = length - leftover->location;
   }

   // do range (in unichar)
   s = self;
   if( range.location || range.length != length)
      s = [s substringWithRange:range];

   return( [s _getBytes:buffer
              maxLength:maxLength
             usedLength:usedLength
               encoding:encoding
                options:options]);
}


- (NSData *) _asciiData
{
   NSUInteger      length;
   NSMutableData   *data;
   mulle_utf8_t    *p;
   mulle_utf8_t    *sentinel;

   length   = [self mulleUTF8StringLength];
   data     = [NSMutableData mulleNonZeroedDataWithLength:length];
   p        = [data mutableBytes];
   sentinel = &p[ length];
   [self mulleGetUTF8Characters:p
                      maxLength:length];

   // check that its only ASCII
   while( p < sentinel)
      if( *p++ & 0x80)
         return( nil);
   return( data);
}


- (NSData *) _utf8Data
{
   NSUInteger      length;
   NSMutableData   *data;

   length = [self mulleUTF8StringLength];
   data   = [NSMutableData mulleNonZeroedDataWithLength:length];
   [self mulleGetUTF8Characters:[data mutableBytes]
                      maxLength:length];
   return( data);
}


//
// need to improve this the duplicate buffer is layme
// put better code into subclasses
//
- (NSData *) _utf16DataWithEndianness:(unsigned int) endianess
                        prefixWithBOM:(BOOL) prefixWithBOM
                    terminateWithZero:(BOOL) terminateWithZero
{
   NSMutableData                  *data;
   NSMutableData                  *tmp_data;
   NSUInteger                     tmp_length;
   NSUInteger                     utf16total;
   mulle_utf16_t                  *buf;
   mulle_utf16_t                  *p;
   mulle_utf16_t                  *sentinel;
   mulle_utf16_t                  bom;
   mulle_utf32_t                  *tmp_buf;
   struct mulle_buffer            buffer;
   struct mulle_utf_information   info;
   size_t                         size;

   tmp_length = [self length];
   tmp_data   = [NSMutableData mulleNonZeroedDataWithLength:tmp_length * sizeof( mulle_utf32_t)];
   tmp_buf    = [tmp_data mutableBytes];

   [self getCharacters:tmp_buf
                 range:NSMakeRange( 0, tmp_length)];

   if( mulle_utf32_information( tmp_buf, tmp_length, &info))
      MulleObjCThrowInvalidArgumentExceptionCString( "invalid UTF32");

   utf16total = info.utf16len;
   if( prefixWithBOM)
      ++utf16total;
   if( terminateWithZero)
      ++utf16total;

   size = utf16total * sizeof( mulle_utf16_t);
   data = [NSMutableData mulleNonZeroedDataWithLength:size];
   buf  = [data mutableBytes];

   mulle_buffer_init_inflexible_with_static_bytes( &buffer, buf, size);

   if( prefixWithBOM)
   {
      bom = (mulle_utf16_t) mulle_utf32_get_bomcharacter();
      mulle_buffer_add_bytes( &buffer, &bom, sizeof( bom));
   }
   mulle_utf32_bufferconvert_to_utf16( info.start,
                                       info.utf32len,
                                       &buffer,
                                       (void (*)()) mulle_buffer_add_bytes);
   if( terminateWithZero)
   {
      bom = 0;
      mulle_buffer_add_bytes( &buffer, &bom, sizeof( bom));
   }

   assert( mulle_buffer_get_length( &buffer) == size);
   assert( ! mulle_buffer_has_overflown( &buffer));
   mulle_buffer_done( &buffer);

   if( endianess == native_end_first)
      return( data);

#ifdef __LITTLE_ENDIAN__
   if( endianess == little_end_first)
      return( data);
#else
   if( endianess == big_end_first)
      return( data);
#endif

   p        = buf;
   sentinel = &p[ utf16total];

   while( p < sentinel)
   {
      *p = MulleObjCSwapUInt16( *p);
      ++p;
   }

   return( data);
}


- (NSData *) _utf32DataWithEndianness:(unsigned int) endianess
                        prefixWithBOM:(BOOL) prefixWithBOM
                    terminateWithZero:(BOOL) terminateWithZero
{
   NSUInteger      length;
   NSUInteger      total;
   NSMutableData   *data;
   mulle_utf32_t   *buf;
   mulle_utf32_t   *p;
   mulle_utf32_t   *sentinel;

   total = length = [self length];
   if( prefixWithBOM)
      ++total;
   if( terminateWithZero)
      ++total;

   data    = [NSMutableData mulleNonZeroedDataWithLength:total * sizeof( mulle_utf32_t)];
   p = buf = [data mutableBytes];

   if( prefixWithBOM)
      *p++ = mulle_utf32_get_bomcharacter();

   [self getCharacters:p
                 range:NSMakeRange( 0, length)];
   p = &p[ length];

   if( terminateWithZero)
      *p = 0;

   if( endianess == native_end_first)
      return( data);

#ifdef __LITTLE_ENDIAN__
   if( endianess == little_end_first)
      return( data);
#else
   if( endianess == big_end_first)
      return( data);
#endif

   p        = buf;
   sentinel = &p[ total];

   while( p < sentinel)
   {
      *p = MulleObjCSwapUInt32( *p);
      ++p;
   }

   return( data);
}


//
// TODO: need a plugin mechanism to support more encodings
//
- (BOOL) canBeConvertedToEncoding:(NSStringEncoding) encoding
{
   switch( encoding)
   {
   case NSUTF8StringEncoding              :
   case NSUTF16StringEncoding             :
   case NSUTF16LittleEndianStringEncoding :
   case NSUTF16BigEndianStringEncoding    :
   case NSUTF32StringEncoding             :
   case NSUTF32LittleEndianStringEncoding :
   case NSUTF32BigEndianStringEncoding    : return( YES);
   }

   return( NO);
}


char   *MulleStringEncodingCStringDescription( NSStringEncoding encoding)
{
   switch( encoding)
   {
   case NSASCIIStringEncoding             : return( "ASCII");
   case NSNEXTSTEPStringEncoding          : return( "NEXTSTEP");
   case NSJapaneseEUCStringEncoding       : return( "JapaneseEUC");
   case NSUTF8StringEncoding              : return( "UTF8");
   case NSISOLatin1StringEncoding         : return( "ISOLatin1");
   case NSSymbolStringEncoding            : return( "Symbol");
   case NSNonLossyASCIIStringEncoding     : return( "NonLossyASCII");
   case NSShiftJISStringEncoding          : return( "ShiftJIS");
   case NSISOLatin2StringEncoding         : return( "ISOLatin2");
   case NSUTF16StringEncoding             : return( "UTF16");
   case NSWindowsCP1251StringEncoding     : return( "WindowsCP1251");
   case NSWindowsCP1252StringEncoding     : return( "WindowsCP1252");
   case NSWindowsCP1253StringEncoding     : return( "WindowsCP1253");
   case NSWindowsCP1254StringEncoding     : return( "WindowsCP1254");
   case NSWindowsCP1250StringEncoding     : return( "WindowsCP1250");
   case NSISO2022JPStringEncoding         : return( "ISO2022JP");
   case NSUTF16BigEndianStringEncoding    : return( "UTF16BigEndian");
   case NSUTF16LittleEndianStringEncoding : return( "UTF16LittleEndian");
   case NSUTF32StringEncoding             : return( "UTF32");
   case NSUTF32BigEndianStringEncoding    : return( "UTF32BigEndian");
   case NSUTF32LittleEndianStringEncoding : return( "UTF32LittleEndian");
   default                                : return( "???");
   }
};


- (NSData *) _dataUsingEncoding:(NSStringEncoding) encoding
                  prefixWithBOM:(BOOL) withBOM
              terminateWithZero:(BOOL) withZero
{
   NSData   *data;

   switch( encoding)
   {
   default :
      MulleObjCThrowInvalidArgumentExceptionCString( "encoding %s (%ld) is not supported",
         MulleStringEncodingCStringDescription( encoding),
         (long) encoding);

   case NSASCIIStringEncoding  :
      data = [self _asciiData];
      if( ! data)
         MulleObjCThrowInvalidArgumentExceptionCString( "Can not convert this string to ASCII");
      return( data);

   case NSUTF8StringEncoding  :
      return( [self _utf8Data]);

   case NSUTF16StringEncoding :
      return( [self _utf16DataWithEndianness:native_end_first
                                prefixWithBOM:withBOM
                           terminateWithZero:withZero]);
   case NSUTF16LittleEndianStringEncoding :
      return( [self _utf16DataWithEndianness:little_end_first
                               prefixWithBOM:withBOM
                           terminateWithZero:withZero]);
   case NSUTF16BigEndianStringEncoding :
      return( [self _utf16DataWithEndianness:big_end_first
                               prefixWithBOM:withBOM
                           terminateWithZero:withZero]);

   case NSUTF32StringEncoding :
      return( [self _utf32DataWithEndianness:native_end_first
                               prefixWithBOM:withBOM
                           terminateWithZero:withZero]);
   case NSUTF32LittleEndianStringEncoding :
      return( [self _utf32DataWithEndianness:little_end_first
                               prefixWithBOM:withBOM
                           terminateWithZero:withZero]);
   case NSUTF32BigEndianStringEncoding :
      return( [self _utf32DataWithEndianness:big_end_first
                               prefixWithBOM:withBOM
                           terminateWithZero:withZero]);
   }
}


- (NSData *) dataUsingEncoding:(NSStringEncoding) encoding
{
   return( [self _dataUsingEncoding:encoding
                      prefixWithBOM:YES
                  terminateWithZero:NO]);
}


#pragma mark -
#pragma mark Import

- (instancetype) mulleInitWithUTF16Characters:(mulle_utf16_t *) chars
                                       length:(NSUInteger) length
{
   struct mulle_utf_information    info;
   struct mulle_buffer             buffer;
   void                            *p;
   struct mulle_allocator          *allocator;

   if( mulle_utf16_information( chars, length, &info))
      MulleObjCThrowInvalidArgumentExceptionCString( "invalid UTF16");

   allocator = MulleObjCInstanceGetAllocator( self);

#ifdef __MULLE_OBJC_TPS__
   if( info.is_ascii && info.utf8len <= mulle_char7_get_maxlength())
      return( MulleObjCTaggedPointerChar7StringWithUTF16Characters( (mulle_utf16_t *) info.start, info.utf8len));
   if( info.is_char5 && info.utf8len <= mulle_char5_get_maxlength())
      return( MulleObjCTaggedPointerChar5StringWithUTF16Characters( (mulle_utf16_t *) info.start, info.utf8len));
#endif

   if( info.is_utf15)
      return( [_MulleObjCGenericUTF16String newWithUTF16Characters:info.start
                                                            length:info.utf16len]);

   /* convert to utf32 */
   mulle_buffer_init_with_capacity( &buffer, info.utf32len * sizeof( mulle_utf32_t), allocator);

   mulle_utf16_bufferconvert_to_utf32( info.start,
                                       info.utf16len,
                                       &buffer,
                                       (void (*)()) mulle_buffer_add_bytes);

   assert( mulle_buffer_get_length( &buffer) == info.utf32len * sizeof( mulle_utf32_t));

   p = mulle_buffer_extract_all( &buffer);
   mulle_buffer_done( &buffer);

   return( [self mulleInitWithCharactersNoCopy:p
                                        length:info.utf32len
                                     allocator:allocator]);
}


- (instancetype) _initWithSwappedUTF16Characters:(mulle_utf16_t *) chars
                                          length:(NSUInteger) length
{
   mulle_utf16_t   *p;
   mulle_utf16_t   *buf;
   mulle_utf16_t   *sentinel;

   buf      = [[NSMutableData mulleNonZeroedDataWithLength:length * sizeof( mulle_utf16_t)] mutableBytes];
   p        = buf;
   sentinel = &p[ length];

   while( p < sentinel)
      *p++ = MulleObjCSwapUInt16( *chars++);

   return( [self mulleInitWithUTF16Characters:buf
                                       length:length]);
}



- (instancetype) _initWithSwappedUTF32Characters:(mulle_utf32_t *) chars
                                          length:(NSUInteger) length
{
   mulle_utf32_t   *p;
   mulle_utf32_t   *buf;
   mulle_utf32_t   *sentinel;

   buf      = [[NSMutableData mulleNonZeroedDataWithLength:length * sizeof( mulle_utf32_t)] mutableBytes];
   p        = buf;
   sentinel = &p[ length];

   while( p < sentinel)
      *p++ = MulleObjCSwapUInt32( *chars++);

   return( [self initWithCharacters:buf
                             length:length]);
}


- (instancetype) initWithBytes:(void *) bytes
                        length:(NSUInteger) length
                      encoding:(NSUInteger) encoding

{
   if( ! bytes && length)
      MulleObjCThrowInvalidArgumentExceptionCString( "null bytes");

   switch( encoding)
   {
   default :
      MulleObjCThrowInvalidArgumentExceptionCString( "encoding %s (%ld) is not supported",
         MulleStringEncodingCStringDescription( encoding),
         (long) encoding);

   case NSASCIIStringEncoding :
   case NSUTF8StringEncoding  :
      return( [self mulleInitWithUTF8Characters:bytes
                                         length:length]);

   /*
    *  16 bit
    */
#ifdef __BIG_ENDIAN__
   case NSUTF16BigEndianStringEncoding    :
#endif
#ifdef __LITTLE_ENDIAN__
   case NSUTF16LittleEndianStringEncoding :
#endif
   case NSUTF16StringEncoding             :
      return( [self mulleInitWithUTF16Characters:bytes
                                          length:length / sizeof( mulle_utf16_t)]);

#ifdef __BIG_ENDIAN__
   case NSUTF16LittleEndianStringEncoding :
#endif
#ifdef __LITTLE_ENDIAN__
   case NSUTF16BigEndianStringEncoding    :
#endif
      return( [self _initWithSwappedUTF16Characters:bytes
                                             length:length / sizeof( mulle_utf16_t)]);

   /*
    * same for 32 bit
    */
#ifdef __BIG_ENDIAN__
   case NSUTF32BigEndianStringEncoding    :
#endif
#ifdef __LITTLE_ENDIAN__
   case NSUTF32LittleEndianStringEncoding :
#endif
   case NSUTF32StringEncoding :
      return( [self initWithCharacters:bytes
                                length:length / sizeof( mulle_utf32_t)]);

#ifdef __BIG_ENDIAN__
   case NSUTF32LittleEndianStringEncoding :
#endif
#ifdef __LITTLE_ENDIAN__
   case NSUTF32BigEndianStringEncoding    :
#endif
      return( [self _initWithSwappedUTF32Characters:bytes
                                             length:length / sizeof( mulle_utf32_t)]);
   }
}


- (instancetype) initWithBytesNoCopy:(void *) bytes
                              length:(NSUInteger) length
                            encoding:(NSStringEncoding) encoding
                        freeWhenDone:(BOOL) flag
{
   NSString                 *s;
   struct mulle_allocator   *allocator;

   allocator = flag ? &mulle_stdlib_allocator : NULL;

   if( ! bytes && length)
      MulleObjCThrowInvalidArgumentExceptionCString( "null bytes");

   // has zero termination ?
   switch( encoding)
   {
   case NSUTF8StringEncoding :
      if( length && ! ((char *) bytes)[ length - 1])
         return( [self mulleInitWithUTF8CharactersNoCopy:bytes
                                                  length:length
                                               allocator:allocator]);
      break;

   case NSUnicodeStringEncoding :
      return( [self mulleInitWithCharactersNoCopy:bytes
                                       length:length
                                    allocator:allocator]);
   }

   s = [self initWithBytes:bytes
                    length:length
                  encoding:encoding];
   if( allocator)
      mulle_allocator_free( allocator, bytes);
   return( s);
}


- (instancetype) mulleInitWithBytesNoCopy:(void *) bytes
                                   length:(NSUInteger) length
                                 encoding:(NSStringEncoding) encoding
                            sharingObject:(id) owner
{
   switch( encoding)
   {
   case NSUTF8StringEncoding :
      return( [self mulleInitWithUTF8CharactersNoCopy:bytes
                                               length:length
                                        sharingObject:owner]);
   case NSUnicodeStringEncoding :
      assert( (length & (sizeof( mulle_utf32_t) - 1)) == 0);
      return( [self mulleInitWithCharactersNoCopy:bytes
                                           length:length / sizeof( mulle_utf32_t)
                                    sharingObject:owner]);
   }

   return( [self initWithBytes:bytes
                        length:length
                      encoding:encoding]);
}


- (instancetype) mulleInitWithDataNoCopy:(NSData *) p
                                encoding:(NSStringEncoding) encoding
{
   struct mulle_data   data;

   data  = [p mulleData];
   return( [self mulleInitWithBytesNoCopy:data.bytes
                                   length:data.length
                                 encoding:encoding
                            sharingObject:p]);
}


- (instancetype) initWithData:(NSData *) p
                     encoding:(NSUInteger) encoding
{
   struct mulle_data   data;

   data  = [p mulleData];
   return( [self initWithBytes:data.bytes
                        length:data.length
                      encoding:encoding]);
}


+ (instancetype) mulleStringWithData:(NSData *) data
                            encoding:(NSStringEncoding) encoding
{
   return( [[[self alloc] initWithData:data
                              encoding:encoding] autorelease]);
}



// this code works for UTF8String and ASCII only
- (NSUInteger) lengthOfBytesUsingEncoding:(NSStringEncoding) encoding
{
   size_t                        length;
   struct mulle_utf_information  info;
   mulle_utf8_t                  *s;
   struct mulle_utf8_data        data;

   if( [self mulleFastGetASCIIData:&data])
   {
      switch( encoding)
      {
      case NSASCIIStringEncoding :
      case NSUTF8StringEncoding  : return( data.length);
      case NSUTF16StringEncoding : return( data.length * sizeof( mulle_utf16_t));
      case NSUTF32StringEncoding : return( data.length * sizeof( mulle_utf32_t));
      default                    : return( 0);
      }
   }

   if( [self mulleFastGetUTF8Data:&data])
   {
      s      = data.characters;
      length = data.length;
   }
   else
   {
      s      = (mulle_utf8_t *) [self UTF8String];
      length = [self mulleUTF8StringLength];
   }

   if( encoding == NSUTF8StringEncoding)
      return( length);

   if( mulle_utf8_information( s, length, &info))
      MulleObjCThrowInternalInconsistencyExceptionCString( "supposed UTF8 is not UTF8");

   switch( encoding)
   {
   case NSASCIIStringEncoding : return( info.is_ascii ? info.utf8len : 0);
   case NSUTF16StringEncoding : return( info.utf16len * sizeof( mulle_utf16_t));
   case NSUTF32StringEncoding : return( info.utf32len * sizeof( mulle_utf32_t));
   default                    : return( 0);
   }
}


#pragma mark - lldb support

// the actual function is:
// CFStringRef CFStringCreateWithBytes (
//   CFAllocatorRef alloc,
//   const UInt8 *bytes,
//   CFIndex numBytes,
//   CFStringEncoding encoding,
//   Boolean isExternalRepresentation
// );
// rename it in the debugger and use this

NSString   *_NSStringCreateWithBytes( void *allocator,
                                      mulle_utf8_t *bytes,
                                      NSUInteger length,
                                      NSStringEncoding encoding,
                                      char isExternal);

NSString   *_NSStringCreateWithBytes( void *allocator,
                                      mulle_utf8_t *bytes,
                                      NSUInteger length,
                                      NSStringEncoding encoding,
                                      char isExternal)
{
   return( [[[NSString alloc] initWithBytes:bytes
                                     length:length
                                   encoding:encoding] autorelease]);
}

@end
