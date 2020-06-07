//
//  _MulleObjCConcreteNumber+NSString.m
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

#import "_MulleObjCConcreteNumber.h"
#import "_MulleObjCTaggedPointerIntegerNumber.h"


// other files in this library
#import "NSString.h"
#import "NSString+Sprintf.h"
#import "NSString+Substring-Private.h"

// std-c dependencies
#import "import-private.h"

#include <float.h>


static char  *convert_decimal_uint32_t( uint32_t value, char *s, size_t len)
{
   s = &s[ len];
   do
   {
      *--s   = '0' + value % 10;
      value /= 10;
   }
   while( value);

   return( s);
}


static char  *convert_decimal_uint64_t( uint64_t value, char *s, size_t len)
{
   s = &s[ len];
   do
   {
      *--s   = '0' + value % 10;
      value /= 10;
   }
   while( value);

   return( s);
}


static struct _MulleStringContext   empty;


@implementation _MulleObjCUInt32Number( NSString)

- (struct mulle_ascii_data) _mulleConvertToASCIICharacters:(struct mulle_ascii_data) data
{
   struct mulle_ascii_data   rval;

   assert( data.length>= 16);
   rval.characters = convert_decimal_uint32_t( _value, data.characters, data.length);
   rval.length     = data.length - (rval.characters - data.characters);
   return( rval);
}


- (NSString *) stringValue
{
   char                      tmp[ 16];
   struct mulle_ascii_data   string;

   string = [self _mulleConvertToASCIICharacters:mulle_ascii_data_make( tmp, sizeof( tmp))];
   return( [_mulleNewASCIIStringWithStringContext( string.characters,
                                                   &string.characters[ string.length],
                                                   &empty) autorelease]);
}

@end


@implementation _MulleObjCUInt64Number( NSString)

- (struct mulle_ascii_data) _mulleConvertToASCIICharacters:(struct mulle_ascii_data) data
{
   struct mulle_ascii_data   rval;

   assert( data.length>= 32);
   rval.characters = convert_decimal_uint64_t( _value, data.characters, data.length);
   rval.length     = data.length - (rval.characters - data.characters);
   return( rval);
}


- (NSString *) stringValue
{
   char                      tmp[ 32];  // max: 18,xxx,xxx,xxx,xxx,xxx,xxx
   struct mulle_ascii_data   string;

   string = [self _mulleConvertToASCIICharacters:mulle_ascii_data_make( tmp, sizeof( tmp))];
   return( [_mulleNewASCIIStringWithStringContext( string.characters,
                                                   &string.characters[ string.length],
                                                   &empty) autorelease]);
}

@end


@implementation _MulleObjCInt32Number( NSString)

- (struct mulle_ascii_data) _mulleConvertToASCIICharacters:(struct mulle_ascii_data) data
{
   struct mulle_ascii_data   rval;

   assert( data.length>= 16);
   if( _value < 0)
   {
      rval.characters   = convert_decimal_uint32_t( - _value, data.characters, data.length);
      *--rval.characters = '-';
   }
   else
   {
      rval.characters = convert_decimal_uint32_t( _value, data.characters, data.length);
   }
   assert( rval.characters >= data.characters);

   rval.length = data.length - (rval.characters - data.characters);
   return( rval);
}


- (NSString *) stringValue
{
   char                      tmp[ 64];  // max: -2,xxx,xxx,xxx
   struct mulle_ascii_data   string;

   string = [self _mulleConvertToASCIICharacters:mulle_ascii_data_make( tmp, sizeof( tmp))];
   return( [_mulleNewASCIIStringWithStringContext( string.characters, &string.characters[ string.length], &empty) autorelease]);
}

@end


@implementation _MulleObjCInt64Number( NSString)

- (struct mulle_ascii_data) _mulleConvertToASCIICharacters:(struct mulle_ascii_data) data
{
   struct mulle_ascii_data   rval;

   assert( data.length>= 32);
   if( _value < 0)
   {
      rval.characters    = convert_decimal_uint64_t( - _value, data.characters, data.length);
      *--rval.characters = '-';
   }
   else
   {
      rval.characters = convert_decimal_uint64_t( _value, data.characters, data.length);
   }
   assert( rval.characters >= data.characters);

   rval.length = data.length - (rval.characters - data.characters);
   return( rval);
}


- (NSString *) stringValue
{
   char                      tmp[ 32];
   struct mulle_ascii_data   string;

   string = [self _mulleConvertToASCIICharacters:mulle_ascii_data_make( tmp, sizeof( tmp))];
   return( [_mulleNewASCIIStringWithStringContext( string.characters,
                                                   &string.characters[ string.length],
                                                   &empty) autorelease]);
}

@end


@implementation _MulleObjCDoubleNumber( NSString)

- (struct mulle_ascii_data) _mulleConvertToASCIICharacters:(struct mulle_ascii_data) data
{
   struct mulle_ascii_data   rval;

   assert( data.length >= DBL_DECIMAL_DIG + 16);
   rval.length = snprintf( data.characters, data.length, "%g", _value);
   assert( rval.length < data.length);

   rval.characters = data.characters;
   return( rval);
}


- (NSString *) stringValue
{
   char  tmp[ DBL_DECIMAL_DIG + 16];
   int   len;
   struct mulle_ascii_data   string;

   string = [self _mulleConvertToASCIICharacters:mulle_ascii_data_make( tmp, sizeof( tmp))];
   assert( string.length < sizeof( tmp));
   return( [_mulleNewASCIIStringWithStringContext( string.characters,
                                                   &string.characters[ string.length],
                                                   &empty) autorelease]);
}

@end


@implementation _MulleObjCLongDoubleNumber( NSString)

- (struct mulle_ascii_data) _mulleConvertToASCIICharacters:(struct mulle_ascii_data) data
{
   struct mulle_ascii_data   rval;

   assert( data.length>= LDBL_DECIMAL_DIG + 16);
   rval.length = snprintf( data.characters, data.length, "%Lg", _value);
   assert( rval.length < data.length);

   rval.characters = data.characters;
   return( rval);
}


- (NSString *) stringValue
{
   char                      tmp[ LDBL_DECIMAL_DIG + 16];
   struct mulle_ascii_data   string;

   string = [self _mulleConvertToASCIICharacters:mulle_ascii_data_make( tmp, sizeof( tmp))];
   assert( string.length < sizeof( tmp));
   return( [_mulleNewASCIIStringWithStringContext( string.characters,
                                                   &string.characters[ string.length],
                                                   &empty) autorelease]);
}

@end


@implementation _MulleObjCTaggedPointerIntegerNumber( NSString)

- (struct mulle_ascii_data) _mulleConvertToASCIICharacters:(struct mulle_ascii_data) data
{
   struct mulle_ascii_data   rval;
   NSInteger                 value;

   assert( data.length>= 32);
   value = _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self);
   if( value < 0)
   {
      rval.characters   = convert_decimal_uint64_t( - value, data.characters, data.length);
      *--rval.characters = '-';
   }
   else
   {
      rval.characters = convert_decimal_uint64_t( value, data.characters, data.length);
   }
   assert( rval.characters >= data.characters);

   rval.length = data.length - (rval.characters - data.characters);
   return( rval);
}


- (NSString *) stringValue
{
   char                      tmp[ 32];
   struct mulle_ascii_data   string;

   string = [self _mulleConvertToASCIICharacters:mulle_ascii_data_make( tmp, sizeof( tmp))];
   return( [_mulleNewASCIIStringWithStringContext( string.characters,
                                                   &string.characters[ string.length],
                                                   &empty) autorelease]);
}

@end


@implementation _MulleObjCBoolNumber( NSString)

- (struct mulle_ascii_data) _mulleConvertToASCIICharacters:(struct mulle_ascii_data) data
{
   struct mulle_ascii_data   rval;

   if( _value)
   {
      rval.characters = "YES";
      rval.length     = 3;
   }
   else
   {
      rval.characters = "NO";
      rval.length     = 2;
   }

   return( rval);
}


- (NSString *) stringValue
{
   return( _value ? @"YES" : @"NO");
}

@end
