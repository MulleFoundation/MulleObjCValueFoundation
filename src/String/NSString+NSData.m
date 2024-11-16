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
#import "_MulleObjCValueTaggedPointer.h"
#import "_MulleObjCTaggedPointerChar5String.h"
#import "_MulleObjCTaggedPointerChar7String.h"

// std-c and dependencies
#import "import-private.h"


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


+ (NSStringEncoding *) availableStringEncodings
{
   static const NSStringEncoding   encodings[] =
   {
      NSASCIIStringEncoding,
      NSISOLatin1StringEncoding, // sorta
      NSUTF8StringEncoding,
      NSUTF16StringEncoding,
      NSUTF16BigEndianStringEncoding,
      NSUTF16LittleEndianStringEncoding,
      NSUTF32StringEncoding,
      NSUTF32BigEndianStringEncoding,
      NSUTF32LittleEndianStringEncoding,
      0
   };

   return( (NSStringEncoding *) encodings);
}


#pragma mark - Export


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

//
// TODO: need a plugin mechanism to support more encodings
//
- (BOOL) canBeConvertedToEncoding:(NSStringEncoding) encoding
{
   switch( encoding)
   {
   case NSISOLatin1StringEncoding         : return( NO);  // subclass can do a better check
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


static struct
{
   NSUInteger  encoding;
   char        *name;
} encoding_table[] =
{
   { NSASCIIStringEncoding            , "ASCII" },
   { NSNEXTSTEPStringEncoding         , "NEXTSTEP" },
   { NSJapaneseEUCStringEncoding      , "JapaneseEUC" },
   { NSUTF8StringEncoding             , "UTF8" },
   { NSISOLatin1StringEncoding        , "ISOLatin1" },
   { NSSymbolStringEncoding           , "Symbol" },
   { NSNonLossyASCIIStringEncoding    , "NonLossyASCII" },
   { NSShiftJISStringEncoding         , "ShiftJIS" },
   { NSISOLatin2StringEncoding        , "ISOLatin2" },
   { NSUTF16StringEncoding            , "UTF16" },
   { NSWindowsCP1251StringEncoding    , "WindowsCP1251" },
   { NSWindowsCP1252StringEncoding    , "WindowsCP1252" },
   { NSWindowsCP1253StringEncoding    , "WindowsCP1253" },
   { NSWindowsCP1254StringEncoding    , "WindowsCP1254" },
   { NSWindowsCP1250StringEncoding    , "WindowsCP1250" },
   { NSISO2022JPStringEncoding        , "ISO2022JP" },
   { NSMacOSRomanStringEncoding       , "MacOSRoman" },
   { NSUTF16BigEndianStringEncoding   , "UTF16BigEndian" },
   { NSUTF16LittleEndianStringEncoding, "UTF16LittleEndian" },
   { NSUTF32StringEncoding            , "UTF32" },
   { NSUTF32BigEndianStringEncoding   , "UTF32BigEndian" },
   { NSUTF32LittleEndianStringEncoding, "UTF32LittleEndian" },
   { 0, 0 }
};


NSStringEncoding   MulleStringEncodingParseUTF8String( char *s)
{
   unsigned int  i;

   if( ! s)
      return( 0);

   for( i = 0;; i++)
   {
      if( ! encoding_table[ i].name)
         return( 0);
      if( ! strcmp( s, encoding_table[ i].name))
         return( encoding_table[ i].encoding);
   }
}


char   *MulleStringEncodingUTF8String( NSStringEncoding encoding)
{
   unsigned int  i;

   for( i = 0;; i++)
   {
      if( ! encoding_table[ i].encoding)
         return( "???");
      if( encoding == encoding_table[ i].encoding)
         return( encoding_table[ i].name);
   }
}


- (NSData *) mulleDataUsingEncoding:(NSStringEncoding) encoding
                    encodingOptions:(MulleStringEncodingOptions) options
{
   NSData   *data;

   switch( encoding)
   {
   default :
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "encoding %s (%ld) is not supported",
         MulleStringEncodingUTF8String( encoding),
         (long) encoding);

   case NSASCIIStringEncoding  :
      data = [self _asciiDataWithEncodingOptions:options];
      if( ! data)
         MulleObjCThrowInvalidArgumentExceptionUTF8String( "Can not convert this data to ASCII");
      return( data);

   case NSISOLatin1StringEncoding  :
      {
         char           *s;
         char           *end;
         NSUInteger     iso1_length;
         NSUInteger     length;

         data   = [self _utf8DataWithEncodingOptions:options];
         length = [data length];
         if( ! length)
            return( data);

         s   = mulle_allocator_malloc( &mulle_stdlib_allocator, length);
         end = _mulle_utf8_convert_to_iso1( [data bytes], length, s, -1);
         if( ! end)
         {
            mulle_allocator_free( &mulle_stdlib_allocator, s);
            MulleObjCThrowInvalidArgumentExceptionUTF8String( "Can not convert this data to ISO1");
         }
         iso1_length = (end - s);
         s           = mulle_allocator_realloc( &mulle_stdlib_allocator,
                                                s,
                                                iso1_length);
         return( [NSData dataWithBytesNoCopy:s
                                      length:iso1_length
                                freeWhenDone:YES]);
      }

   case NSUTF8StringEncoding  :
      return( [self _utf8DataWithEncodingOptions:options]);

   case NSUTF16StringEncoding :
      return( [self _utf16DataWithEndianness:native_end_first
                             encodingOptions:options]);
   case NSUTF16LittleEndianStringEncoding :
      return( [self _utf16DataWithEndianness:little_end_first
                             encodingOptions:options]);
   case NSUTF16BigEndianStringEncoding :
      return( [self _utf16DataWithEndianness:big_end_first
                             encodingOptions:options]);

   case NSUTF32StringEncoding :
      return( [self _utf32DataWithEndianness:native_end_first
                             encodingOptions:options]);
   case NSUTF32LittleEndianStringEncoding :
      return( [self _utf32DataWithEndianness:little_end_first
                             encodingOptions:options]);
   case NSUTF32BigEndianStringEncoding :
      return( [self _utf32DataWithEndianness:big_end_first
                             encodingOptions:options]);
   }
}


- (NSData *) dataUsingEncoding:(NSStringEncoding) encoding
{
   return( [self mulleDataUsingEncoding:encoding
                        encodingOptions:MulleStringEncodingOptionDefault]);
}


// it's a lie!
- (NSData *) dataUsingEncoding:(NSStringEncoding) encoding
          allowLossyConversion:(BOOL) flag
{
   return( [self mulleDataUsingEncoding:encoding
                        encodingOptions:MulleStringEncodingOptionDefault]);
}


#pragma mark - Import

- (instancetype) mulleInitWithUTF16Characters:(mulle_utf16_t *) chars
                                       length:(NSUInteger) length
{
   struct mulle_utf_information    info;
   struct mulle_buffer             buffer;
   struct mulle_allocator          *allocator;
   struct mulle_data               data;

   if( mulle_utf16_information( chars, length, &info))
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "invalid UTF16");

   allocator = MulleObjCInstanceGetAllocator( self);

#ifdef __MULLE_OBJC_TPS__
   if( MulleObjCChar7TPSIndex <= mulle_objc_get_taggedpointer_mask()
       && info.is_ascii
       && info.utf8len <= mulle_char7_get_maxlength())
   {
      return( MulleObjCTaggedPointerChar7StringWithUTF16Characters( (mulle_utf16_t *) info.start, info.utf8len));
   }
   if( MulleObjCChar5TPSIndex <= mulle_objc_get_taggedpointer_mask()
       && info.is_char5
       && info.utf8len <= mulle_char5_get_maxlength())
   {
      return( MulleObjCTaggedPointerChar5StringWithUTF16Characters( (mulle_utf16_t *) info.start, info.utf8len));
   }
#endif

   if( info.is_utf15)
      return( [_MulleObjCGenericUTF16String newWithUTF16Characters:info.start
                                                            length:info.utf16len]);

   /* convert to utf32 */
   mulle_buffer_init( &buffer, info.utf32len * sizeof( mulle_utf32_t), allocator);

   mulle_utf16_bufferconvert_to_utf32( info.start,
                                       info.utf16len,
                                       &buffer,
                                       mulle_buffer_add_bytes_callback);
   data = mulle_buffer_extract_data( &buffer);
   mulle_buffer_done( &buffer);

   assert( data.length == info.utf32len * sizeof( mulle_utf32_t));

   return( [self mulleInitWithCharactersNoCopy:data.bytes
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


static id   initByConvertingFromEncoding( NSString *self,
                                          void *bytes,
                                          NSUInteger length,
                                          NSStringEncoding encoding)
{
   char         *s;
   char         *end;
   NSUInteger   utf8_length;

   s = mulle_allocator_malloc( &mulle_stdlib_allocator, length * 2);
   switch( encoding)
   {
   case NSMacOSRomanStringEncoding :
      end = _mulle_macroman_convert_to_utf8( bytes, length, s);
      break;

   case NSISOLatin1StringEncoding :
      end = _mulle_iso1_convert_to_utf8( bytes, length, s);
      break;

   case NSNEXTSTEPStringEncoding :
      end = _mulle_nextstep_convert_to_utf8( bytes, length, s);
      break;
   }
   utf8_length = end - s;
   s           = mulle_allocator_realloc( &mulle_stdlib_allocator,
                                          s,
                                          utf8_length);
   return( [self initWithBytesNoCopy:s
                              length:utf8_length
                            encoding:NSUTF8StringEncoding
                        freeWhenDone:YES]);
}


- (instancetype) initWithBytes:(void *) bytes
                        length:(NSUInteger) length
                      encoding:(NSUInteger) encoding

{
   if( ! bytes && length)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "null bytes");

   // do this here, because iso conversion is otherwise unhappy
   if( ! length)
      return( @"");

   switch( encoding)
   {
   default :
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "encoding %s (%ld) is not supported",
         MulleStringEncodingUTF8String( encoding),
         (long) encoding);

   case NSMacOSRomanStringEncoding :
   case NSISOLatin1StringEncoding :
   case NSNEXTSTEPStringEncoding :
      return( initByConvertingFromEncoding( self, bytes, length, encoding));

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
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "null bytes");

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

   data  = [p mulleCData];
   return( [self mulleInitWithBytesNoCopy:data.bytes
                                   length:data.length
                                 encoding:encoding
                            sharingObject:p]);
}


- (instancetype) initWithData:(NSData *) p
                     encoding:(NSUInteger) encoding
{
   struct mulle_data   data;

   data  = [p mulleCData];
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


+ (instancetype) mulleStringWithUTF8Data:(NSData *) data;
{
   return( [[[self alloc] initWithData:data
                              encoding:NSUTF8StringEncoding] autorelease]);
}



// this code works for UTF8String and ASCII only
- (NSUInteger) lengthOfBytesUsingEncoding:(NSStringEncoding) encoding
{
   size_t                        length;
   struct mulle_utf_information  info;
   char                          *s;
   struct mulle_asciidata        data;
   struct mulle_utf8data         utf8data;

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

   if( [self mulleFastGetUTF8Data:&utf8data])
   {
      s      = (char *) utf8data.characters;
      length = utf8data.length;
   }
   else
   {
      s      = [self UTF8String];
      length = [self mulleUTF8StringLength];
   }

   if( encoding == NSUTF8StringEncoding)
      return( length);

   if( mulle_utf8_information( s, length, &info))
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "supposed UTF8 is not UTF8");

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
                                      void *bytes,
                                      NSUInteger length,
                                      NSStringEncoding encoding,
                                      char isExternal);

NSString   *_NSStringCreateWithBytes( void *allocator,
                                      void *bytes,
                                      NSUInteger length,
                                      NSStringEncoding encoding,
                                      char isExternal)
{
   return( [[[NSString alloc] initWithBytes:bytes
                                     length:length
                                   encoding:encoding] autorelease]);
}

@end



@implementation NSString( NSDataPrivate)

- (NSData *) _asciiDataWithEncodingOptions:(MulleStringEncodingOptions) options
{
   NSUInteger      length;
   NSUInteger      utf8length;
   NSMutableData   *data;
   char            *bytes;
   BOOL            withZero;

   withZero = options & MulleStringEncodingOptionTerminateWithZero;
   // give room for trailing zero, if needed
   // if there are "composed" characters in UTF8 the string length differs
   // and it can't be ASCII (could check for 7 bit also, but seems pedantic)
   //
   utf8length = [self mulleUTF8StringLength];
   if( utf8length != [self length])
      return( nil);

   length = utf8length + (withZero ? 1 : 0);
   data   = [NSMutableData mulleNonZeroedDataWithLength:length];
   bytes  = [data mutableBytes];
   // get length with out zero back cheaply
   length = [self mulleGetUTF8Characters:bytes
                               maxLength:utf8length];
   if( withZero)
      bytes[ length] = 0;

   return( data);
}


- (NSData *) _utf8DataWithEncodingOptions:(MulleStringEncodingOptions) options
{
   NSUInteger      bomlessLength;
   NSUInteger      length;
   NSMutableData   *data;
   char            *bytes;
   BOOL            withZero;
   BOOL            prefixWithBOM;

   withZero      = options & MulleStringEncodingOptionTerminateWithZero;
   prefixWithBOM = options & MulleStringEncodingOptionBOM;
   bomlessLength = [self mulleUTF8StringLength] + (withZero ? 1 : 0);
   length        = bomlessLength + (prefixWithBOM ? 3 : 0);
   data          = [NSMutableData mulleNonZeroedDataWithLength:length];
   bytes         = [data mutableBytes];
   if( prefixWithBOM)
   {
      *bytes++ = 0xEF;
      *bytes++ = 0xBB;
      *bytes++ = 0xBC;
   }

   length = [self mulleGetUTF8Characters:bytes
                               maxLength:bomlessLength];
   if( withZero)
      bytes[ length] = 0;
   return( data);
}


//
// need to improve this the duplicate buffer is layme
// put better code into subclasses
//
- (NSData *) _utf16DataWithEndianness:(unsigned int) endianess
                      encodingOptions:(MulleStringEncodingOptions) options
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
   BOOL                           withZero;
   BOOL                           prefixWithBOM;

   withZero      = options & MulleStringEncodingOptionTerminateWithZero;
   prefixWithBOM = options & (MulleStringEncodingOptionBOM|MulleStringEncodingOptionBOMIfNeeded);

   tmp_length = [self length];
   tmp_data   = [NSMutableData mulleNonZeroedDataWithLength:tmp_length * sizeof( mulle_utf32_t)];
   tmp_buf    = [tmp_data mutableBytes];

   [self getCharacters:tmp_buf
                 range:NSRangeMake( 0, tmp_length)];

   if( mulle_utf32_information( tmp_buf, tmp_length, &info))
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "invalid UTF32");

   utf16total = info.utf16len;
   if( prefixWithBOM)
      ++utf16total;
   if( withZero)
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
                                       mulle_buffer_add_bytes_callback);
   if( withZero)
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
                      encodingOptions:(MulleStringEncodingOptions) options
{
   NSUInteger      length;
   NSUInteger      total;
   NSMutableData   *data;
   mulle_utf32_t   *buf;
   mulle_utf32_t   *p;
   mulle_utf32_t   *sentinel;
   BOOL            withZero;
   BOOL            prefixWithBOM;

   withZero      = options & MulleStringEncodingOptionTerminateWithZero;
   prefixWithBOM = options & (MulleStringEncodingOptionBOM|MulleStringEncodingOptionBOMIfNeeded);

   total = length = [self length];
   if( prefixWithBOM)
      ++total;
   if( withZero)
      ++total;

   data    = [NSMutableData mulleNonZeroedDataWithLength:total * sizeof( mulle_utf32_t)];
   p = buf = [data mutableBytes];

   if( prefixWithBOM)
      *p++ = mulle_utf32_get_bomcharacter();

   [self getCharacters:p
                 range:NSRangeMake( 0, length)];
   p = &p[ length];

   if( withZero)
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

@end
