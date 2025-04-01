//
//  NSObject+NSString.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

// other files in this library
#import "NSString.h"
#import "NSString+Sprintf.h"
#import "NSString+Sprintf.h"
#import "NSStringObjCFunctions.h"

// other libraries of MulleObjCValueFoundation
#import "import-private.h"

// std-c and dependencies
#include <ctype.h>
#import <MulleObjC/NSDebug.h>


@implementation NSObject( NSString)

// this is like MulleObjC does it for UTF8 just for NSString here
+ (NSString *) description
{
   return( NSStringFromClass( self));
}

- (NSString *) description
{
   return( [NSString stringWithUTF8String:MulleObjCObjectUTF8String( self)]);
}


//
// It's assumed Foundation users will prefer writing -description over
// UTF8String
//
- (char *) UTF8String
{
   return( [[self description] UTF8String]);
}


// this is unqoted for NSData, NSDictionary etc.
- (NSString *) mulleQuotedDescriptionIfNeeded
{
   return( [self description]);
}


- (NSString *) mulleTestDescription
{
   return( [self description]);
}


//
// This method should be marked as thread safe, it is assumed that ONLY
// the debugger calls it and that therefore all other threads are stopped
// 
- (NSString *) mulleDebugContentsDescription      MULLE_OBJC_THREADSAFE_METHOD
{
   return( nil);
}

//
// This method should be marked as thread safe, it is assumed that ONLY
// the debugger calls it and that therefore all other threads are stopped
// 
- (NSString *) debugDescription                   MULLE_OBJC_THREADSAFE_METHOD
{
   NSString         *contents;
   NSUInteger       length;

   @try
   {
      contents = [self mulleDebugContentsDescription];
      length   = [contents length];
   }
   @catch( id exception)
   {
      contents = @"";
      length   = 0;
   }

   if( MulleObjCDebugElideAddressOutput)
   {
      if( ! length)
         return( [NSString stringWithFormat:@"<%@>", [self class]]);

      if( length >= 8192)
         return( [NSString stringWithFormat:@"<%@ %.8192@...>", [self class], contents]);

      return( [NSString stringWithFormat:@"<%@ %@>", [self class], contents]);
   }

   if( ! length)
      return( [NSString stringWithFormat:@"<%@ %p>", [self class], self]);

   if( length >= 8192)
      return( [NSString stringWithFormat:@"<%@ %p %.8192@...>", [self class], self, contents]);

   return( [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, contents]);
}


@end
