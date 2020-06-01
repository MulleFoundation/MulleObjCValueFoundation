//
//  NSObject+NSString.h
//  MulleObjCValueFoundation
//
//  Created by Nat! on 09.05.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSMutableData.h"

#import "NSString+NSData.h"


@interface NSMutableData( NSString)

- (void) mulleReplaceInvalidCharactersWithASCIICharacter:(char) c
                                                encoding:(NSStringEncoding) encoding;
@end
