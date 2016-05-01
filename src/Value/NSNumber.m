/*
 *  NSTinyFoundation - A tiny Foundation replacement
 *
 *  NSNumber.m is a part of NSTinyFoundation
 *
 *  Copyright (C) 2011 Nat!, NS kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSNumber.h"

// other files in this library
#import "_MulleObjCConcreteNumber.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c dependencies
#include <string.h>


@implementation NSObject( NSNumber)

- (BOOL) __isNSNumber
{
   return( NO);
}

@end


@implementation NSNumber

- (BOOL) __isNSNumber
{
   return( YES);
}


- (id) initWithBytes:(void *) value
            objCType:(char *) type
{
   NSInteger  i;
   long long  q;
   double     d;
   
   switch( type[ 0])
   {
   case _C_CHR : i = *(char *) value;           goto handle_i;
   case _C_UCHR : i = *(unsigned char *) value;  goto handle_i;
   case _C_SHT : i = *(short *) value;          goto handle_i;
   case _C_USHT : i = *(unsigned short *) value; goto handle_i;
   case _C_INT : i = *(int *) value;            goto handle_i;
   case _C_UINT : i = *(unsigned int *) value;   goto handle_i;
   case _C_LNG : i = *(long *) value;           goto handle_i;
   case _C_ULNG : i = *(unsigned long *) value;  goto handle_i;
   case _C_LNG_LNG : q = *(long long *) value;      goto handle_q;
   case _C_ULNG_LNG : q = *(unsigned long long *) value; goto handle_q;
   case _C_FLT : d = *(float *) value;          goto handle_d;
   case _C_DBL : d = *(double *) value;         goto handle_d;
   }
   return( nil);
   
handle_i:
   return( [self initWithInteger:i]);
   
handle_q:
   return( [self initWithLongLong:q]);

handle_d:
   return( [self initWithDouble:d]);
}


- (id) initWithInteger:(NSInteger) value
{
   _MulleObjCIntegerNumber  *nr;
   
   [self release];

   nr = [[_MulleObjCIntegerNumber alloc] initWithInteger:value];
   return( nr);
}


- (id) initWithLongDouble:(long double) value
{
   _MulleObjCLongDoubleNumber  *nr;
   
   [self release];
   
   nr = [[_MulleObjCLongDoubleNumber alloc] initWithLongDouble:value];
   return( nr);
}


- (id) initWithDouble:(double) value
{
   _MulleObjCDoubleNumber  *nr;
   
   [self release];

   nr = [[_MulleObjCDoubleNumber alloc] initWithDouble:value];
   return( nr);
}


- (id) initWithLongLong:(long long) value
{
   _MulleObjCLongLongNumber  *nr;
   
   [self release];
   
   nr = [[_MulleObjCLongLongNumber alloc] initWithLongLong:value];
   return( nr);
}


- (id) initWithBool:(BOOL) value
{
   return( [self initWithInteger:value ? YES : NO]);
}


- (id) initWithChar:(char) value
{
   return( [self initWithInteger:value]);
}


- (id) initWithUnsignedChar:(unsigned char) value
{
   return( [self initWithInteger:value]);
}


- (id) initWithShort:(short) value
{
   return( [self initWithInteger:value]);
}


- (id) initWithUnsignedShort:(unsigned short) value
{
   return( [self initWithInteger:value]);
}


- (id) initWithInt:(int) value
{
   return( [self initWithInteger:value]);
}


- (id) initWithUnsignedInt:(unsigned int) value
{
   return( [self initWithInteger:value]);
}


- (id) initWithLong:(long) value
{
   return( [self initWithInteger:value]);
}


- (id) initWithUnsignedLong:(unsigned long) value
{
   return( [self initWithInteger:value]);
}


- (id) initWithUnsignedInteger:(NSUInteger) value
{
   return( [self initWithInteger:value]);
}


- (id) initWithUnsignedLongLong:(unsigned long long) value
{
   return( [self initWithLongLong:value]);
}


- (id) initWithFloat:(float) value
{
   return( [self initWithDouble:value]);
}


+ (id) numberWithBool:(BOOL) value
{
   return( [[[self alloc] initWithInteger:value ? YES : NO] autorelease]);
}


+ (id) numberWithChar:(char) value
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (id) numberWithUnsignedChar:(unsigned char) value
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (id) numberWithShort:(short) value
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (id) numberWithUnsignedShort:(unsigned short) value
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (id) numberWithInt:(int) value
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (id) numberWithUnsignedInt:(unsigned int) value;
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (id) numberWithLong:(long) value
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (id) numberWithUnsignedLong:(unsigned long) value
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (id) numberWithInteger:(NSInteger) value
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (id) numberWithUnsignedInteger:(NSUInteger) value
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (id) numberWithLongLong:(long long) value
{
   return( [[[self alloc] initWithLongLong:value] autorelease]);
}


+ (id) numberWithUnsignedLongLong:(unsigned long long) value
{
   return( [[[self alloc] initWithLongLong:value] autorelease]);
}


+ (id) numberWithFloat:(float) value
{
   return( [[[self alloc] initWithDouble:value] autorelease]);
}


+ (id) numberWithDouble:(double) value
{
   return( [[[self alloc] initWithDouble:value] autorelease]);
}


+ (id) numberWithLongDouble:(long double) value
{
   return( [[[self alloc] initWithLongDouble:value] autorelease]);
}


- (NSComparisonResult) compare:(id) other
{
   char             *type;
   char             *other_type;
   NSInteger        ldiff;
   long long        qdiff;
   double           ddiff;
   long double      lddiff;
   
   type       = [self objCType];
   other_type = [other objCType];
   
   NSCParameterAssert( type && strlen( type) == 1);
   NSCParameterAssert( other_type && strlen( other_type) == 1);
   
   switch( *type)
   {
   default  : goto bail;
   case _C_CHR : 
   case _C_UCHR :
   case _C_SHT : 
   case _C_USHT : 
   case _C_INT : 
   case _C_UINT : 
   case _C_LNG : 
   case _C_ULNG : 
         switch( *other_type)
         {
         default  : goto bail;
         case _C_CHR :
         case _C_UCHR :
         case _C_SHT :
         case _C_USHT :
         case _C_INT :
         case _C_UINT : 
         case _C_LNG : 
         case _C_ULNG : goto do_integer_diff;
            
         case _C_LNG_LNG : 
         case _C_ULNG_LNG : goto do_long_long_diff;
               
         case _C_FLT : 
         case _C_DBL : goto do_double_diff;
         case 'D' : goto do_long_double_diff;
         }

   case _C_LNG_LNG : 
   case _C_ULNG_LNG : 
         switch( *other_type)
         {
         default  : goto bail;
         case _C_CHR :
         case _C_UCHR :
         case _C_SHT :
         case _C_USHT :
         case _C_INT :
         case _C_UINT : 
         case _C_LNG : 
         case _C_ULNG :
         case _C_LNG_LNG :
         case _C_ULNG_LNG : goto do_long_long_diff;
               
         case _C_FLT : 
         case _C_DBL : goto do_double_diff;
         case 'D' : goto do_long_double_diff;
         }
   
   case _C_FLT : 
   case _C_DBL : goto do_double_diff;
   case 'D' : goto do_long_double_diff;
   }
   
   // TODO: check for unsigned comparison
do_integer_diff:
   ldiff = [self integerValue] - [other integerValue];
   return( ldiff < 0 ? NSOrderedDescending : (! ldiff ? NSOrderedSame : NSOrderedAscending));

do_long_long_diff :   
   qdiff = [self longLongValue] - [other longLongValue];
   return( qdiff < 0 ? NSOrderedDescending : (! qdiff ? NSOrderedSame : NSOrderedAscending));

do_double_diff :   
   ddiff = [self doubleValue] - [other doubleValue];
   return( ddiff < 0 ? NSOrderedDescending : (ddiff == 0.0 ? NSOrderedSame : NSOrderedAscending));

do_long_double_diff :
   lddiff = [self longDoubleValue] - [other longDoubleValue];
   return( lddiff < 0 ? NSOrderedDescending : (lddiff == 0.0 ? NSOrderedSame : NSOrderedAscending));
   
bail:
   MulleObjCThrowInternalInconsistencyException( @"unknown objctype");
   return( 0);
}


- (NSUInteger) hash
{
   NSUInteger  value;
   uintptr_t   hash;
   
   value = [self unsignedIntegerValue];
   hash  = mulle_hash( &value, sizeof( NSUInteger)); // stay compatible to NSValue
   
   return( hash);
}


- (BOOL) isEqualToNumber:(NSNumber *) other
{
   if( self == other)
      return( YES);
   return( [self compare:other] == NSOrderedSame);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other isKindOfClass:[NSNumber class]])
      return( NO);
   return( [self isEqualToNumber:other]);
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


@end
