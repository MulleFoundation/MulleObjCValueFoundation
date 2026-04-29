//
//  NSString+NSData.h
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

#import "NSString.h"
#import "NSStringEncoding.h"

@class NSData;


@interface NSString (NSData)

+ (NSStringEncoding *) availableStringEncodings;
- (NSStringEncoding) fastestEncoding;
- (NSStringEncoding) smallestEncoding;

- (BOOL) canBeConvertedToEncoding:(NSStringEncoding) encoding;

- (NSData *) dataUsingEncoding:(NSStringEncoding) encoding;

// the flag is a lie!
- (NSData *) dataUsingEncoding:(NSStringEncoding) encoding
          allowLossyConversion:(BOOL) flag;

- (NSData *) mulleDataUsingEncoding:(NSStringEncoding) encoding
                    encodingOptions:(MulleStringEncodingOptions) options;

- (instancetype) initWithData:(NSData *) data
                     encoding:(NSUInteger) encoding;

- (instancetype) initWithBytes:(void *) bytes
                        length:(NSUInteger) length
                      encoding:(NSStringEncoding) encoding;

// this method is a lie, it will copy
// use initWithCharactersNoCopy:
// also your bytes will be freed immediately, when freeWhenDone is YES
- (instancetype) initWithBytesNoCopy:(void *) bytes
                              length:(NSUInteger) length
                            encoding:(NSStringEncoding) encoding
                        freeWhenDone:(BOOL) flag;

// for subclasses this is easier sometimes
- (NSUInteger) lengthOfBytesUsingEncoding:(NSStringEncoding) encoding;

//
// the generic routine is slow
//
- (BOOL) getBytes:(void *) buffer
        maxLength:(NSUInteger) maxLength
       usedLength:(NSUInteger *) usedLength
         encoding:(NSStringEncoding) encoding
          options:(NSStringEncodingConversionOptions) options
            range:(NSRange) range
   remainingRange:(NSRangePointer) leftover;

- (NSUInteger) lengthOfBytesUsingEncoding:(NSStringEncoding) encoding;

#pragma mark - mulle additions

+ (instancetype) mulleStringWithData:(NSData *) data
                            encoding:(NSStringEncoding) encoding;

+ (instancetype) mulleStringWithUTF8Data:(NSData *) data;

- (instancetype) mulleInitWithBytesNoCopy:(void *) bytes
                                   length:(NSUInteger) length
                                 encoding:(NSStringEncoding) encoding
                            sharingObject:(id) owner;

- (instancetype) mulleInitWithDataNoCopy:(NSData *) s
                                encoding:(NSStringEncoding) encoding;

// why is this here ?
- (instancetype) mulleInitWithUTF16Characters:(mulle_utf16_t *) chars
                                       length:(NSUInteger) length;

@end


@interface NSString( NSDataPrivate)

// private and mulleprefix needed
- (NSData *) _asciiDataWithEncodingOptions:(MulleStringEncodingOptions) options;
- (NSData *) _utf8DataWithEncodingOptions:(MulleStringEncodingOptions) options;
- (NSData *) _utf16DataWithEndianness:(unsigned int) endianess
                      encodingOptions:(MulleStringEncodingOptions) options;
- (NSData *) _utf32DataWithEndianness:(unsigned int) endianess
                      encodingOptions:(MulleStringEncodingOptions) options;
@end
