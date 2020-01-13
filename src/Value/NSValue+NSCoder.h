//
//  NS+NSCoder.h
//  MulleObjCValueFoundation
//
//  Created by Nat! on 12.04.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

// just all the same, 8 different headers would be tedious
#import "NSValue.h"

#import "import.h"


@interface NSValue (NSCoder) <NSCoding>

- (void) encodeWithCoder:(NSCoder *) coder;
- (instancetype) initWithCoder:(NSCoder *) coder;
- (void) decodeWithCoder:(NSCoder *) coder;

@end
