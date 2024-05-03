#ifndef nsnumber_hash_h__
#define nsnumber_hash_h__

#include "include.h"

#include <limits.h>
#include <float.h>


static inline NSUInteger  NSNumberHashUnsignedInteger( NSUInteger value)
{
   return( mulle_integer_hash( value));
}


static inline NSUInteger   NSNumberHashUnsignedIntegers( NSUInteger *p, int n)
{
   NSUInteger   hash;

   assert( n >= 1);

   hash = *p;
   while( --n)
   {
      hash <<= 6;
      hash  += *++p;
   }
   hash = NSNumberHashUnsignedInteger( hash);
   return( hash);
}


static inline NSUInteger   NSNumberHashUnsignedIntegerBytes( void *p, size_t n)
{
   return( NSNumberHashUnsignedIntegers( p, (n + sizeof( NSUInteger) - 1) / sizeof( NSUInteger)));
}



//
// MEMO: As NSNumber tries to guarantee, that a double value that
//       can be represented as an integer _IS_ stored as an integer
//       the compatibility with NSUInteger is possibly pointless.
//       Same goes for the double == long double check
//
static inline NSUInteger  NSNumberHashFloat( float value)
{
   NSInteger   y;
   float       z;

   y = (NSInteger) value;
   z = (float) y;
   // these comparisons I think are to check that there isn't some floating
   // point residue, that makes the number compare fine, but its just slightly
   // out of range. I say "i think" because I am writing this long afterwards,
   // there should be a test for this.
   if( z == (float) value && z >= (float) NSIntegerMin && z <= (float) NSIntegerMax)
       return( NSNumberHashUnsignedInteger( (NSUInteger) y));
   return( mulle_float_hash( value));
}


static inline NSUInteger  NSNumberHashDouble( double value)
{
   NSInteger    y;
   double       z;

   y = (NSInteger) value;
   z = (double) y;
   if( z == (double) value && z >= (double) NSIntegerMin && z <= (double) NSIntegerMax)
       return( NSNumberHashUnsignedInteger( (NSUInteger) y));
   return( mulle_double_hash( value));
}


static inline NSUInteger  NSNumberHashLongDouble( long double value)
{
   NSInteger   y;
   long double  z;

   y = (NSInteger) value;
   z = (long double) y;
   if( z == (long double) value && z >= (long double) NSIntegerMin && z <= (long double) NSIntegerMax)
       return( NSNumberHashUnsignedInteger( (NSUInteger) y));
   return( mulle_long_double_hash( value));
}

#endif
