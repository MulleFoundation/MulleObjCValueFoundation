//
//  NSStringObjCFunctions.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2017 Nat! - Mulle kybernetiK.
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
#import "NSStringObjCFunctions.h"

#import "NSString.h"
#import "NSString+ClassCluster.h"
#import "NSString+Sprintf.h"

#import "import-private.h"


@class NSString;

Class   MulleObjCClassFromString( NSString *s)
{
   return( MulleObjCLookupClassByNameUTF8String( [s UTF8String]));
}


SEL   MulleObjCSelectorFromString( NSString *s)
{
   return( MulleObjCCreateSelectorUTF8String( [s UTF8String]));
}


NSString   *MulleObjCStringFromClass( Class cls)
{
   char   *s;

   s = MulleObjCClassGetNameUTF8String( cls);
   if( ! s)
   {
      if( ! cls)
         return( nil);
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "unknown class %p", cls);
   }

   return( [NSString stringWithUTF8String:s]);
}


NSString   *MulleObjCStringFromSelector( SEL sel)
{
   char   *s;

   s = MulleObjCSelectorGetNameUTF8String( sel);
   if( ! s)
   {
      if( ! sel)
         return( nil);
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "unknown selector id %08x (register selector first)", (uint32_t ) sel);
   }
   return( [NSString stringWithUTF8String:s]);
}


NSString   *MulleObjCStringFromProtocol( PROTOCOL proto)
{
   char   *s;

   s = MulleObjCProtocolGetNameUTF8String( proto);
   if( ! s)
   {
      if( ! proto)
         return( nil);
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "unknown protocol id %08x", (uint32_t ) proto);
   }
   return( [NSString stringWithUTF8String:s]);
}


NSString   *MulleObjCStringFromRange( NSRange range)
{
   // Apple does it with {}
   return( [NSString stringWithFormat:@"{ %lu, %lu }",
                  (unsigned long) range.location, (unsigned long) range.length]);
}


NSString  *MulleObjCStringByCombiningPrefixAndCapitalizedKey( NSString *prefix,
                                                              NSString *key,
                                                              BOOL tailColon)
{
   NSUInteger               prefix_len;
   NSUInteger               key_len;
   NSUInteger               len;
   char                     *buf;
   int                      c;
   NSString                 *s;
   struct mulle_allocator   *allocator;

   key_len = [key mulleUTF8StringLength];
   assert( key_len);

   if( key_len == 0)
      return( nil);

   allocator  = MulleObjCInstanceGetAllocator( key);
   prefix_len = [prefix mulleUTF8StringLength];
   len        = key_len + prefix_len + (tailColon == YES);

   buf = mulle_allocator_malloc( allocator, len);

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


int   MulleObjCPrintf( NSString *format, ...)
{
   va_list   va;
   int       rc;

   va_start( va, format);
   rc = mulle_vprintf( [format UTF8String], va);
   va_end( va);
   return( rc);
}

int   MulleObjCFprintf( FILE *fp,  NSString *format, ...)
{
   va_list   va;
   int       rc;

   va_start( va, format);
   rc = mulle_vfprintf( fp, [format UTF8String], va);
   va_end( va);
   return( rc);
}

