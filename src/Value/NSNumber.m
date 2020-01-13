//
//  NSNumber.m
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
#import "NSNumber.h"

// other files in this library
#import "_MulleObjCConcreteNumber.h"
#import "_MulleObjCTaggedPointerIntegerNumber.h"
#import "NSNumber-Private.h"


// private stuff from MulleObjC
#import <MulleObjC/private/mulle-objc-exceptionhandlertable-private.h>
#import <MulleObjC/private/mulle-objc-universeconfiguration-private.h>

// std-c dependencies
#import "import-private.h"

#include <string.h>


@implementation NSObject( _NSNumber)

- (BOOL) __isNSNumber
{
   return( NO);
}

@end


@interface NSObject( Initialize)

+ (void) initialize;

@end


@implementation NSNumber

- (BOOL) __isNSNumber
{
   return( YES);
}



#pragma mark - class cluster support

//
// it is useful for coverage, to make all possible subclasses known here
//
+ (void) initialize
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;

   universe = _mulle_objc_infraclass_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   // don't do it again for subclasses
   if( config->numbersubclasses[ _NSNumberClassClusterInt32Type])
      return;

   [super initialize]; // get MulleObjCClassCluster initialize

   assert( _MULLE_OBJC_FOUNDATIONINFO_N_NUMBERSUBCLASSES >= _NSNumberClassClusterNumberTypeMax);

//   config->numbersubclasses[ _NSNumberClassClusterInt8Type]       = [_MulleObjCInt8Number class];
//   config->numbersubclasses[ _NSNumberClassClusterInt16Type]      = [_MulleObjCInt16Number class];
   config->numbersubclasses[ _NSNumberClassClusterInt32Type]      = [_MulleObjCInt32Number class];
   config->numbersubclasses[ _NSNumberClassClusterInt64Type]      = [_MulleObjCInt64Number class];
   config->numbersubclasses[ _NSNumberClassClusterUInt32Type]     = [_MulleObjCUInt32Number class];
   config->numbersubclasses[ _NSNumberClassClusterUInt64Type]     = [_MulleObjCUInt64Number class];
   config->numbersubclasses[ _NSNumberClassClusterDoubleType]     = [_MulleObjCDoubleNumber class];
   config->numbersubclasses[ _NSNumberClassClusterLongDoubleType] = [_MulleObjCLongDoubleNumber class];
}


#define MULLE_C11_CONSUMED __attribute__((ns_consumed))

//
// MEMO: we are a subclass of NSValue and therefore inherit it's isEqual:
//       which is based on objCType amongst other checks. It is fairly
//       important, that at least for integer values we produce the same
//       subclasses for the same values, regardless if initWithInt: or
//       initWithLongLong: is used
//

static inline id   initWithBOOL( NSNumber *self,
                                 BOOL value)
{
   self = [MulleObjCBoolNumber newWithBOOL:value];
   return( self);
}


static inline id   initWithUInt32( NSNumber *self, uint32_t value)
{
#ifdef __MULLE_OBJC_TPS__
   if( MulleObjCTaggedPointerIsIntegerValue( value))
   {
      self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value);
   }
   else
#endif
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe                 *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      self = [config->numbersubclasses[ _NSNumberClassClusterUInt32Type] newWithUInt32:value];
   }
   return( self);
}

static inline id   initWithUInt64( NSNumber *self, uint64_t value)
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;

   assert( value > UINT32_MAX);

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   self = [config->numbersubclasses[ _NSNumberClassClusterUInt64Type] newWithUInt64:value];
   return( self);
}



static inline id   initWithInt32( NSNumber *self, int32_t value)
{
#ifdef __MULLE_OBJC_TPS__
   if( MulleObjCTaggedPointerIsIntegerValue( value))
   {
      self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value);
   }
   else
#endif
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe                 *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      self = [config->numbersubclasses[ _NSNumberClassClusterInt32Type] newWithInt32:value];
   }
   return( self);
}


static inline id   initWithInt64( NSNumber *self, int64_t value)
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;

   assert( value > INT32_MAX || value < INT32_MIN);

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   self = [config->numbersubclasses[ _NSNumberClassClusterInt64Type] newWithInt64:value];
   return( self);
}


#pragma mark - signed inits

static inline id   initWithChar( NSNumber *self,
                                 char value)
{
   assert( sizeof( char) <= sizeof( int32_t));

   return( initWithInt32( self, (int32_t) value));
}


static inline id   initWithShort( NSNumber *self, short value)
{
   assert( sizeof( short) <= sizeof( int32_t));

   return( initWithInt32( self, (int32_t) value));
}


static inline id   initWithInt( NSNumber *self, int value)
{
   assert( sizeof( int) <= sizeof( int64_t));

   if( sizeof( int) <= sizeof( uint32_t) || (value >= INT32_MIN && value <= INT32_MAX))
      return( initWithInt32( self, (int32_t) value));
   return( initWithInt64( self, (int64_t) value));
}


static inline id   initWithLong( NSNumber *self, long value)
{
   assert( sizeof( unsigned long) <= sizeof( int64_t));

   if( sizeof( unsigned long) <= sizeof( int32_t) || (value >= INT32_MIN && value <= INT32_MAX))
      return( initWithInt32( self, (int32_t) value));
   return( initWithInt64( self, (int64_t) value));
}


static inline id   initWithInteger( NSNumber *self,
                                    NSInteger value)
{
   assert( sizeof( NSInteger) <= sizeof( int64_t));

   if( sizeof( NSInteger) <= sizeof( uint32_t) || (value >= INT32_MIN && value <= INT32_MAX))
      return( initWithInt32( self, (uint32_t) value));
   return( initWithInt64( self, (int64_t) value));
}

static inline id   initWithLongLong( NSNumber *self,
                                    long long  value)
{
   assert( sizeof( long long) <= sizeof( int64_t));

   if( sizeof( long long) <= sizeof( int32_t) || (value >= INT32_MIN && value <= INT32_MAX))
      return( initWithInt32( self, (int32_t) value));
   return( initWithInt64( self, (int64_t) value));
}



# pragma signed init methods

- (instancetype) initWithChar:(char) value
{
   return( initWithChar( self, value));
}


- (instancetype) initWithShort:(short) value
{
   return( initWithShort( self, value));
}


- (instancetype) initWithInt:(int) value
{
   return( initWithInt( self, value));
}


- (instancetype) initWithLong:(long) value
{
   return( initWithLong( self, value));
}


- (instancetype) initWithInteger:(NSInteger) value
{
   return( initWithInteger( self, value));
}


- (instancetype) initWithLongLong:(long long) value
{
   return( initWithLongLong( self, value));
}



#pragma mark -
#pragma mark unsigned init

static inline id   initWithUnsignedChar( NSNumber *self,
                                         unsigned char value)
{
   assert( sizeof( unsigned char) <= sizeof( uint32_t));

   if( value <= CHAR_MAX)
      return( initWithChar( self, (char) value));
   return( initWithUInt32( self, (uint32_t) value));
}


static inline id   initWithUnsignedShort( NSNumber *self, unsigned short value)
{
   assert( sizeof( unsigned short) <= sizeof( uint32_t));

   if( value <= SHRT_MAX)
      return( initWithShort( self, (short) value));
   return( initWithUInt32( self, (uint32_t) value));
}

static inline id   initWithUnsignedInt( NSNumber *self, unsigned int value)
{
   assert( sizeof( unsigned int) <= sizeof( uint64_t));

   if( value <= INT_MAX)
      return( initWithInt( self, (int) value));

   if( sizeof( int) <= sizeof( uint32_t) || value <= UINT32_MAX)
      return( initWithUInt32( self, (uint32_t) value));
   return( initWithUInt64( self, (uint64_t) value));
}


static inline id   initWithUnsignedLong( NSNumber *self, unsigned long value)
{
   assert( sizeof( unsigned long) <= sizeof( uint64_t));

   if( value <= LONG_MAX)
      return( initWithLong( self, (long) value));

   if( sizeof( unsigned long) <= sizeof( uint32_t) || value <= UINT32_MAX)
      return( initWithUInt32( self, (uint32_t) value));
   return( initWithUInt64( self, (uint64_t) value));
}


static inline id   initWithUnsignedLongLong( NSNumber *self,
                                             unsigned long long  value)
{
   assert( sizeof( unsigned long long) <= sizeof( uint64_t));

   if( value <= LLONG_MAX)
      return( initWithLongLong( self, (long long) value));

   if( sizeof( unsigned long long) <= sizeof( uint32_t) || value <= UINT32_MAX)
      return( initWithUInt32( self, (uint32_t) value));
   return( initWithUInt64( self, (uint64_t) value));
}


static inline id   initWithUnsignedInteger( NSNumber *self,
                                            NSUInteger value)
{
   assert( sizeof( NSUInteger) <= sizeof( uint64_t));

   if( value <= NSIntegerMax)
      return( initWithInteger( self, (NSInteger) value));

   if( sizeof( NSUInteger) <= sizeof( uint32_t) || value <= UINT32_MAX)
      return( initWithUInt32( self, (uint32_t) value));
   return( initWithUInt64( self, (uint64_t) value));
}


#pragma mark - unsigned inits

- (instancetype) initWithBool:(BOOL) value
{
   return( initWithBOOL( self, value));
}


- (instancetype) initWithUnsignedChar:(unsigned char) value
{
   return( initWithUnsignedChar( self, value));
}


- (instancetype) initWithUnsignedShort:(unsigned short) value
{
   return( initWithUnsignedShort( self, value));
}


- (instancetype) initWithUnsignedInt:(unsigned int) value
{
   return( initWithUnsignedInt( self, value));
}


- (instancetype) initWithUnsignedLong:(unsigned long) value
{
   return( initWithUnsignedLong( self, value));
}


- (instancetype) initWithUnsignedInteger:(NSUInteger) value
{
   return( initWithUnsignedInteger( self, value));
}


- (instancetype) initWithUnsignedLongLong:(unsigned long long) value
{
   return( initWithUnsignedLongLong( self, value));
}


#pragma mark -
#pragma marl FP inits


//
// a problem with these casts are, that they raise FP exceptions
// if the CPU is so configured, which we don't really want to happen
//
// MULLE_C_NEVER_INLINE
// static int   double_fits_long_long( double *value, long long *ll_val)
// {
//    double   v;
//
//    v       = *value;
//    *ll_val = (long long) v;
//    return( (double) *ll_val == v);
// }
//
//
// MULLE_C_NEVER_INLINE
// static int   double_fits_unsigned_long_long( double *value,
//                                              unsigned long long *ull_val)
// {
//    double   v;
//
//    v        = *value;
//    *ull_val = (unsigned long long) v;
//    return( (double) *ull_val == v);
// }


static inline id   initWithDouble( NSNumber *self, double value)
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   long long                                   ll_val;
   unsigned long long                          ull_val;

   //
   // don't want to link against -lm so keep to C for calculations
   // we only check integers known to fit into IEE-754 FP
   //
   // Then the cast can not "overflow"
   //
   if( value >= (double) -((1L<<52)+1) && value <= (double) ((1L<<52)+1))
   {
      ll_val = (long long) value;
      if( (double) ll_val == value)
         return( initWithLongLong( self, ll_val));
   }

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   self = [config->numbersubclasses[ _NSNumberClassClusterDoubleType] newWithDouble:value];
   return( self);
}


static inline id   initWithLongDouble( NSNumber *self, long double value)
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   long long                                   ll_val;
   unsigned long long                          ull_val;

   // see comment above
   if( value >= (double) -((1L<<52)+1) && value <= (double) ((1L<<52)+1))
   {
      ll_val = (long long) value;
      if( (long double) ll_val == value)
         return( initWithLongLong( self, ll_val));
   }

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   self = [config->numbersubclasses[ _NSNumberClassClusterLongDoubleType] newWithLongDouble:value];
   return( self);
}


- (instancetype) initWithFloat:(float) value
{
   return( initWithDouble( self, value));
}


- (instancetype) initWithDouble:(double) value
{
   return( initWithDouble( self, value));
}


- (instancetype) initWithLongDouble:(long double) value
{
   return( initWithLongDouble( self, value));
}


#pragma mark -
#pragma mark NSValue init


- (instancetype) initWithBytes:(void *) value
                      objCType:(char *) type
{
   if( ! value)
      MulleObjCThrowInvalidArgumentExceptionCString( "empty bytes");
   if( ! type)
      MulleObjCThrowInvalidArgumentExceptionCString( "empty type");

   switch( type[ 0])
   {
   case _C_BOOL     : return( initWithBOOL( self, *(BOOL *) value));
   case _C_CHR      : return( initWithChar( self, *(char *) value));
   case _C_UCHR     : return( initWithUnsignedChar( self, *(unsigned char *) value));
   case _C_SHT      : return( initWithShort( self, *(short *) value));
   case _C_USHT     : return( initWithUnsignedShort( self, *(unsigned short *) value));
   case _C_INT      : return( initWithInt( self, *(int *) value));
   case _C_UINT     : return( initWithUnsignedInt( self, *(unsigned int *) value));
   case _C_LNG      : return( initWithLong( self, *(long *) value));
   case _C_ULNG     : return( initWithUnsignedLong( self, *(unsigned long *) value));
   case _C_LNG_LNG  : return( initWithLongLong( self, *(long long *) value));
   case _C_ULNG_LNG : return( initWithUnsignedLongLong( self, *(unsigned long long *) value));

   case _C_FLT      : return( [self initWithFloat:*(float *) value]);
   case _C_DBL      : return( [self initWithDouble:*(double *) value]);
   case _C_LNG_DBL  : return( [self initWithLongDouble:*(long double *) value]);
   default          : MulleObjCThrowInvalidArgumentExceptionCString( "unknown type '%c'", type[ 0]);
   }
}


#pragma mark - convenience constructors

// don't short-circuit for subclasses

+ (instancetype) numberWithBool:(BOOL) value
{
   return( [[[self alloc] initWithBool:value] autorelease]);
}


+ (instancetype) numberWithChar:(char) value
{
   return( [[[self alloc] initWithChar:value] autorelease]);
}


+ (instancetype) numberWithUnsignedChar:(unsigned char) value
{
   return( [[[self alloc] initWithUnsignedChar:value] autorelease]);
}


+ (instancetype) numberWithShort:(short) value
{
   return( [[[self alloc] initWithShort:value] autorelease]);
}


+ (instancetype) numberWithUnsignedShort:(unsigned short) value
{
   return( [[[self alloc] initWithUnsignedShort:value] autorelease]);
}


+ (instancetype) numberWithInt:(int) value
{
   return( [[[self alloc] initWithInt:value] autorelease]);
}


+ (instancetype) numberWithUnsignedInt:(unsigned int) value;
{
   return( [[[self alloc] initWithUnsignedInt:value] autorelease]);
}


+ (instancetype) numberWithLong:(long) value
{
   return( [[[self alloc] initWithLong:value] autorelease]);
}


+ (instancetype) numberWithUnsignedLong:(unsigned long) value
{
   return( [[[self alloc] initWithUnsignedLong:value] autorelease]);
}


+ (instancetype) numberWithInteger:(NSInteger) value
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (instancetype) numberWithUnsignedInteger:(NSUInteger) value
{
   return( [[[self alloc] initWithUnsignedInteger:value] autorelease]);
}


+ (instancetype) numberWithLongLong:(long long) value
{
   return( [[[self alloc] initWithLongLong:value] autorelease]);
}


+ (instancetype) numberWithUnsignedLongLong:(unsigned long long) value
{
   return( [[[self alloc] initWithUnsignedLongLong:value] autorelease]);
}


+ (instancetype) numberWithFloat:(float) value
{
   return( [[[self alloc] initWithFloat:value] autorelease]);
}


+ (instancetype) numberWithDouble:(double) value
{
   return( [[[self alloc] initWithDouble:value] autorelease]);
}


+ (instancetype) numberWithLongDouble:(long double) value
{
   return( [[[self alloc] initWithLongDouble:value] autorelease]);
}


#pragma mark -
#pragma mark operations

/*
 * this compare: "properly" promotes all comparisons to unsigned
 * if one ot the two numbers is unsigned (and not FP)
 * this is I believe different from Apple
 */
#define _C_SUPERQUAD  1848

// returns
//  _C_INT          // 32 bit
//  _C_LNG_LNG      // 64 bit
//  _C_SUPERQUAD    // 128 bit
//  _C_DBL          // double
//  _C_LNG_DBL      // double

static int  simplify_type_for_comparison( int type)
{
   switch( type)
   {
   case _C_BOOL :
   case _C_CHR  :
   case _C_SHT  :
   case _C_INT  :
   case _C_UCHR :
   case _C_USHT :
      return( _C_INT);

   case _C_UINT :
       if( sizeof( unsigned int) == sizeof( int32_t))
          return( _C_LNG_LNG);
       return( _C_SUPERQUAD);

   case _C_LNG :
      if( sizeof( long) == sizeof( int32_t))
         return( _C_INT);
      return( _C_LNG_LNG);

   case _C_ULNG :
      if( sizeof( unsigned long) == sizeof( int32_t))
         return( _C_LNG_LNG);
      return( _C_SUPERQUAD);

   case _C_LNG_LNG :
       return( _C_LNG_LNG);

   case _C_ULNG_LNG :
      return( _C_SUPERQUAD);

   case _C_FLT     :
      return( _C_DBL);
   }
   return( type);
}


//
// generic routines for all
//
- (_ns_superquad) _superquadValue
{
   _ns_superquad  value;
   long long             x;

   x        = [self longLongValue];
   value.lo = x;
   value.hi = (x < 0) ? ~0 : 0;
   return( value);
}


- (int32_t) _int32Value
{
   return( (int32_t) [self integerValue]);
}


- (int64_t) _int64Value
{
   return( (int64_t) [self longLongValue]);
}


- (NSComparisonResult) compare:(NSNumber *) other
{
   char            *p_type;
   char            *p_other_type;
   int32_t         a32, b32;
   int64_t         a64, b64;
   _ns_superquad   a128, b128;
   double          da, db;
   long double     lda, ldb;
   int             type;
   int             other_type;

   // apple dox says: must be a number, can't be nil

   assert( [other __isNSNumber]);

   p_type       = [self objCType];
   p_other_type = other ? [other objCType] : @encode( int);

   assert( p_type && strlen( p_type) == 1);
   assert( p_other_type && strlen( p_other_type) == 1);

   type       = simplify_type_for_comparison( *p_type);
   other_type = simplify_type_for_comparison( *p_other_type);

   switch( type)
   {
   default  : goto bail;
   case _C_INT :
      switch( other_type)
      {
      default           : goto bail;
      case _C_INT       : goto do_32_32_diff;
      case _C_LNG_LNG   : goto do_64_64_diff;
      case _C_SUPERQUAD : goto do_128_128_diff;
      case _C_DBL       : goto do_d_d_diff;
      case _C_LNG_DBL   : goto do_ld_ld_diff;
      }

   case _C_LNG_LNG :
      switch( other_type)
      {
      default           : goto bail;
      case _C_INT       :
      case _C_LNG_LNG   : goto do_64_64_diff;
      case _C_SUPERQUAD : goto do_128_128_diff;
      case _C_DBL       : goto do_d_d_diff;
      case _C_LNG_DBL   : goto do_ld_ld_diff;
      }


   case _C_SUPERQUAD :
      switch( other_type)
      {
      default           : goto bail;
      case _C_INT       :
      case _C_LNG_LNG   :
      case _C_SUPERQUAD : goto do_128_128_diff;
      case _C_DBL       : goto do_d_d_diff;
      case _C_LNG_DBL   : goto do_ld_ld_diff;
      }

   case _C_DBL          : goto do_d_d_diff;
   case _C_LNG_DBL      : goto do_ld_ld_diff;
   }

   // TODO: check for unsigned comparison
   // hint: don't do subtraction
do_32_32_diff:
   a32 = [self _int32Value];
   b32 = [other _int32Value];
   if( a32 == b32)
      return( NSOrderedSame);
   return( a32 < b32 ? NSOrderedAscending : NSOrderedDescending);

do_64_64_diff :
   a64 = [self _int64Value];
   b64 = [other _int64Value];
   if( a64 == b64)
      return( NSOrderedSame);
   return( a64 < b64 ? NSOrderedAscending : NSOrderedDescending);

do_128_128_diff :
   a128 = [self _superquadValue];
   b128 = [other _superquadValue];
   return( _ns_superquad_compare( a128, b128));

do_d_d_diff :
   da = [self doubleValue];
   db = [other doubleValue];
   if( da == db)
      return( NSOrderedSame);
   return( da < db ? NSOrderedAscending : NSOrderedDescending);

do_ld_ld_diff :
   lda = [self longDoubleValue];
   ldb = [other longDoubleValue];
   if( lda == ldb)
      return( NSOrderedSame);
   return( lda < ldb ? NSOrderedAscending : NSOrderedDescending);

bail:
   MulleObjCThrowInternalInconsistencyExceptionCString( "unknown objctype");
}


#pragma mark - hash and equality

// NSNumbers are NSValues so don't do isEqual: or hash

- (BOOL) isEqualToNumber:(NSNumber *) other
{
   if( self == other)
      return( YES);
   return( [other compare:self] == NSOrderedSame);
}


- (id) copy
{
   return( [self retain]);
}



#pragma mark -
#pragma mark value conversion from primitives

- (BOOL) boolValue
{
   return( [self integerValue] ? YES : NO);
}


- (char) charValue
{
   return( (char) [self integerValue]);
}


- (unsigned char) unsignedCharValue
{
   return( (unsigned char) [self integerValue]);
}


- (short) shortValue
{
   return( (short) [self integerValue]);
}


- (unsigned short) unsignedShortValue
{
   return( (unsigned short) [self integerValue]);
}


- (int) intValue
{
   return( (int) [self integerValue]);
}


- (unsigned int) unsignedIntValue
{
   return( (unsigned int) [self integerValue]);
}


- (long) longValue
{
   assert( sizeof( NSInteger) >= sizeof( long));
   return( (long) [self integerValue]);
}


- (unsigned long) unsignedLongValue
{
   assert( sizeof( NSInteger) >= sizeof( unsigned long));
   return( (unsigned long) [self integerValue]);
}


- (NSUInteger) unsignedIntegerValue
{
   return( (NSUInteger) [self integerValue]);
}


- (float) floatValue
{
   return( (float) [self doubleValue]);
}


- (unsigned long long) unsignedLongLongValue
{
   return( (unsigned long long) [self longLongValue]);
}


// a default for the placeholder (debugging help)
- (char *) objCType
{
   return( @encode( void));
}


@end


@implementation MulleObjCBoolNumber : NSNumber

static struct
{
   MulleObjCBoolNumber   *_yes;
   MulleObjCBoolNumber   *_no;
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
   MulleObjCBoolNumber   *nr;

   nr = value ? Self._yes : Self._no;
   assert( nr);
   return( [nr retain]);
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
   return( MulleObjCBytesHash( &_value, sizeof( _value)));
}

@end
