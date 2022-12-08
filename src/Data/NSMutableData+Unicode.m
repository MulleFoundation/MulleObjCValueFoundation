//
//  NSMutableData+Unicode.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
//  Copyright (c) 2020 Codeon GmbH.
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
#import "NSMutableData+Unicode.h"

#import "import-private.h"



@implementation NSMutableData( Unicode)

- (void) mulleSwapUTF16Characters
{
   mulle_utf16_t        *p;
   mulle_utf16_t        *sentinel;
   struct mulle_data    data;

   data     = [self mulleMutableData];
   p        = data.bytes;
   sentinel = &p[ data.length / sizeof( mulle_utf16_t)];

   while( p < sentinel)
   {
      *p = MulleObjCSwapUInt16( *p);
      ++p;
   }
}


- (void) mulleSwapUTF32Characters
{
   mulle_utf32_t        *p;
   mulle_utf32_t        *sentinel;
   struct mulle_data    data;

   data     = [self mulleMutableData];
   p        = data.bytes;
   sentinel = &p[ data.length / sizeof( mulle_utf32_t)];

   while( p < sentinel)
   {
      *p = MulleObjCSwapUInt32( *p);
      ++p;
   }
}

@end
