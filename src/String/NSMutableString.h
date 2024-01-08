//
//  NSMutableString.h
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

#import "import.h"


//
// NSMutableString in the MulleFoundation is a class to temporarily
// construct strings from other strings. Many string operations on
// NSMutableString can be slow. It is best to convert NSMutableString
// to a regular NSString after construction with "copy/autorelease"
//
@interface NSMutableString : NSString
{
   NSUInteger     _length;
   unsigned int   _count;
   unsigned int   _size;
   NSString       **_storage; // only -copied strings live here

   char           *_shadow;
   NSUInteger     _shadowLen;
}

+ (instancetype) stringWithCapacity:(NSUInteger) capacity;
- (instancetype) initWithCapacity:(NSUInteger) capacity;

- (instancetype) initWithStrings:(NSString **) strings
                           count:(NSUInteger) count;

- (void) appendString:(NSString *) s;
- (void) appendFormat:(NSString *) format, ...;

- (void) replaceCharactersInRange:(NSRange) aRange
                       withString:(NSString *) replacement;

- (void) deleteCharactersInRange:(NSRange) aRange;

// here nil is allowed and clears the NSMutableString(!)
- (void) setString:(NSString *) s;

- (void) mulleAppendCharacters:(unichar *) buf
                        length:(NSUInteger) length;
- (void) mulleAppendFormat:(NSString *) format
           mulleVarargList:(mulle_vararg_list) args;
- (void) mulleAppendFormat:(NSString *) format
                 arguments:(va_list) args;

- (void) mulleAppendUTF8String:(char *) cStr;

// if you want to keep the NSMutableString internally as is
- (void) mulleGetNonCompactedCharacters:(unichar *) buf
                                  range:(NSRange) inRange;
@end


@interface NSString ( NSMutableString) < NSMutableCopying>

- (NSString *) stringByAppendingString:(NSString *) other;

- (NSString *) mulleStringByRemovingPrefix:(NSString *) other;
- (NSString *) mulleStringByRemovingSuffix:(NSString *) other;

@end
