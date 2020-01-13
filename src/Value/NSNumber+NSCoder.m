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

#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSNumber class]);
}


- (void) decodeWithCoder:(NSCoder *) coder
{
}

@end
