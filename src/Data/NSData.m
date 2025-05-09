//
//  NSData.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#define _GNU_SOURCE   // UGLINESS for memmem and memrmem

#import "NSData.h"

// other files in this library
#import "_MulleObjCDataSubclasses.h"

// other libraries of MulleObjCValueFoundation

// std-c and dependencies
#import "import-private.h"
#import <string.h>


#if MULLE__BUFFER_VERSION < ((0 << 20) | (4 << 8) | 1)
# error "mulle_buffer is too old"
#endif


@interface NSObject( _NSMutableData)

- (BOOL) __isNSMutableData;

@end


@implementation NSObject( _NSData)

- (BOOL) __isNSData
{
   return( NO);
}

@end


@implementation NSData

- (BOOL) __isNSData
{
   return( YES);
}


static NSData  *_newData( void *buf, NSUInteger length)
{
   if( ! buf && length)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "empty bytes");

   if( length == (NSUInteger) -1)
      length = strlen( buf);

   switch( length)
   {
   case 0  : return( [_MulleObjCZeroBytesData mulleNewWithBytes:buf]);
   case 8  : return( [_MulleObjCEightBytesData mulleNewWithBytes:buf]);
   case 16 : return( [_MulleObjCSixteenBytesData mulleNewWithBytes:buf]);
   }

   if( length < 0x100 + 1)
      return( [_MulleObjCTinyData mulleNewWithBytes:buf
                                             length:length]);
   if( length < 0x10000 + 0x100 + 1)
      return( [_MulleObjCMediumData mulleNewWithBytes:buf
                                               length:length]);

   return( [_MulleObjCAllocatorData mulleNewWithBytes:buf
                                               length:length]);
}


#pragma mark - class cluster stuff

- (instancetype) init
{
   self = _newData( 0, 0);
   return( self);
}


// since "self" is the placeholder, we don't really need to release it
- (instancetype) initWithBytes:(void *) bytes
                        length:(NSUInteger) length
{
   self = _newData( bytes, length);
   return( self);
}


- (instancetype) mulleInitWithCData:(struct mulle_data) data
{
   self = _newData( data.bytes, data.length);
   return( self);
}


- (instancetype) mulleInitWithBytesNoCopy:(void *) bytes
                                   length:(NSUInteger) length
                                allocator:(struct mulle_allocator *) allocator
{
   if( ! bytes && length)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "empty bytes");

   if( length == (NSUInteger) -1)
      length = strlen( bytes);

   self = [_MulleObjCAllocatorData mulleNewWithBytesNoCopy:bytes
                                                    length:length
                                                 allocator:allocator];
   return( self);
}


- (instancetype) mulleInitWithBytesNoCopy:(void *) bytes
                                   length:(NSUInteger) length
                            sharingObject:(id) owner
{
   if( ! bytes && length)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "empty bytes");

   if( length == (NSUInteger) -1)
      length = strlen( bytes);

   self = [_MulleObjCSharedData mulleNewWithBytesNoCopy:bytes
                                                 length:length
                                          sharingObject:owner];
   return( self);
}


#pragma mark - init abstract implementations

- (instancetype) initWithBytesNoCopy:(void *) bytes
                              length:(NSUInteger) length
{
   if( ! bytes && length)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "empty bytes");

   self = [self mulleInitWithBytesNoCopy:bytes
                                  length:length
                               allocator:&mulle_stdlib_allocator];
   return( self);
}


- (instancetype) initWithBytesNoCopy:(void *) bytes
                              length:(NSUInteger) length
                        freeWhenDone:(BOOL) flag
{
   struct mulle_allocator   *allocator;

   allocator = flag ? &mulle_stdlib_allocator: &mulle_stdlib_nofree_allocator;
   self      = [self mulleInitWithBytesNoCopy:bytes
                                       length:length
                                    allocator:allocator];
   return( self);
}


- (instancetype) initWithData:(NSData *) other
{
   if( [other __isNSMutableData])
      self = [self initWithBytes:[other bytes]
                          length:[other length]];
   else
      self = [self mulleInitWithBytesNoCopy:[other bytes]
                                     length:[other length]
                              sharingObject:other];
   return( self);
}


- (instancetype) initWithBytes:(void *) bytes
                        length:(NSUInteger) length
                          copy:(BOOL) copy
                  freeWhenDone:(BOOL) freeWhenDone
                    bytesAreVM:(BOOL) bytesAreVM;
{
   struct mulle_allocator   *allocator;

   assert( ! bytesAreVM);
   allocator = freeWhenDone ?  &mulle_stdlib_allocator : &mulle_stdlib_nofree_allocator;

   if( copy)
   {
      self = [self initWithBytes:bytes
                          length:length];
      mulle_allocator_free( allocator, bytes);
      return( self);
   }

   self = [self mulleInitWithBytesNoCopy:bytes
                                  length:length
                               allocator:allocator];
   return( self);
}

#pragma mark - construction conveniences

+ (instancetype) data
{
   return( [[[self alloc] init] autorelease]);
}


+ (instancetype) dataWithBytes:(void *) buf
                        length:(NSUInteger) length
{
   return( [[[self alloc] initWithBytes:buf
                                 length:length] autorelease]);
}


+ (instancetype) dataWithBytesNoCopy:(void *) buf
                              length:(NSUInteger) length
{
   return( [[[self alloc] initWithBytesNoCopy:buf
                                       length:length] autorelease]);
}


+ (instancetype) dataWithBytesNoCopy:(void *) buf
                              length:(NSUInteger) length
                        freeWhenDone:(BOOL) flag
{
   return( [[[self alloc] initWithBytesNoCopy:buf
                                       length:length
                                 freeWhenDone:flag] autorelease]);
}


+ (instancetype) dataWithData:(NSData *) data
{
   return( [[[self alloc] initWithData:data] autorelease]);
}


+ (instancetype) mulleDataWithCData:(struct mulle_data) data
{
   return( [[[self alloc] mulleInitWithCData:data] autorelease]);
}


#pragma mark - hash and equality

- (NSUInteger) hash
{
   long        length;
   char        *buf;
   char        *sentinel;
   uintptr_t   hash;
   void        *hash_state;

   length     = [self length];
   buf        = (char *) [self bytes];
   sentinel   = &buf[ length > 0x400 ? 0x400 : length]; // touch at most a page
   hash_state = NULL;

   // this hashes 4*32 bytes max
   while( length > 32)
   {
      mulle_data_hash_chained( mulle_data_make( buf, 32), &hash_state);
      buf  = &buf[ 0x100];
      if( buf >= sentinel)
      {
         hash = mulle_data_hash_chained( mulle_data_make( NULL, 0), &hash_state);
         return( (NSUInteger) hash);
      }

      length -= 0x100;
   }

   // small and large data goes here
   mulle_data_hash_chained( mulle_data_make( buf, length), &hash_state);

   hash = mulle_data_hash_chained( mulle_data_make( NULL, 0), &hash_state);
   return( (NSUInteger) hash);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSData])
      return( NO);
   return( [self isEqualToData:other]);
}


- (BOOL) isEqualToData:(NSData *) other
{
   NSUInteger   length;

   length = [other length];
   if( length != [self length])
      return( NO);
   return( ! memcmp( [self bytes], [other bytes], length));
}


#pragma mark - common code


- (void) getBytes:(void *) buf
{
   assert( buf);
   memcpy( buf, [self bytes], [self length]);
}


- (void) getBytes:(void *) buf
           length:(NSUInteger) length
{
   NSRange   range;

   range = NSRangeMake( 0, length);
   range = MulleObjCValidateRangeAgainstLength( range, [self length]);
   // need assert
   memcpy( buf, [self bytes], range.length);
}


- (void) getBytes:(void *) buf
            range:(NSRange) range
{
   range = MulleObjCValidateRangeAgainstLength( range, [self length]);

   // need assert
   memcpy( buf, &((char *)[self bytes])[ range.location], range.length);
}


- (NSData *) subdataWithRange:(NSRange) range
{
   range = MulleObjCValidateRangeAgainstLength( range, [self length]);

   return( [NSData dataWithBytes:&((char *)[self bytes])[ range.location]
                           length:range.length]);
}


// layme brute forcer
static void   *mulle_memrmem( unsigned char *a, size_t a_len,
                              unsigned char *b, size_t b_len)
{
   unsigned char   *a_curr;
   unsigned char   first_b;

   a_curr  = &a[ a_len - b_len];
   first_b = *b;

   for( a_curr  = &a[ a_len - b_len]; a_curr >= a; --a_curr)
      if( *a_curr == first_b)
         if( ! memcmp( a_curr, b, b_len))
            return( a_curr);

   return( NULL);
}


- (NSRange) rangeOfData:(id) other
                options:(NSUInteger) options
                  range:(NSRange) range
{
   NSUInteger      length;
   NSUInteger      location;
   NSUInteger      other_length;
   unsigned char   *bytes;
   unsigned char   *found;
   unsigned char   *other_bytes;
   unsigned char   *start;

   length = [self length];
   range  = MulleObjCValidateRangeAgainstLength( range, length);

   other_length = [other length];
   length       = range.length;
   if( ! length || ! other_length || other_length > length)
      return( NSRangeMake( NSNotFound, 0));

   start       = [self bytes];
   bytes       = &start[ range.location];
   other_bytes = [other bytes];

   // easy
   if( options & NSDataSearchAnchored)
   {
      if( options & NSDataSearchBackwards)
      {
         location = length - other_length;
         if( ! memcmp( &bytes[ location], other_bytes, other_length))
            return( NSRangeMake( range.location + location, other_length));
      }
      else
      {
         if( ! memcmp( bytes, other_bytes, other_length))
            return( NSRangeMake( range.location, other_length));
      }
   }
   else
   {
      if( options & NSDataSearchBackwards)
      {
         found = mulle_memrmem( bytes, length, other_bytes, other_length);
         if( found)
            return( NSRangeMake( found - start, other_length));
      }
      else
      {
         found = memmem( bytes, length, other_bytes, other_length);
         if( found)
            return( NSRangeMake( found - start, other_length));
      }
   }

   return( NSRangeMake( NSNotFound, 0));
}


#pragma mark - placeholder only

// for debug description
- (void *) bytes
{
   return( NULL);
}

- (NSUInteger) length
{
   return( 0);
}


- (struct mulle_data) mulleCData
{
   struct mulle_data   data;

   data = mulle_data_make( 0, 0);
   return( data);
}

@end
