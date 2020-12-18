//
//  NSObjCStringFunctions.h
//  MulleObjCValueFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "import.h"


@class NSString;

Class       NSClassFromString( NSString *s);
SEL         NSSelectorFromString( NSString *s);
NSString   *NSStringFromClass( Class cls);
NSString   *NSStringFromSelector( SEL sel);
NSString   *NSStringFromRange( NSRange range);

NSString   *
   MulleObjCStringByCombiningPrefixAndCapitalizedKey( NSString *prefix,
                                                      NSString *key,
                                                      BOOL tailingColon);
