//
//  _MulleObjCDateSubclasses.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2021 Nat! - Mulle kybernetiK.
//  Copyright (c) 2021 Codeon GmbH.
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
#ifdef __has_include
# if __has_include( "NSDate.h")
#  import "NSDate.h"
# endif
#endif

#import "import.h"

//
// NSDate is supposed to be a container for UTC. UTC is a calendar time
// variant. It is not a physical time.
//
// This means that if you asked on 31.Dez.2016 23:59:59 for [NSDate date]
// and did this again in the next physical second, you should be getting a
// duplicate because of the leap second being added. But leap seconds are
// generally ignored when doing calendrical calculations...
//
// Arithmetic on NSDate is useful in terms of seconds, minutes and
// days, but is errorprone when extended to months or years due to
// leap years with varyiing numbers of days. When you use the proleptic
// gregorian calendar, as pretty much everyone is doing, interval values
// before 15.10.1582 will deviate by days from physical time!
//
//
// _MulleObjCConcreteDate is floating point with all it's problems.
@interface _MulleObjCConcreteDate : NSDate < MulleObjCImmutable>
{
   NSTimeInterval   _interval;
}

+ (instancetype) newWithTimeIntervalSinceReferenceDate:(NSTimeInterval) interval;

@end


@interface _MulleObjCConcreteDate( NSCoder) <NSCoding>
@end

