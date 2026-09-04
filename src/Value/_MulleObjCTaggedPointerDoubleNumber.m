//
//  _MulleObjCTaggedPointerDoubleNumber.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2024 Nat! - Mulle kybernetiK.
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

#import "_MulleObjCValueTaggedPointer.h"
#import "_MulleObjCTaggedPointerDoubleNumber.h"
#import "_NSNumberHash.h"

#import "import-private.h"



#ifdef __MULLE_OBJC_TPS__

@implementation _MulleObjCTaggedPointerDoubleNumber

+ (void) load
{
   // if we can't register than no problem
   MulleObjCTaggedPointerRegisterClassAtIndex( self, MulleObjCDoubleTPSIndex);
}

- (int32_t) _int32Value     { return( (int32_t) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (int64_t) _int64Value     { return( (int64_t) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }

- (BOOL) boolValue          { return( _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self) != 0.0 ? YES : NO); }
- (char) charValue          { return( (char) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (short) shortValue        { return( (short) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (int) intValue            { return( (int) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (long) longValue          { return( (long) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (NSInteger) integerValue  { return( (NSInteger) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (long long) longLongValue { return( (long long) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (NSUInteger) unsignedDoubleValue    { return( (NSUInteger) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }

- (float) floatValue              { return( (float) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (double) doubleValue            { return( (double) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (long double) longDoubleValue   { return( (long double) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }


- (void) getValue:(void *) p_value
{
   double   value;

   value               = _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self);
   *(double *) p_value = value;
}


- (char *) objCType
{
   return( @encode( double));
}


- (enum MulleNumberIsEqualType) __mulleIsEqualType
{
#ifdef _C_LNG_DBL
   return( MulleNumberIsEqualLongDouble);
#else
   return( MulleNumberIsEqualDouble);
#endif
}


- (NSUInteger) hash
{
   double   value;

   value = _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self);
   return( NSNumberHashDouble( value));
}


- (BOOL) isEqualToNumber:(NSNumber *) other
{
   enum MulleNumberIsEqualType   otherType;
   long double                   value;

   if( self == other)
      return( YES);

   otherType = [other __mulleIsEqualType];
#ifdef _C_LNG_DBL
   if( otherType != MulleNumberIsEqualDefault)
   {
      if( MulleNumberIsEqualLongDouble != otherType)
         return( NO);
      value = (long double) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self);
      return( value == [other longDoubleValue]);
   }
#else
   if( otherType != MulleNumberIsEqualDefault)
   {
      if( MulleNumberIsEqualDouble != otherType)
         return( NO);
      value = (double) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self);
      return( value == [other doubleValue]);
   }
#endif
   return( [other compare:self] == NSOrderedSame);
}

@end

#endif
