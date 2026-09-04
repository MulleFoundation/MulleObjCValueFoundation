//
//  mulle-chardata.h
//  MulleObjCValueFoundation
//
//  Copyright (c) 2021 Nat! - Mulle kybernetiK.
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
#ifndef mulle_chardata_h__
#define mulle_chardata_h__


// MEMO: I don't think this is used anywhere.

//
// mulle_utf8_t was useful on a C level, but in Objective-C there
// is only char * -> UTF8 and unichar -> mulle_utf32_t
//
// So we need MulleCharData and MulleUnicharData
// Also move from size_t to NSUInteger as type.
//
// The way char/unichar and NSString/char *s are two different families is
// still confusing but not really fixable, without burning all bridges:
//
// char                       unichar
// MulleCharData              MulleUnicharData
// UTF8Characters -> char *   Characters -> unichar *
// UTF8String -> char *       String -> id
//
struct MulleCharData
{
   char         *characters;
   NSUInteger   length;
};


static inline struct MulleCharData
   MulleCharDataMake( char *s, NSUInteger length)
{
   struct MulleCharData   data;

   data.characters = s;
   data.length     = length;
   return( data);
}


static inline struct MulleCharData
   MulleCharDataMakeWithCData( struct mulle_data data)
{
   struct MulleCharData   tmp;

   tmp.characters = data.bytes;
   tmp.length     = data.length;
   return( tmp);
}


static inline struct MulleCharData
   MulleCharDataMakeWithUTF8Data( struct mulle_utf8data data)
{
   struct MulleCharData   tmp;

   tmp.characters = (char *) data.characters;
   tmp.length     = data.length;
   return( tmp);
}


static inline struct MulleCharData
   MulleCharDataMakeWithASCIIData( struct mulle_asciidata data)
{
   struct MulleCharData   tmp;

   tmp.characters = data.characters;
   tmp.length     = data.length;
   return( tmp);
}


static inline struct mulle_data
   MulleCharDataGetCData( struct MulleCharData data)
{
   return( mulle_data_make( data.characters, data.length));
}


static inline struct mulle_utf8data
   MulleCharDataGetUTF8Data( struct MulleCharData data)
{
   return( mulle_utf8data_make( data.characters, data.length));
}


static inline struct mulle_asciidata
   MulleCharDataGetASCIIData( struct MulleCharData data)
{
   return( mulle_asciidata_make( data.characters, data.length));
}


/*
 * This is a "complex" datatype to keep characters/length of
 * unichar together.
 */
struct MulleUnicharData
{
   unichar      *characters;
   NSUInteger   length;
};


static inline struct MulleUnicharData
   MulleUnicharDataMake( unichar *s, NSUInteger length)
{
   struct MulleUnicharData   data;

   data.characters = s;
   data.length     = length;
   return( data);
}


static inline struct MulleUnicharData
   MulleUnicharDataMakeWithCData( struct mulle_data cdata)
{
   struct MulleUnicharData   data;

   data.characters = cdata.bytes;
   data.length     = cdata.length;
   return( data);
}


static inline struct MulleUnicharData
   MulleUnicharDataMakeWithUTF32CData( struct mulle_utf32data data)
{
   struct MulleUnicharData   tmp;

   tmp.characters = data.characters;
   tmp.length     = data.length;
   return( tmp);
}


static inline struct mulle_data
   MulleUnicharDataGetCData( struct MulleUnicharData data)
{
   return( mulle_data_make( data.characters, data.length));
}


static inline struct mulle_utf32data
   MulleUnicharDataGetUTF32CData( struct MulleUnicharData data)
{
   return( mulle_utf32data_make( data.characters, data.length));
}

#endif
