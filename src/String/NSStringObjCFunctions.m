//
//  NSObjCStringFunctions.m
//  MulleObjCValueFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSStringObjCFunctions.h"

#import "NSString.h"
#import "NSString+ClassCluster.h"
#import "NSString+Sprintf.h"

#import "import-private.h"


@class NSString;

Class   NSClassFromString( NSString *s)
{
   return( MulleObjCLookupClassByName( [s UTF8String]));
}


SEL   NSSelectorFromString( NSString *s)
{
   return( MulleObjCCreateSelector( [s UTF8String]));
}


NSString   *NSStringFromClass( Class cls)
{
   char   *s;

   s = MulleObjCClassGetName( cls);
   if( ! s)
   {
      if( ! cls)
         return( nil);
      MulleObjCThrowInternalInconsistencyExceptionCString( "unknown class %p", cls);
   }

   return( [NSString stringWithUTF8String:s]);
}


NSString   *NSStringFromSelector( SEL sel)
{
   char   *s;

   s = MulleObjCSelectorGetName( sel);
   if( ! s)
   {
      if( ! sel)
         return( nil);
      MulleObjCThrowInternalInconsistencyExceptionCString( "unknown selector id %08x (register selector first)", (uint32_t ) sel);
   }
   return( [NSString stringWithUTF8String:s]);
}


NSString   *NSStringFromProtocol( PROTOCOL proto)
{
   char   *s;

   s = MulleObjCProtocolGetName( proto);
   if( ! s)
   {
      if( ! proto)
         return( nil);
      MulleObjCThrowInternalInconsistencyExceptionCString( "unknown protocol id %08x", (uint32_t ) proto);
   }
   return( [NSString stringWithUTF8String:s]);
}


NSString   *NSStringFromRange( NSRange range)
{
   // Apple does it with {}
   return( [NSString stringWithFormat:@"{ %lu, %lu }", range.location, range.length]);
}


NSString  *MulleObjCStringByCombiningPrefixAndCapitalizedKey( NSString *prefix,
                                                              NSString *key,
                                                              BOOL tailColon)
{
   NSUInteger               prefix_len;
   NSUInteger               key_len;
   NSUInteger               len;
   uint8_t                  *buf;
   uint8_t                  c;
   NSString                 *s;
   struct mulle_allocator   *allocator;

   key_len = [key mulleUTF8StringLength];
   assert( key_len);

   if( key_len == 0)
      return( nil);

   allocator  = MulleObjCInstanceGetAllocator( key);
   prefix_len = [prefix mulleUTF8StringLength];
   len        = key_len + prefix_len + (tailColon == YES);

   buf = (uint8_t *) mulle_allocator_malloc( allocator, len);

   [prefix mulleGetUTF8Characters:buf];
   [key mulleGetUTF8Characters:&buf[ prefix_len]];

   c = buf[ prefix_len];
   if( c >= 'a' && c <= 'z')
   {
      c -= 'a' - 'A';
      buf[ prefix_len] = c;
   }

   if( tailColon)
      buf[ len - 1] = ':';

   s = [[[NSString alloc] mulleInitWithUTF8CharactersNoCopy:buf
                                                     length:len
                                                  allocator:allocator] autorelease];
   return( s);
}

