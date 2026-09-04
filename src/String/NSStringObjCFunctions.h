//
//  NSStringObjCFunctions.h
//  MulleObjCValueFoundation
//
//  Copyright (c) 2017 Nat! - Mulle kybernetiK.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "import.h"


@class NSString;


MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
Class       MulleObjCClassFromString( NSString *s);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
SEL         MulleObjCSelectorFromString( NSString *s);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *MulleObjCStringFromClass( Class cls);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *MulleObjCStringFromSelector( SEL sel);

MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *MulleObjCStringFromRange( NSRange range);


// in order on darwin to not clobber the links symbols of foundation
// we only use MulleObjC prefix, but the static inline gives the 
// familiar name
static inline Class   NSClassFromString( NSString *s)
{
   return( MulleObjCClassFromString( s));
}


static inline SEL   NSSelectorFromString( NSString *s)
{
   return( MulleObjCSelectorFromString( s));
}


static inline NSString   *NSStringFromClass( Class cls)
{
   return( MulleObjCStringFromClass( cls));
}


static inline NSString   *NSStringFromSelector( SEL sel)
{
   return( MulleObjCStringFromSelector( sel));
}


static inline NSString   *NSStringFromRange( NSRange range)
{
   return( MulleObjCStringFromRange( range));
}



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
