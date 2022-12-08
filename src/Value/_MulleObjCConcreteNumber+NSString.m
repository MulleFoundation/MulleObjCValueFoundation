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


// TODO: not sure if this code is needed, as the fallback seems good enough
//       for int and float or ?

static char  *convert_decimal_uint32_t( uint32_t value, char *s, size_t len)
{
   assert( len >= 10);  // 4,294,967,296

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
   assert( len >= 20);  // 18,446,744,073,709,551,616

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

- (void) _mulleConvertToASCIICharacters:(struct mulle_asciidata *) data
{
   struct mulle_asciidata   rval;

   rval.characters = convert_decimal_uint32_t( _value, data->characters, data->length);
   rval.length     = data->length - (rval.characters - data->characters);
   *data = rval;
}


- (NSString *) stringValue
{
   char                      tmp[ 16];
   struct mulle_asciidata   data;

   data = mulle_asciidata_make( tmp, sizeof( tmp));
   [self _mulleConvertToASCIICharacters:&data];
   return( [_mulleNewASCIIStringWithStringContext( data.characters,
                                                   &data.characters[ data.length],
                                                   &empty) autorelease]);
}

@end


@implementation _MulleObjCUInt64Number( NSString)

- (void) _mulleConvertToASCIICharacters:(struct mulle_asciidata *) data
{
   struct mulle_asciidata   rval;

   rval.characters = convert_decimal_uint64_t( _value, data->characters, data->length);
   rval.length     = data->length - (rval.characters - data->characters);
   *data           = rval;
}


- (NSString *) stringValue
{
   char                      tmp[ 32];  // max: 18,xxx,xxx,xxx,xxx,xxx,xxx
   struct mulle_asciidata   data;

   data = mulle_asciidata_make( tmp, sizeof( tmp));
   [self _mulleConvertToASCIICharacters:&data];
   return( [_mulleNewASCIIStringWithStringContext( data.characters,
                                                   &data.characters[ data.length],
                                                   &empty) autorelease]);
}

@end


@implementation _MulleObjCInt32Number( NSString)

- (void) _mulleConvertToASCIICharacters:(struct mulle_asciidata *) data
{
   struct mulle_asciidata   rval;

   assert( data->length >= 11);

   if( _value < 0)
   {
      rval.characters   = convert_decimal_uint32_t( - _value, data->characters, data->length);
      *--rval.characters = '-';
   }
   else
   {
      rval.characters = convert_decimal_uint32_t( _value, data->characters, data->length);
   }
   assert( rval.characters >= data->characters);

   rval.length = data->length - (rval.characters - data->characters);
   *data = rval;
}


- (NSString *) stringValue
{
   char                     tmp[ 32];  // max: -2,xxx,xxx,xxx
   struct mulle_asciidata   data;

   data = mulle_asciidata_make( tmp, sizeof( tmp));
   [self _mulleConvertToASCIICharacters:&data];
   return( [_mulleNewASCIIStringWithStringContext( data.characters,
                                                   &data.characters[ data.length],
                                                   &empty) autorelease]);
}

@end


@implementation _MulleObjCInt64Number( NSString)

- (void) _mulleConvertToASCIICharacters:(struct mulle_asciidata *) data
{
   struct mulle_asciidata   rval;

   assert( data->length >= 21);
   if( _value < 0)
   {
      rval.characters    = convert_decimal_uint64_t( - _value, data->characters, data->length);
      *--rval.characters = '-';
   }
   else
   {
      rval.characters = convert_decimal_uint64_t( _value, data->characters, data->length);
   }
   assert( rval.characters >= data->characters);

   rval.length = data->length - (rval.characters - data->characters);
   *data = rval;
}


- (NSString *) stringValue
{
   char                     tmp[ 32];
   struct mulle_asciidata   data;

   data = mulle_asciidata_make( tmp, sizeof( tmp));
   [self _mulleConvertToASCIICharacters:&data];
   return( [_mulleNewASCIIStringWithStringContext( data.characters,
                                                   &data.characters[ data.length],
                                                   &empty) autorelease]);
}

@end


@implementation _MulleObjCDoubleNumber( NSString)

// TODO: there is possibly a problem here, that we don't have a true
//       float representation
- (void) _mulleConvertToASCIICharacters:(struct mulle_asciidata *) data
{
   struct mulle_asciidata   rval;

   assert( data->length >= 17 + 6);  //-e+123

   rval.length = snprintf( data->characters, data->length, "%0.17g", _value);
   assert( rval.length < data->length);

   rval.characters = data->characters;
   *data = rval;
}


- (NSString *) stringValue
{
   char                     tmp[ 32];
   struct mulle_asciidata   data;

   data = mulle_asciidata_make( tmp, sizeof( tmp));
   [self _mulleConvertToASCIICharacters:&data];
   assert( data.length < sizeof( tmp));
   return( [_mulleNewASCIIStringWithStringContext( data.characters,
                                                   &data.characters[ data.length],
                                                   &empty) autorelease]);
}

@end


@implementation _MulleObjCLongDoubleNumber( NSString)

- (void) _mulleConvertToASCIICharacters:(struct mulle_asciidata *) data
{
   struct mulle_asciidata   rval;

   assert( data->length >= 21 + 6);
   rval.length = snprintf( data->characters, data->length, "%0.21Lg", _value);
   assert( rval.length < data->length);

   rval.characters = data->characters;
   *data = rval;
}


- (NSString *) stringValue
{
   char                     tmp[ 32];
   struct mulle_asciidata   data;

   data = mulle_asciidata_make( tmp, sizeof( tmp));
   [self _mulleConvertToASCIICharacters:&data];
   assert( data.length < sizeof( tmp));
   return( [_mulleNewASCIIStringWithStringContext( data.characters,
                                                   &data.characters[ data.length],
                                                   &empty) autorelease]);
}

@end


@implementation _MulleObjCTaggedPointerIntegerNumber( NSString)

struct mulle_asciidata
   _MulleObjCTaggedPointerIntegerNumberConvertToASCIICharacters( _MulleObjCTaggedPointerIntegerNumber *self,
                                                                 struct mulle_asciidata data)
{
   struct mulle_asciidata   rval;
   NSInteger                value;

   assert( data.length >= 21);

   value = _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self);
   if( value < 0)
   {
      rval.characters    = convert_decimal_uint64_t( - value, data.characters, data.length);
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


- (void) _mulleConvertToASCIICharacters:(struct mulle_asciidata *) data
{
   struct mulle_asciidata   rval;

   rval  = _MulleObjCTaggedPointerIntegerNumberConvertToASCIICharacters( self, *data);
   *data = rval;
}


- (NSString *) stringValue
{
   char                      tmp[ 32];
   struct mulle_asciidata    data;
   NSString                  *s;

   data = mulle_asciidata_make( tmp, sizeof( tmp));
   [self _mulleConvertToASCIICharacters:&data];
   s    = _mulleNewASCIIStringWithStringContext( data.characters,
                                                 &data.characters[ data.length],
                                                 &empty);
   return( [s autorelease]);
}

@end


@implementation _MulleObjCBoolNumber( NSString)

- (void) _mulleConvertToASCIICharacters:(struct mulle_asciidata *) data
{
   struct mulle_asciidata   rval;

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

   *data = rval;
}


- (NSString *) stringValue
{
   return( _value ? @"YES" : @"NO");
}


- (NSString *) description
{
   return( _value ? @"YES" : @"NO");
}

@end
