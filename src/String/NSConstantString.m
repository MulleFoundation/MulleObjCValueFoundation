//
//  NSConstantString.m
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
#import "NSString.h"
#import "NSStringEncoding.h"

#import "NSString+Hash.h"

#import "NSConstantString.h"


// other files in this library

// std-c and dependencies
#import "import-private.h"


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@implementation NSConstantString

//
//  http://lists.apple.com/archives/objc-language/2006/Jan/msg00013.html
//

- (char *) UTF8String
{
   return( _storage);
}


static BOOL   NSConstantStringGetData( NSConstantString *self, SEL _cmd, void *_param)
{
   struct mulle_asciidata *space = _param;

   space->characters = self->_storage;
   space->length     = self->_length;
   return( YES);
}


@method_implementation -mulleFastGetASCIIData: = NSConstantStringGetData;
@method_implementation -mulleFastGetUTF8Data:  = NSConstantStringGetData;


- (NSUInteger) length
{
   return( _length);
}

@method_implementation -mulleUTF8StringLength = -length;



- (unichar) characterAtIndex:(NSUInteger) index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


@method_implementation -: = -characterAtIndex:;


- (instancetype) retain
{
   return( self);
}


- (void) release
{
}

@method_implementation -autorelease = -retain;


- (void) dealloc
{
   assert( 0 && "deallocing a NSConstantString ???");
}

@end



@implementation NSConstantStringUTF16

- (unichar) characterAtIndex:(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


@method_implementation -: = -characterAtIndex:;


- (BOOL) mulleFastGetUTF16Data:(struct mulle_utf16data *) data
{
   data->characters = _storage;
   data->length     = _length;
   return( YES);
}


- (NSUInteger) hash
{
   return( MulleObjCStringHashUTF16Bit15( _storage, _length));
}


- (NSUInteger) length
{
   return( _length);
}


- (instancetype) retain
{
   return( self);
}

@method_implementation -autorelease = -retain;


- (void) release
{
}


- (void) dealloc
{
   assert( 0 && "deallocing a NSConstantString16 ???");
}

@end


@implementation NSConstantStringUTF32


- (unichar) characterAtIndex:(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


@method_implementation -: = -characterAtIndex:;


- (BOOL) mulleFastGetUTF32Data:(struct mulle_utf32data *) data
{
   data->characters = _storage;
   data->length     = _length;
   return( YES);
}


- (NSUInteger) hash
{
   return( MulleObjCStringHashUTF32( _storage, _length));
}


- (NSUInteger) length
{
   return( _length);
}


- (instancetype) retain
{
   return( self);
}

@method_implementation -autorelease = -retain;


- (void) release
{
}


- (void) dealloc
{
   assert( 0 && "deallocing a NSConstantString16 ???");
}

@end


// ------------------

@interface NSConstantStringLoader
@end


@implementation NSConstantStringLoader

@dependency NSThread;
@dependency NSConstantString;
@dependency NSConstantStringUTF16;
@dependency NSConstantStringUTF32;
#ifdef __MULLE_OBJC_TPS__
@dependency _MulleObjCTaggedPointerChar7String;
@dependency _MulleObjCTaggedPointerChar5String;
#endif


+ (void) load
{
   struct _mulle_objc_universe    *universe;
   struct _mulle_objc_infraclass  *classes[ MULLE_OBJC_STATICINSTANCE_CLASS_SLOTS];

   memset( classes, 0, sizeof( classes));
   classes[ 0] = (struct _mulle_objc_infraclass *) [NSConstantString class];
   classes[ 1] = (struct _mulle_objc_infraclass *) [NSConstantStringUTF16 class];
   classes[ 2] = (struct _mulle_objc_infraclass *) [NSConstantStringUTF32 class];

   universe = _mulle_objc_infraclass_get_universe( self);
   _mulle_objc_universe_set_staticinstanceclasses( universe, classes, 0);
}

@end
