//
//  NSNumber+NSCoder.m
//  MulleObjCValueFoundation
//
//  Created by Nat! on 09.05.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
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
