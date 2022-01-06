//
//  NSDate+NSCoder.m
//  MulleObjCValueFoundation
//
//  Created by Nat! on 07.01.22.
//  Copyright © 2022 Mulle kybernetiK. All rights reserved.
//

#import "NSDate+NSCoder.h"

// other libraries of MulleObjCValueFoundation
#import "_MulleObjCDateSubclasses.h"

// std-c dependencies
#import "import-private.h"



@implementation NSDate( NSCoder)

#pragma mark - NSCoding

- (Class) classForCoder
{
   return( [NSDate class]);
}

- (instancetype) initWithCoder:(NSCoder *) coder
{
   NSTimeInterval   value;

   [coder decodeValueOfObjCType:@encode( NSTimeInterval)
                             at:&value];
   return( [self initWithTimeIntervalSinceReferenceDate:value]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSTimeInterval   value;

   value = [self timeIntervalSinceReferenceDate];
   [coder encodeValueOfObjCType:@encode( NSTimeInterval)
                             at:&value];
}


- (void) decodeWithCoder:(NSCoder *) coder
{
}

@end

