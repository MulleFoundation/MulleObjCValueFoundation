//
//  _MulleObjCASCIIString.h
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


// ASCIICharacters are just the chars without trailing zero
// ASCIIString always has a trailing zero
// TODO: rewrite with size and ZeroTerminatedASCIICharacters so
//       its understandable

//
// subclasses provide length
// ASCII is something that's provided "hidden". It's the best,
// because it can provide utf8 and mulle_utf32_t w/o composition
//
@interface _MulleObjCASCIIString : NSString < MulleObjCValueProtocols>

- (NSUInteger) mulleGetASCIICharacters:(char *) buf
                             maxLength:(NSUInteger) maxLength;

@end


@interface _MulleObjCASCIIString( _Subclasses)

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length;
+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                                 length:(NSUInteger) length;
@end



// (nat/2019) I don't feel these are worth the class meta overhead

#ifdef HAVE_FIXED_LENGTH_ASCII_SUBCLASSES
//
// just some shortcuts to avoid having to store the length, when our byte size
// length would blow up the string by another 4 bytes (because of malloc
// alignment) (and we like to keep/have the trailing zero)
//
//
@interface _MulleObjC03LengthASCIIString : _MulleObjCASCIIString < MulleObjCValueProtocols>
@end
@interface _MulleObjC07LengthASCIIString : _MulleObjCASCIIString < MulleObjCValueProtocols>
@end
@interface _MulleObjC11LengthASCIIString : _MulleObjCASCIIString < MulleObjCValueProtocols>
@end
@interface _MulleObjC15LengthASCIIString : _MulleObjCASCIIString < MulleObjCValueProtocols>
@end

#endif


@interface _MulleObjCTinyASCIIString : _MulleObjCASCIIString < MulleObjCValueProtocols>
{
   uint8_t   _length;         // 1 - 256
   char      _storage[ 3];
}
@end


@interface _MulleObjCGenericASCIIString : _MulleObjCASCIIString < MulleObjCValueProtocols>
{
   NSUInteger   _length;         // 257-max
   char         _storage[ 1];
}
@end


// TODO: coalesce next three into one

// does not have a trailing zero, this is an abstract class
@interface _MulleObjCReferencingASCIIString : _MulleObjCASCIIString < MulleObjCValueProtocols>
{
   NSUInteger                _length;
   char                      *_storage;
   mulle_atomic_pointer_t    _shadow;
}
@end


// does not have a trailing zero
@interface _MulleObjCAllocatorASCIIString  : _MulleObjCReferencingASCIIString < MulleObjCValueProtocols>
{
   struct mulle_allocator   *_allocator;
}

+ (instancetype) newWithASCIICharactersNoCopy:(char *) chars
                                       length:(NSUInteger) length
                                    allocator:(struct mulle_allocator *) allocator;
@end


// does not have a trailing zero
@interface _MulleObjCSharedASCIIString : _MulleObjCReferencingASCIIString < MulleObjCValueProtocols>
{
   id   _sharingObject;
}

+ (instancetype) newWithASCIICharactersNoCopy:(char *) chars
                                       length:(NSUInteger) length
                                sharingObject:(id) sharingObject;
@end


// does have a trailing zero
@interface _MulleObjCAllocatorZeroTerminatedASCIIString  : _MulleObjCAllocatorASCIIString < MulleObjCValueProtocols>

+ (instancetype) newWithZeroTerminatedASCIICharactersNoCopy:(char *) chars
                                                     length:(NSUInteger) length
                                                  allocator:(struct mulle_allocator *) allocator;
@end

