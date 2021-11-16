//
//  NSObjCStringFunctions.h
//  MulleObjCValueFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "import.h"


@class NSString;

MULLE_OBJC_VALUE_FOUNDATION_EXTERN_GLOBAL
Class       NSClassFromString( NSString *s);

MULLE_OBJC_VALUE_FOUNDATION_EXTERN_GLOBAL
SEL         NSSelectorFromString( NSString *s);

MULLE_OBJC_VALUE_FOUNDATION_EXTERN_GLOBAL
NSString   *NSStringFromClass( Class cls);

MULLE_OBJC_VALUE_FOUNDATION_EXTERN_GLOBAL
NSString   *NSStringFromSelector( SEL sel);

MULLE_OBJC_VALUE_FOUNDATION_EXTERN_GLOBAL
NSString   *NSStringFromRange( NSRange range);

MULLE_OBJC_VALUE_FOUNDATION_EXTERN_GLOBAL
NSString   *
   MulleObjCStringByCombiningPrefixAndCapitalizedKey( NSString *prefix,
                                                      NSString *key,
                                                      BOOL tailingColon);
