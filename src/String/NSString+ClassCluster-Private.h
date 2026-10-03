//
//  NSString+ClassCluster-Private.h
//  MulleObjCValueFoundation
//
//  Copyright (c) 2026 Nat! - Mulle kybernetiK.
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
// private header, not for public consumption
//
#ifndef mulle_objc_value_foundation_string_classcluster_private_h__
#define mulle_objc_value_foundation_string_classcluster_private_h__

#import "NSString.h"


//
// The primitive methods that a concrete NSString class cluster class must
// implement. NSString itself does not implement them (or only provides a
// stub that is meant to be overridden), so they are collected here as
// protocols. A concrete class adopts the protocol matching its storage
// family, which makes the compiler warn if an implementation is missing.
//
// Do not add methods here that NSString implements in a usable way (like
// -substringWithRange: or -UTF8String). Those are optimizations a subclass
// may override, not requirements.
//

@protocol MulleObjCStringPrimitive < NSObject>

@required

// number of characters in the string
- (NSUInteger) length;

// character at index, index must be < length
- (unichar) characterAtIndex:(NSUInteger) index;

// copy the characters in range into buffer, range must be valid
- (void) getCharacters:(unichar *) buffer
                 range:(NSRange) range;

@end


// ASCII strings hand out their bytes directly. The generic ASCII
// implementations assert this to succeed, so a subclass must override the
// NSString stub (which returns NO).
@protocol MulleObjCASCIIStringPrimitive < MulleObjCStringPrimitive>

@required

- (BOOL) mulleFastGetASCIIData:(struct mulle_asciidata *) space;

@end


@protocol MulleObjCUTF16StringPrimitive < MulleObjCStringPrimitive>

@required

- (BOOL) mulleFastGetUTF16Data:(struct mulle_utf16data *) space;

@end


@protocol MulleObjCUTF32StringPrimitive < MulleObjCStringPrimitive>

@required

- (BOOL) mulleFastGetUTF32Data:(struct mulle_utf32data *) space;

@end

#endif
