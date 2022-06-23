//
//  NSObjCStringFunctions.h
//  MulleObjCValueFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "import.h"


@class NSString;

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
Class       NSClassFromString( NSString *s);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
SEL         NSSelectorFromString( NSString *s);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *NSStringFromClass( Class cls);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *NSStringFromSelector( SEL sel);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *NSStringFromRange( NSRange range);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *
   MulleObjCStringByCombiningPrefixAndCapitalizedKey( NSString *prefix,
                                                      NSString *key,
                                                      BOOL tailingColon);

//
// MEMO: these functions are here and not in MulleObjC, where they
//       technically would fit, because we a) don't want a @class NSString
//       forward in MulleObjC b) we want the NSString type for the format
//
MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
int   MulleObjCPrintf( NSString *format, ...);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
int   MulleObjCFprintf( FILE *fp,  NSString *format, ...);


static inline
int   MulleObjCVPrintf( NSString *format, va_list va)
{
   return( mulle_vprintf( [format UTF8String], va));
}

static inline
int   MulleObjCVFprintf( FILE *fp, NSString *format, va_list va)
{
   return( mulle_vfprintf( fp, [format UTF8String], va));
}

static inline
int   MulleObjCMVPrintf( NSString *format, mulle_vararg_list arguments)
{
   return( mulle_mvprintf( [format UTF8String], arguments));
}

static inline
int  MulleObjCMVFprintf( FILE *fp, NSString *format, mulle_vararg_list arguments)
{
   return( mulle_mvfprintf( fp, [format UTF8String], arguments));
}
