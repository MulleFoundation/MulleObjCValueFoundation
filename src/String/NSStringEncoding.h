//
//  NSStringEncoding.h
//  MulleObjCValueFoundation
//
//  Copyright (c) 2011-2026 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011-2026 Codeon GmbH.
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

//
// NSString+NSData is the "import" of characters into NSString. Here the
// incoming data is not trusted. Malformed UTF sequences are rejected. As
// soon as the characters become part of an NSString they are trusted to
// be well-formed and of the proper encoding for the given string class.
// Characters derived from an NSString are then trusted and not checked again.
// Typical imports of string data are files, user-input, internet connections.
// None can be trusted to always provide correct content.
//
// NSStringEncodings used internally are NSASCIIStringEncoding,
// NSUTF8StringEncoding, NSUTF16StringEncoding and NSUTF32StringEncoding.
// NSUTF16StringEncoding and NSUTF32StringEncoding are represented internally
// only in the host specific format.
//
// The "special" ..Endian.. encodings are only used for importing and exporting
// strings via -initWithData: and dataUsingEncoding and the like.
//
// NSStringEncoding conversions never escape any characters. If the conversion
// would result in a lack of information, then the conversion fails.
// Specifically there is no attempt to change accented characters to non-
// accented ones, like the Apple foundation does on a conversion to
// NSASCIIStringEncoding.
//

//
// Maybe more later. Should ensure that the enums have same numeric values as
// in AppleFoundation.
//
enum
{
   NSASCIIStringEncoding         = 1,
   NSNEXTSTEPStringEncoding      = 2,    // no support
   NSJapaneseEUCStringEncoding   = 3,    // no support
   NSUTF8StringEncoding          = 4,
   NSISOLatin1StringEncoding     = 5,
   NSSymbolStringEncoding        = 6,    // no support
   NSNonLossyASCIIStringEncoding = 7,    // no support
   NSShiftJISStringEncoding      = 8,    // no support
   NSISOLatin2StringEncoding     = 9,    // no support
   NSUTF16StringEncoding         = 10,
   NSWindowsCP1251StringEncoding = 11,   // no support
   NSWindowsCP1252StringEncoding = 12,   // no support
   NSWindowsCP1253StringEncoding = 13,   // no support
   NSWindowsCP1254StringEncoding = 14,   // no support
   NSWindowsCP1250StringEncoding = 15,   // no support
   NSISO2022JPStringEncoding     = 21,   // no support
   NSMacOSRomanStringEncoding    = 30,   // support for reading
};

// too big for enums
#define NSUTF16BigEndianStringEncoding       0x90000100
#define NSUTF16LittleEndianStringEncoding    0x94000100

#define NSUTF32StringEncoding                0x8c000100
#define NSUTF32BigEndianStringEncoding       0x98000100
#define NSUTF32LittleEndianStringEncoding    0x9c000100

#define NSUnicodeStringEncoding              NSUTF32StringEncoding // different(!)


// untyped
enum
{
   NSStringEncodingBigEndFirst    = 0,
   NSStringEncodingLittleEndFirst = 1,
   NSStringEncodingNativeEndFirst = 2
};

//
// MEMO: its good to have this as not an int, because of id <-> NSUInteger and
// the ease of using performSelector: with it
//
typedef NSUInteger   NSStringEncoding;


typedef NS_OPTIONS( NSUInteger, MulleStringEncodingOptions)
{
   MulleStringEncodingOptionBOM               = 1,     // also for UTF8
   MulleStringEncodingOptionBOMIfNeeded       = 2,     // for UTF16 or UTF32
   MulleStringEncodingOptionTerminateWithZero = 4,
};

#define MulleStringEncodingOptionDefault  MulleStringEncodingOptionBOMIfNeeded

// used for nothing currently
typedef NS_OPTIONS( NSUInteger, NSStringEncodingConversions)
{
   NSStringEncodingConversionAllowLossy             = 1,
   NSStringEncodingConversionExternalRepresentation = 2
};

#define NSStringEncodingConversionDefault   0

typedef NSUInteger   NSStringEncodingConversionOptions;

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
char              *MulleStringEncodingUTF8String( NSStringEncoding encoding);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSStringEncoding   MulleStringEncodingParseUTF8String( char *s);


