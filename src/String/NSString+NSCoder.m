//
//  NSString+NSCoder.m
//  MulleObjCValueFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSString+NSCoder.h"

#import "NSString+ClassCluster.h"

#import "import-private.h"


@implementation NSString (NSCoder)

#pragma mark - NSCoding

- (Class) classForCoder
{
   return( [NSString class]);
}


- (instancetype) initWithCoder:(NSCoder *) coder
{
   void         *bytes;
   NSUInteger   length;

   bytes = [coder decodeBytesWithReturnedLength:&length];
   return( [self mulleInitWithUTF8Characters:bytes
                                  length:length]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   char         *bytes;
   NSUInteger   length;

   bytes  = [self UTF8String];
   length = [self mulleUTF8StringLength];
   [coder encodeBytes:bytes
               length:length + 1];
}


- (void) decodeWithCoder:(NSCoder *) coder
{
}

@end
