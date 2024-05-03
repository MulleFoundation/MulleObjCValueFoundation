#import "import-private.h"

#import "NSString.h"
#import "NSString+ClassCluster.h"

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

