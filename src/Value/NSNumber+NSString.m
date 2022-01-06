//
//  NSNumber+NSString.m
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

#import "NSNumber+NSString.h"

// other files in this library
#import "NSString.h"
#import "NSString+Sprintf.h"

// std-c dependencies
#import "import-private.h"

#include <float.h>
#include <ctype.h>


@implementation NSNumber (NSString)

//
// default implementation, actually it's kinda good enough
// but there are also overrides in _MulleObjCConcreteNumber+NSString.m
// The idea behind stringValue should be that you get the same back value
// back when parsing it. -description is a bit more lenient with respect
// to FP numbers
//
- (NSString *) stringValue
{
   char   *type;

   type = [self objCType];
   switch( *type)
   {
   default :
      return( [NSString stringWithFormat:@"%ld", [self longValue]]);

   case _C_UCHR :
   case _C_USHT :
   case _C_UINT :
   case _C_ULNG :
      return( [NSString stringWithFormat:@"%lu", [self unsignedLongValue]]);

   case _C_LNG_LNG :
      return( [NSString stringWithFormat:@"%lld", [self longLongValue]]);
   case _C_ULNG_LNG :
      return( [NSString stringWithFormat:@"%llu", [self unsignedLongLongValue]]);

   /* this is OS specific, yikes. BSD prints everything with %g
    * linux messes this up. We need something that converts back into atof
    * losslessly. So a test would be sprintf -> atof -> same value
    * https://en.wikipedia.org/wiki/Single-precision_floating-point_format
    * 2^23 = 16,777,216
    */
   case _C_FLT :
      return( [NSString stringWithFormat:@"%0.8g", [self doubleValue]]);

   // https://en.wikipedia.org/wiki/Double-precision_floating-point_format
   // 2^52=4,503,599,627,370,496 and 2^53=9,007,199,254,740,992
   // so at most 16 significant digits for IEEE 754, so why do we need
   // 17, I don't now but check float-core and double-core tests
   case _C_DBL :
      return( [NSString stringWithFormat:@"%0.17g", [self doubleValue]]);

   case _C_LNG_DBL :
      //
      // https://en.wikipedia.org/wiki/Extended_precision#x86_extended_precision_format
      // https://www.mymathtables.com/numbers/power-exponentiation/power-of-2.html
      // 2^65 = 36,893,488,147,419,103,000
      return( [NSString stringWithFormat:@"%0.21Lg", [self longDoubleValue]]);
   }
}


- (NSString *) description
{
   char   *type;

   type = [self objCType];
   switch( *type)
   {
   default :
      return( [NSString stringWithFormat:@"%ld", [self longValue]]);

   case _C_UCHR :
   case _C_USHT :
   case _C_UINT :
   case _C_ULNG :
      return( [NSString stringWithFormat:@"%lu", [self unsignedLongValue]]);

   case _C_LNG_LNG :
      return( [NSString stringWithFormat:@"%lld", [self longLongValue]]);
   case _C_ULNG_LNG :
      return( [NSString stringWithFormat:@"%llu", [self unsignedLongLongValue]]);

   // these values are intentionally one less, as the output is Apple compatible
   // and it is documented thusly. The non-lossy value is stringValue
   //
   case _C_FLT :
      return( [NSString stringWithFormat:@"%0.7g", [self doubleValue]]); // sic
   case _C_DBL :
      return( [NSString stringWithFormat:@"%0.16g", [self doubleValue]]);
   case _C_LNG_DBL :
      return( [NSString stringWithFormat:@"%0.21Lg", [self longDoubleValue]]);
   }
}


- (NSString *) mulleDebugContentsDescription
{
   return( [self stringValue]);
}


- (void) _mulleConvertToASCIICharacters:(struct mulle_asciidata *) data
{
   *data = mulle_asciidata_make( NULL, 0);
}



enum
{
   is_string = 0,
   is_integer,
   is_double
};

enum
{
   has_nothing,
   has_sign,
   has_leading_zero,
   has_integer,
   has_dot,
   has_fractional,
   has_exp,
   has_exp_sign,
   has_exponent,
};


//
// there can't be trailing garbage at the end
// can't parse hex, and octal.
// specifically does not parse leading 0 numbers (except 0) (avoid phonenumbers)
// does not allow leading plus (avoid phonenumbers)
// does not allow .2
// does allow 0.e10
// does not allow e10
// guarantees that int chars are <= 19
// of course this is a heuristic. on the bright side, we quote "dudes" on
// output
//
#ifndef __MULLE_TEST__
static
#endif
int   _dude_looks_like_a_number( char *buffer, size_t len)
{
   char   *sentinel;
   int    state;
   int    c;
   int    sign;

   state    = has_nothing;
   sentinel = &buffer[ len];
   sign     = 0;

   while( buffer < sentinel)
   {
      c = *buffer++;

      switch( state)
      {
      case has_nothing :
         switch( c)
         {
         case '-' : state = has_sign; sign = 1; continue;
         case '0' : state = has_leading_zero; continue;
         default  : if( isdigit( c)) { state = has_integer; continue; }
         }
         return( is_string);

      case has_sign :
         switch( c)
         {
         case '0' : state = has_leading_zero; continue;
         default  : if( isdigit( c)) { state = has_integer; continue; }
         }
         return( is_string);

      case has_leading_zero :
         switch( c)
         {
         case 'e' :
         case 'E' : state = has_exp; continue;
         case ',' :
         case '.' : state = has_dot; continue;
         default  : ;
         }
         return( is_string);

      case has_integer :
         switch( c)
         {
         case 'e' :
         case 'E' : state = has_exp; continue;
         case ',' :
         case '.' : state = has_dot; continue;
         default  : if( isdigit( c)) { continue; }
         }
         return( is_string);

      case has_dot :
         switch( c)
         {
         case 'e' :
         case 'E' : state = has_exp; continue;
         default  : if( isdigit( c)) { state = has_fractional; continue; }
         }
         return( is_string);

      case has_fractional :
         switch( c)
         {
         case 'e' :
         case 'E' : state = has_exp; continue;
         default  : if( isdigit( c)) { continue; }
         }
         return( is_string);

      case has_exp :
         switch( c)
         {
         case '+' :
         case '-' : state = has_exp_sign; continue;
         default  : if( isdigit( c)) { state = has_exponent; continue; }
         }
         return( is_string);

      case has_exp_sign :
         if( isdigit( c)) { state = has_exponent; continue; }
         return( is_string);

      case has_exponent :
         if( isdigit( c)) {  continue; }
         return( is_string);
      }
   }

   //
   // https://stackoverflow.com/questions/1701055/what-is-the-maximum-length-in-chars-needed-to-represent-any-double-value
   // printed double values can be as large as 1080!
   //
   switch( state)
   {
   case has_leading_zero :
   case has_integer      : if( len - sign <= 19)
                              return( is_integer);  // 922,337,203,685,477,580
                           return( is_string);
   case has_fractional   : // fall thru
   case has_exponent     : return( is_double);
   }
   return( is_string);
}



NSNumber  *MulleNewNumberWithUTF8Data( struct mulle_utf8data region)
{
   char        buf[ 64];
   int         type;
   char        *end;
   long long   ll_val;
   double      d_val;

   if( region.length == -1)
      region.length = mulle_utf8_strlen( region.characters);

   if( region.length >= 64)
      return( nil);

   type = _dude_looks_like_a_number( (char *) region.characters, region.length);
   switch( type)
   {
   case is_integer :
   case is_double  :
      memcpy( buf, region.characters, region.length);
      buf[ region.length] = 0;

      if( type == is_integer)
      {
         ll_val = strtoll( buf, &end, 10);
         if( *end == 0)
            return( [[NSNumber alloc] initWithLongLong:ll_val]);
      }
      d_val = strtod( buf, &end);  // strtold ?
      if( *end == 0)
         return( [[NSNumber alloc] initWithDouble:d_val]);
   }

   return( nil);
}


#ifndef __MULLE_TEST__
static
#endif
int   _dude_is_a_bool( char *buffer, size_t len)
{
   if( len > 3 || len < 2)
      return( -1);
   if( len == 2)
      return( memcmp( buffer, "NO", 2) ? -1 : 0);
   return( memcmp( buffer, "YES", 3) ? -1 : 1);
}


NSNumber  *MulleNewBoolWithUTF8Data( struct mulle_utf8data region)
{
   int  type;

   type = _dude_is_a_bool( (char *) region.characters, region.length);
   if( type != -1)
      return( [[NSNumber alloc] initWithBool:type]);
   return( nil);
}


- (instancetype) mulleInitWithString:(NSString *) s
{
   mulle_utf8_t   *utf8;

   // [self release]; // not needed as class cluster

   utf8 = (mulle_utf8_t *) [s UTF8String];
   if( ! utf8)
      return( nil);
   return( MulleNewNumberWithUTF8Data( mulle_utf8data_make( utf8, -1)));
}
@end

