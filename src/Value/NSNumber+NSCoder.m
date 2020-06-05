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

#import "_MulleObjCTaggedPointerIntegerNumber.h"


@interface _MulleObjCTaggedPointerIntegerNumber( NSCoder) < NSCoding>
@end

@implementation _MulleObjCTaggedPointerIntegerNumber( NSCoder)

#pragma mark - NSCoding

- (void) encodeWithCoder:(NSCoder *) coder
{
   NSInteger      value;
   char           *type;

   value = _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self);
   type  = @encode( NSInteger);
   [coder encodeBytes:@encode( NSInteger)
               length:1+1]; // trailing 0
   [coder encodeValueOfObjCType:type
                             at:&value];
}

@end

#endif
