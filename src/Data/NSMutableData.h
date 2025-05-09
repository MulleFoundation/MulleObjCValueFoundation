//
//  NSMutableData.h
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
#import "NSData.h"

#import "import.h"



@interface NSMutableData : NSData < MulleObjCClassCluster, MulleObjCThreadUnsafe>

+ (instancetype) dataWithCapacity:(NSUInteger) aNumItems;
+ (instancetype) dataWithLength:(NSUInteger) length;
- (instancetype) initWithLength:(NSUInteger) length;

- (void) appendData:(NSData *) otherData;
- (void) setData:(NSData *) aData;

// mulle additions
+ (instancetype) mulleNonZeroedDataWithLength:(NSUInteger) length;
- (instancetype) mulleInitNonZeroedDataWithLength:(NSUInteger) length;
- (instancetype) mulleInitWithNonZeroedAllocatedCapacity:(NSUInteger) capacity;

@end


@interface NSMutableData( Subclass)

- (instancetype) initWithCapacity:(NSUInteger) capacity;

- (void) appendBytes:(void *) bytes
              length:(NSUInteger) length;
- (void) increaseLengthBy:(NSUInteger) extraLength;

- (void *) mutableBytes;
- (struct mulle_data) mulleMutableData;
- (void) resetBytesInRange:(NSRange) range;

- (void) replaceBytesInRange:(NSRange) range
                    withBytes:(void *) bytes;
- (void) replaceBytesInRange:(NSRange) range
                    withBytes:(void *) replacementBytes
                       length:(NSUInteger) replacementLength;

- (void) setLength:(NSUInteger) length;

// mulle additions
- (void) mulleSetLengthDontZero:(NSUInteger) length;

@end
