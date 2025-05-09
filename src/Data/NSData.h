//
//
//  NSData.h
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
   NSDataSearchBackwards = 1UL << 0,
   NSDataSearchAnchored  = 1UL << 1
};


@interface NSData : NSObject < MulleObjCClassCluster, MulleObjCValueProtocols>

- (instancetype) initWithBytesNoCopy:(void *) bytes
                              length:(NSUInteger) length;
- (instancetype) initWithBytesNoCopy:(void *) bytes
                              length:(NSUInteger) length
                        freeWhenDone:(BOOL) flag;
- (instancetype) initWithData:(NSData *) other;

+ (instancetype) dataWithBytes:(void *) bytes
                        length:(NSUInteger) length;
+ (instancetype) dataWithBytesNoCopy:(void *) bytes
                              length:(NSUInteger) length;
+ (instancetype) dataWithBytesNoCopy:(void *) bytes
                              length:(NSUInteger) length
                        freeWhenDone:(BOOL) flag;

+ (instancetype) data;
+ (instancetype) dataWithData:(NSData *) other;
+ (instancetype) mulleDataWithCData:(struct mulle_data) data;

- (NSUInteger) hash;
- (BOOL) isEqual:(id) other;

- (void) getBytes:(void *) bytes;
- (void) getBytes:(void *) bytes
           length:(NSUInteger) length;
- (void) getBytes:(void *) bytes
            range:(NSRange) range;
- (BOOL) isEqualToData:(NSData *) other;
- (NSData *) subdataWithRange:(NSRange) range;
- (NSRange) rangeOfData:(id) other
                options:(NSUInteger) options
                  range:(NSRange) range;

@end


@interface NSData( MulleObjCDataPlaceholder)

- (instancetype) initWithBytes:(void *) bytes
                        length:(NSUInteger) length
                          copy:(BOOL) copy
                  freeWhenDone:(BOOL) freeWhenDone
                    bytesAreVM:(BOOL) bytesAreVM;

- (instancetype) initWithBytes:(void *) bytes
                        length:(NSUInteger) length;

- (instancetype) mulleInitWithBytesNoCopy:(void *) bytes
                                   length:(NSUInteger) length
                                allocator:(struct mulle_allocator *) allocator;

- (instancetype) mulleInitWithBytesNoCopy:(void *) bytes
                                   length:(NSUInteger) length
                            sharingObject:(id) owner;

@end


@interface NSData( MulleObjCSubclasses)

- (NSUInteger) length;
- (void *) bytes;
- (struct mulle_data) mulleCData;

@end
