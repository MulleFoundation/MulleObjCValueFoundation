//
//  _MulleObjCConcreteNumber.h
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

#import "NSNumber.h"


// TODO: coalesce into 8 into 16 and add a @encode ?
@interface _MulleObjCInt32Number : NSNumber <MulleObjCValueProtocols>
{
   int32_t  _value;
}

+ (instancetype) newWithInt32:(int32_t) value;

@end


@interface _MulleObjCInt64Number : NSNumber <MulleObjCValueProtocols>
{
   int64_t  _value;
}

+ (instancetype) newWithInt64:(int64_t) value;

@end


#pragma mark - unsigned variants


@interface _MulleObjCUInt32Number : NSNumber <MulleObjCValueProtocols>
{
   uint32_t  _value;
}

+ (instancetype) newWithUInt32:(uint32_t) value;

@end


@interface _MulleObjCUInt64Number : NSNumber <MulleObjCValueProtocols>
{
   uint64_t  _value;
}

+ (instancetype) newWithUInt64:(uint64_t) value;

@end


//
// If you use initWithBOOL: then you get a _MulleObjCBoolNumber
// this can be useful when you want to serialize into true/false for JSON
// when you add a -JSONdescription or some such method
//
@interface _MulleObjCBoolNumber : NSNumber <MulleObjCValueProtocols>
{
   BOOL   _value;
}

+ (instancetype) newWithBOOL:(BOOL) value;

@end



@interface _MulleObjCFloatNumber : NSNumber <MulleObjCValueProtocols>
{
   float   _value;
}

+ (instancetype) newWithFloat:(float) value;

@end


@interface _MulleObjCDoubleNumber : NSNumber <MulleObjCValueProtocols>
{
   double   _value;
}

+ (instancetype) newWithDouble:(double) value;

@end


@interface _MulleObjCLongDoubleNumber : NSNumber <MulleObjCValueProtocols>
{
   long double   _value;
}

+ (instancetype) newWithLongDouble:(long double) value;

@end
