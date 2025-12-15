//
//  _MulleObjCConcreteNumber.m
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

#import "_MulleObjCConcreteNumber.h"

#include <limits.h>
#include <float.h>
#include <math.h>  // for isnan macro and NAN, if we need to link we fail
#include "_NSNumberHash.h"

// other files in this library

// other libraries of MulleObjCValueFoundation

// std-c and dependencies


@implementation _MulleObjCInt32Number : NSNumber

+ (instancetype) newWithInt32:(int32_t) value
{
   _MulleObjCInt32Number  *obj;

   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = value;
   return( obj);
}


- (int32_t) _int32Value     { return( (int32_t) _value); }
- (int64_t) _int64Value     { return( (int64_t) _value); }

- (BOOL) boolValue          { return( _value ? YES : NO); }
- (char) charValue          { return( (char) _value); }
- (short) shortValue        { return( (short) _value); }
- (int) intValue            { return( _value); }
- (long) longValue          { return( _value); }
- (NSInteger) integerValue  { return( _value); }
- (long long) longLongValue { return( _value); }

- (unsigned char) unsignedCharValue          { return( (unsigned char) _value); }
- (unsigned short) unsignedShortValue        { return( (unsigned short) _value); }
- (unsigned int) unsignedIntValue            { return( (unsigned int) _value); }
- (unsigned long) unsignedLongValue          { return( (unsigned long) _value); }
- (NSUInteger) unsignedIntegerValue          { return( (NSUInteger) _value); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _value); }

// 32 bit conversions should pose no problem
- (float) floatValue              { return( (float) _value); }
- (double) doubleValue            { return( (double) _value); }
- (long double) longDoubleValue   { return( (long double) _value); }


- (void) getValue:(void *) p_value
{
   *(int32_t *) p_value = _value;
}


- (char *) objCType
{
   return( @encode( int32_t));
}


- (NSUInteger) hash
{
   return( NSNumberHashUnsignedIntegerBytes( &_value, sizeof( _value)));
}

- (enum MulleNumberIsEqualType) __mulleIsEqualType
{
   return( MulleNumberIsEqualLongLong);
}

@end



@implementation _MulleObjCInt64Number

+ (instancetype) newWithInt64:(int64_t) value
{
   _MulleObjCInt64Number  *obj;

   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = value;
   return( obj);
}


- (int32_t) _int32Value     { return( (int32_t) _value); }
- (int64_t) _int64Value     { return( (int64_t) _value); }

- (BOOL) boolValue          { return( _value ? YES : NO); }
- (char) charValue          { return( (char) _value); }
- (short) shortValue        { return( (short) _value); }
- (int) intValue            { return( (int) _value); }
- (long) longValue          { return( (long) _value); }
- (NSInteger) integerValue  { return( (NSInteger) _value); }
- (long long) longLongValue { return( (long long) _value); }

- (unsigned char) unsignedCharValue          { return( (unsigned char) _value); }
- (unsigned short) unsignedShortValue        { return( (unsigned short) _value); }
- (unsigned int) unsignedIntValue            { return( (unsigned int) _value); }
- (unsigned long) unsignedLongValue          { return( (unsigned long) _value); }
- (NSUInteger) unsignedIntegerValue          { return( (NSUInteger) _value); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _value); }

//
// 32 bit conversions should pose no problem
// the conversion from LLONG_MAX to double will be invalid though
//
- (float) floatValue
{
   return( (float) _value);
}

- (double) doubleValue
{
   return( (double) _value);
}

- (long double) longDoubleValue
{
   return( (long double) _value);
}


- (void) getValue:(void *) p_value
{
   *(int64_t *) p_value = _value;
}


- (char *) objCType
{
   return( @encode( int64_t));
}


- (NSUInteger) hash
{
   return( NSNumberHashUnsignedIntegerBytes( &_value, sizeof( _value)));
}

- (enum MulleNumberIsEqualType) __mulleIsEqualType
{
   return( MulleNumberIsEqualLongLong);
}

@end


@implementation _MulleObjCUInt32Number : NSNumber

+ (instancetype) newWithUInt32:(uint32_t) value
{
   _MulleObjCUInt32Number  *obj;

   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = value;
   return( obj);
}


- (int32_t) _int32Value     {  return( (int32_t) _value); }
- (int64_t) _int64Value     {  return( (int64_t)_value); }

- (BOOL) boolValue          { return( _value ? YES : NO); }
- (char) charValue          { return( (char) _value); }
- (short) shortValue        { return( (short) _value); }
- (int) intValue            { return( (int) _value); }
- (long) longValue          { return( (long) _value); }
- (NSInteger) integerValue  { return( (NSInteger) _value); }
- (long long) longLongValue { return( (long long) _value); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _value); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _value); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _value); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _value); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _value); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _value); }

- (float) floatValue              { return( (float) _value); }
- (double) doubleValue            { return( (double) _value); }
- (long double) longDoubleValue   { return( (long double) _value); }


- (void) getValue:(void *) p_value
{
   *(uint32_t *) p_value = _value;
}


- (_ns_superquad) _superquadValue
{
   _ns_superquad  value;

   value.lo = _value;
   value.hi = 0;
   return( value);
}


- (char *) objCType
{
   return( @encode( uint32_t));
}


- (NSUInteger) hash
{
   return( NSNumberHashUnsignedIntegerBytes( &_value, sizeof( _value)));
}


- (enum MulleNumberIsEqualType) __mulleIsEqualType
{
   if( sizeof( int32_t) < sizeof( long long))
      return( MulleNumberIsEqualLongLong);
   return( MulleNumberIsEqualDefault);
}

@end


@implementation _MulleObjCUInt64Number : NSNumber

+ (instancetype) newWithUInt64:(uint64_t) value
{
   _MulleObjCUInt64Number  *obj;

   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = value;
   return( obj);
}

- (int32_t) _int32Value     { return( (int32_t) _value); }
- (int64_t) _int64Value     { return( (int64_t)_value); }

- (BOOL) boolValue          { return( _value ? YES : NO); }
- (char) charValue          { return( (char) _value); }
- (short) shortValue        { return( (short) _value); }
- (int) intValue            { return( (int) _value); }
- (long) longValue          { return( (long) _value); }
- (NSInteger) integerValue  { return( (NSInteger) _value); }
- (long long) longLongValue { return( (long long) _value); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _value); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _value); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _value); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _value); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _value); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _value); }

- (float) floatValue              { return( (float) _value); }
- (double) doubleValue            { return( (double) _value); }
- (long double) longDoubleValue   { return( (long double) _value); }

- (void) getValue:(void *) value
{
   *(uint64_t *) value = _value;
}


- (_ns_superquad) _superquadValue
{
   _ns_superquad  value;

   value.lo = _value;
   value.hi = 0;
   return( value);
}


- (char *) objCType
{
   return( @encode( uint64_t));
}


- (NSUInteger) hash
{
   return( NSNumberHashUnsignedIntegerBytes( &_value, sizeof( _value)));
}


- (enum MulleNumberIsEqualType) __mulleIsEqualType
{
   if( sizeof( int64_t) < sizeof( long long))
      return( MulleNumberIsEqualLongLong);
   return( MulleNumberIsEqualDefault);
}

@end



@implementation _MulleObjCBoolNumber : NSNumber

static struct
{
   _MulleObjCBoolNumber   *_yes;
   _MulleObjCBoolNumber   *_no;
} Self;


+ (void) initialize
{
   if( Self._yes)
      return;

   // could make these permanent, but possibly tricky
   // due to possibly being deinitialized too early ?
   Self._yes = NSAllocateObject( self, 0, NULL);
   Self._yes->_value = YES;
   Self._no  = NSAllocateObject( self, 0, NULL);
   Self._no->_value  = NO;
}


+ (void) deinitialize
{
   [Self._yes release];
   [Self._no release];
}


+ (instancetype) newWithBOOL:(BOOL) value
{
   _MulleObjCBoolNumber   *nr;

   nr = value ? Self._yes : Self._no;
   assert( nr);
   return( [nr retain]);
}

- (BOOL) __mulleIsBoolNumber
{
   return( YES);
}

- (int32_t) _int32Value               { return( (int32_t) _value); }
- (int64_t) _int64Value               { return( (int64_t) _value); }

- (BOOL) boolValue                    { return( _value); }
- (char) charValue                    { return( (char) _value); }
- (short) shortValue                  { return( (short) _value); }
- (int) intValue                      { return( (int) _value); }
- (long) longValue                    { return( (long) _value); }
- (NSInteger) integerValue            { return( (NSInteger) _value); }
- (long long) longLongValue           { return( (long long) _value); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _value); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _value); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _value); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _value); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _value); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _value); }

- (float) floatValue                  { return( (float) _value); }
- (double) doubleValue                { return( (double) _value); }
- (long double) longDoubleValue       { return( (long double) _value); }


- (void) getValue:(void *) value
{
   *(BOOL *) value = _value;
}

//
// tricky: @encode( BOOL) will give an "i"
// but we prefer to be a 'B', so that we can encode as a bool singleton
// it should be OK, since we are limited to this class, not all BOOL
// variables out there
//
- (char *) objCType
{
   static char   type[2] = { _C_BOOL, 0 };

   return( type);
}

- (NSUInteger) hash
{
   return( NSNumberHashUnsignedInteger( _value));
}


- (enum MulleNumberIsEqualType) __mulleIsEqualType
{
   return( MulleNumberIsEqualLongLong);
}

@end



/*
 * a is noticably faster than
 * b (intel i7)
 *
 * int   a( double x)
 * {
 *    if( x < LONG_MIN || x > LONG_MAX)
 *       return( 0);
 *    return( 1);
 * }
 *
 * int   b( double x)
 * {
 *    if( (long) x == x)
 *       return( 0);
 *    return( 1);
 * }
 *
 * but d is faster than c
 *
 * int   c( double x)
 * {
 *    double   y;
 *
 *    y = floor( x);
 *    if( y == x && y >= LONG_MIN && y <= LONG_MAX)
 *       return( 0);
 *    return( 1);
 * }
 *
 *
 * int   d( double x)
 * {
 *    long   y;
 *
 *    y = (long) x;
 *    if( (double) y == x)
 *       return( 0);
 *    return( 1);
 * }
 */



@implementation _MulleObjCFloatNumber : NSNumber

+ (instancetype) newWithFloat:(float) value
{
   _MulleObjCFloatNumber  *obj;

   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = isnan( value) ? NAN : value; // get rid of sign of -NAN
   return( obj);
}


// TODO: maybe check out
//       https://stackoverflow.com/questions/17035464/a-fast-method-to-round-a-double-to-a-32-bit-int-explained
- (NSInteger) integerValue
{
   return( (NSInteger) _value);
}


- (long long) longLongValue
{
   return( (long long) _value);
}


- (NSUInteger) unsignedIntegerValue
{
   return( (NSUInteger) _value);
}


- (unsigned long long) unsignedLongLongValue
{
   return( (unsigned long long) _value);
}


- (float) floatValue
{
   return( _value);
}


- (double) doubleValue
{
   return( _value);
}


- (long double) longDoubleValue
{
   return( _value);
}


- (void) getValue:(void *) value
{
   *(float *) value = _value;
}


- (char *) objCType
{
   return( @encode( float));
}


- (NSUInteger) hash
{
   return( NSNumberHashFloat( _value));
}

- (enum MulleNumberIsEqualType) __mulleIsEqualType
{
#ifdef _C_LNG_DBL
   return( MulleNumberIsEqualLongDouble);
#else
   return( MulleNumberIsEqualDouble);
#endif
}

@end


@implementation _MulleObjCDoubleNumber : NSNumber

+ (instancetype) newWithDouble:(double) value
{
   _MulleObjCDoubleNumber  *obj;

   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = isnan( value) ? NAN : value; // get rid of sign of -NAN
   return( obj);
}


// TODO: maybe check out
//       https://stackoverflow.com/questions/17035464/a-fast-method-to-round-a-double-to-a-32-bit-int-explained
- (NSInteger) integerValue
{
   return( (NSInteger) _value);
}


- (long long) longLongValue
{
   return( (long long) _value);
}


- (NSUInteger) unsignedIntegerValue
{
   return( (NSUInteger) _value);
}


- (unsigned long long) unsignedLongLongValue
{
   return( (unsigned long long) _value);
}


- (float) floatValue
{
   return( _value);
}


- (double) doubleValue
{
   return( _value);
}


- (long double) longDoubleValue
{
   return( _value);
}


- (void) getValue:(void *) value
{
   *(double *) value = _value;
}


- (char *) objCType
{
   return( @encode( double));
}


- (NSUInteger) hash
{
   return( NSNumberHashDouble( _value));
}

- (enum MulleNumberIsEqualType) __mulleIsEqualType
{
#ifdef _C_LNG_DBL
   return( MulleNumberIsEqualLongDouble);
#else
   return( MulleNumberIsEqualDouble);
#endif
}

@end


@implementation _MulleObjCLongDoubleNumber : NSNumber


+ (instancetype) newWithLongDouble:(long double) value
{
   _MulleObjCLongDoubleNumber  *obj;

   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = isnan( value) ? NAN : value;  // get rid of sign of -NAN
                                               // more cross-platformy
   return( obj);
}


- (float) floatValue
{
   return( (float) _value);
}


- (double) doubleValue
{
   return( (double) _value);
}


- (long double) longDoubleValue
{
   return( _value);
}


- (long long) longLongValue
{
   return( (long long) _value);
}


- (NSInteger) integerValue
{
   return( (NSInteger) _value);
}


- (void) getValue:(void *) value
{
   *(long double *) value = _value;
}


- (char *) objCType
{
   return( @encode( long double));
}


- (NSUInteger) hash
{
   return( NSNumberHashLongDouble( _value));
}


- (enum MulleNumberIsEqualType) __mulleIsEqualType
{
#ifdef _C_LNG_DBL
   return( MulleNumberIsEqualLongDouble);
#else
   return( MulleNumberIsEqualDouble);
#endif
}

@end


