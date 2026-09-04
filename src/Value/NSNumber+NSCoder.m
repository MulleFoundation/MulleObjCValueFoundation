//
//  NSNumber+NSCoder.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2019 Nat! - Mulle kybernetiK.
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
#import "NSNumber+NSCoder.h"

// std-c dependencies
#import "import-private.h"



@implementation NSNumber (NSCoder)

#pragma mark - NSCoding

- (Class) classForCoder
{
   return( [NSNumber class]);
}


- (void) decodeWithCoder:(NSCoder *) coder
{
   MULLE_C_UNUSED( coder);
}

@end



#ifdef __MULLE_OBJC_TPS__

#import "_MulleObjCValueTaggedPointer.h"
#import "_MulleObjCTaggedPointerIntegerNumber.h"
#import "_MulleObjCTaggedPointerFloatNumber.h"
#import "_MulleObjCTaggedPointerDoubleNumber.h"


@interface _MulleObjCTaggedPointerIntegerNumber( NSCoder) < NSCoding>
@end


@implementation _MulleObjCTaggedPointerIntegerNumber( NSCoder)

#pragma mark - NSCoding

- (instancetype) initWithCoder:(NSCoder *) coder
{
   MULLE_C_UNUSED( coder);
   abort(); // use NSNumber
   return( self);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSInteger      value;
   char           *type;

   value = _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self);
   type  = @encode( NSInteger);
   assert( strlen( type) == 1);
   [coder encodeBytes:type
               length:1+1]; // trailing 0 of cString
   [coder encodeValueOfObjCType:type
                             at:&value];
}

@end


@interface _MulleObjCTaggedPointerFloatNumber( NSCoder) < NSCoding>
@end


@implementation _MulleObjCTaggedPointerFloatNumber( NSCoder)

#pragma mark - NSCoding

- (instancetype) initWithCoder:(NSCoder *) coder
{
   MULLE_C_UNUSED( coder);
   abort(); // use NSNumber
   return( self);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSInteger      value;
   char           *type;

   value = _MulleObjCTaggedPointerFloatNumberGetFloatValue( self);
   type  = @encode( float);
   assert( strlen( type) == 1);
   [coder encodeBytes:type
               length:1+1]; // trailing 0 of cString
   [coder encodeValueOfObjCType:type
                             at:&value];
}

@end


@implementation _MulleObjCTaggedPointerDoubleNumber( NSCoder)

#pragma mark - NSCoding

- (instancetype) initWithCoder:(NSCoder *) coder
{
   MULLE_C_UNUSED( coder);
   abort(); // use NSNumber
   return( self);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSInteger      value;
   char           *type;

   value = _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self);
   type  = @encode( double);
   assert( strlen( type) == 1);
   [coder encodeBytes:type
               length:1+1]; // trailing 0 of cString
   [coder encodeValueOfObjCType:type
                             at:&value];
}

@end

#endif
