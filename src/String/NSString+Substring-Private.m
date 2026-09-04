//
//  NSString+Substring-Private.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
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
#import "import-private.h"

#import "NSString.h"
#import "NSString+ClassCluster.h"
#import "NSString+NSData.h" // for NSStringEncoding

#import "_MulleObjCValueTaggedPointer.h"
#import "NSString+Substring-Private.h"

#import "_MulleObjCTaggedPointerChar5String.h"
#import "_MulleObjCTaggedPointerChar7String.h"
#import "_MulleObjCASCIIString.h"
#import "_MulleObjCUTF16String.h"
#import "_MulleObjCUTF32String.h"

#include <assert.h>


NSString   *_mulleNewUTF8StringWithStringContext( char *start,
                                                  char *end,
                                                  struct _MulleStringContext *ctxt)
{
   NSUInteger   length;

   if( ctxt->sepLen == -1)
      _mulle_utf8_previous_utf32character( &end);
   else
      end -= ctxt->sepLen;

   assert( start <= end);
   length = end - start;
   if( ! length)
      return( @"");
   return( [[ctxt->stringClass alloc] mulleInitWithUTF8Characters:start
                                                           length:length]);
}


NSString   *_mulleNewASCIIStringWithStringContext( char *start,
                                                   char *end,
                                                   struct _MulleStringContext *ctxt)
{
   NSUInteger   length;

   end -= ctxt->sepLen;
   assert( start <= end);

   length = end - start;
   if( ! length)
      return( @"");

#ifdef __MULLE_OBJC_TPS__
   switch( _mulle_ascii_quickinfo( start, length))
   {
   case mulle_utf_is_char7 :
      return( MulleObjCTaggedPointerChar7StringWithASCIICharacters( start,
                                                                    length));
   case mulle_utf_is_char5 :
      return( MulleObjCTaggedPointerChar5StringWithASCIICharacters( start,
                                                                    length));
   default :
      break;
   }
#endif
   if( ctxt->sharingObject)
      return( [_MulleObjCSharedASCIIString newWithASCIICharactersNoCopy:start
                                                                 length:length
                                                          sharingObject:ctxt->sharingObject]);
   return( [_MulleObjCGenericASCIIString newWithASCIICharacters:start
                                                         length:length]);
}


NSString   *_mulleNewUTF16StringWithStringContext( mulle_utf16_t *start,
                                                   mulle_utf16_t *end,
                                                   struct _MulleStringContext *ctxt)
{
   NSUInteger   length;

   end   -= ctxt->sepLen;
   assert( start <= end);

   length = end - start;
   if( ! length)
      return( @"");
   // try to benefit from TPS

#ifdef __MULLE_OBJC_TPS__
   switch( _mulle_utf16_quickinfo( start, length))
   {
   case mulle_utf_is_char7 :
      return( MulleObjCTaggedPointerChar7StringWithUTF16Characters( start,
                                                                    length));
   case mulle_utf_is_char5 :
      return( MulleObjCTaggedPointerChar5StringWithUTF16Characters( start,
                                                                    length));
   default :
      break;
   }
#endif

   if( ctxt->sharingObject)
      return( [_MulleObjCSharedUTF16String newWithUTF16CharactersNoCopy:start
                                                                 length:length
                                                          sharingObject:ctxt->sharingObject]);
   return( [_MulleObjCGenericUTF16String newWithUTF16Characters:start
                                                         length:length]);
}


NSString   *_mulleNewUTF32StringWithStringContext( mulle_utf32_t *start,
                                                   mulle_utf32_t *end,
                                                   struct _MulleStringContext *ctxt)
{
   NSUInteger   length;

   end -= ctxt->sepLen;
   assert( start <= end);

   length = end - start;
   if( ! length)
      return( @"");
   // try to benefit from TPS

#ifdef __MULLE_OBJC_TPS__
   switch( _mulle_utf32_quickinfo( start, length))
   {
   case mulle_utf_is_char7 :
      return( MulleObjCTaggedPointerChar7StringWithCharacters( start,
                                                               length));
   case mulle_utf_is_char5 :
      return( MulleObjCTaggedPointerChar5StringWithCharacters( start,
                                                               length));
   default :
      break;
   }
#endif

   if( ctxt->sharingObject)
      return( [_MulleObjCSharedUTF32String newWithUTF32CharactersNoCopy:start
                                                                 length:length
                                                          sharingObject:ctxt->sharingObject]);
   return( [_MulleObjCGenericUTF32String newWithUTF32Characters:start
                                                         length:length]);
}

