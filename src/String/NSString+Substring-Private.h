//
//  NSString+Substring-Private.h
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
struct _MulleStringContext
{
   Class       stringClass;
   id          sharingObject;
   NSUInteger  sepLen;
};


MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *_mulleNewUTF32StringWithStringContext( mulle_utf32_t *start,
                                                   mulle_utf32_t *end,
                                                   struct _MulleStringContext *ctxt);
MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *_mulleNewASCIIStringWithStringContext( char *start,
                                                   char *end,
                                                   struct _MulleStringContext *ctxt);
MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *_mulleNewUTF16StringWithStringContext( mulle_utf16_t *start,
                                                   mulle_utf16_t *end,
                                                   struct _MulleStringContext *ctxt);
MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *_mulleNewUTF8StringWithStringContext( char *start,
                                                  char *end,
                                                  struct _MulleStringContext *ctxt);


static inline NSString   *_mulleNewSubstringFromASCIIData( NSString *self,
                                                           struct mulle_asciidata buf)
{
   struct _MulleStringContext   ctxt;

// need to init this for valgrind ?
//   ctxt.stringClass   = Nil;
   ctxt.sharingObject = self;
   ctxt.sepLen        = 0;

   return( _mulleNewASCIIStringWithStringContext( buf.characters,
                                                  &buf.characters[ buf.length],
                                                  &ctxt));
}


static inline NSString   *_mulleNewSubstringFromUTF16Data( NSString *self,
                                                           struct mulle_utf16data buf)
{
   struct _MulleStringContext   ctxt;

// need to init this for valgrind ?
//   ctxt.stringClass   = Nil;
   ctxt.sharingObject = self;
   ctxt.sepLen        = 0;

   return( _mulleNewUTF16StringWithStringContext( buf.characters,
                                                  &buf.characters[ buf.length],
                                                  &ctxt));
}


static inline NSString   *_mulleNewSubstringFromUTF32Data( NSString *self,
                                                           struct mulle_utf32data buf)
{
   struct _MulleStringContext   ctxt;

// need to init this for valgrind  ?
//   ctxt.stringClass   = Nil;
   ctxt.sharingObject = self;
   ctxt.sepLen        = 0;

   return( _mulleNewUTF32StringWithStringContext( buf.characters,
                                                  &buf.characters[ buf.length],
                                                  &ctxt));
}



//
// src must be known to be ASCII, and contain no zeroes
//
static inline enum mulle_utf_charinfo    _mulle_ascii_quickinfo( char *src, size_t len)
{
   char   _c;
   char   *start;
   char   *sentinel;

   assert( len);

   if( MulleObjCChar5TPSIndex > mulle_objc_get_taggedpointer_mask())
      return( mulle_utf_is_not_char5_or_char7);

   if( MulleObjCChar7TPSIndex <= mulle_objc_get_taggedpointer_mask())
   {
      if( len <= mulle_char7_get_maxlength())
         return( mulle_utf_is_char7);
   }

   if( len > mulle_char5_get_maxlength())
      return( mulle_utf_is_not_char5_or_char7);

   start    = src;
   sentinel = &start[ len];
   for( ; src < sentinel; src++)
   {
      _c = *src;
      if( ! mulle_utf16_is_char5character( _c))
         return( mulle_utf_is_not_char5_or_char7);
   }
   return( mulle_utf_is_char5);
}



static inline enum mulle_utf_charinfo    _mulle_utf16_quickinfo( mulle_utf16_t *src, NSUInteger len)
{
   enum mulle_utf_charinfo   info;

   // this should be compile time
   if( MulleObjCChar5TPSIndex > mulle_objc_get_taggedpointer_mask() &&
       MulleObjCChar7TPSIndex > mulle_objc_get_taggedpointer_mask())
   {
      return( mulle_utf_is_not_char5_or_char7);
   }

   info = _mulle_utf16_charinfo( src, len);
   if( MulleObjCChar7TPSIndex <= mulle_objc_get_taggedpointer_mask() && info == mulle_utf_is_char7)
      return( info);
   if( MulleObjCChar5TPSIndex <= mulle_objc_get_taggedpointer_mask() && info == mulle_utf_is_char5)
      return( info);
   return( mulle_utf_is_not_char5_or_char7);
}


static inline enum mulle_utf_charinfo    _mulle_utf32_quickinfo( mulle_utf32_t *src, NSUInteger len)
{
   enum mulle_utf_charinfo   info;

   // this should be compile time
   if( MulleObjCChar5TPSIndex > mulle_objc_get_taggedpointer_mask() &&
       MulleObjCChar7TPSIndex > mulle_objc_get_taggedpointer_mask())
   {
      return( mulle_utf_is_not_char5_or_char7);
   }

   info = _mulle_utf32_charinfo( src, len);
   if( MulleObjCChar7TPSIndex <= mulle_objc_get_taggedpointer_mask() && info == mulle_utf_is_char7)
      return( info);
   if( MulleObjCChar5TPSIndex <= mulle_objc_get_taggedpointer_mask() && info == mulle_utf_is_char5)
      return( info);
   return( mulle_utf_is_not_char5_or_char7);
}
