//
//  MulleObjCFoundation.h
//  MulleObjCValueFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "import.h"

// keep this in sync with MULLE_OBJC_VERSION, else pain! (why ?)
#define MULLE_OBJC_VALUE_FOUNDATION_VERSION   ((0 << 20) | (18 << 8) | 0)

#import "NSData+NSCoder.h"
#import "NSData.h"
#import "NSData+Unicode.h"
#import "NSDate+NSCoder.h"
#import "NSDate.h"
#import "NSDateFactory.h"
#import "NSLock+NSDate.h"
#import "NSMutableData.h"
#import "NSMutableData+NSString.h"
#import "NSMutableData+Unicode.h"
#import "NSMutableString.h"
#import "NSNull.h"
#import "NSNumber+NSCoder.h"
#import "NSNumber+NSString.h"
#import "NSNumber.h"
#import "NSObject+NSString.h"
#import "NSString+ClassCluster.h"
#import "NSString+NSCoder.h"
#import "NSString+NSData.h"
#import "NSString+Sprintf.h"
#import "NSString.h"
#import "NSStringObjCFunctions.h"
#import "NSThread+NSDate.h"
#import "NSValue+NSCoder.h"
#import "NSValue.h"

#import "mulle_sprintf_object.h"

#import "MulleObjCLoader+MulleObjCValueFoundation.h"

#if MULLE_OBJC_VERSION < ((0 << 20) | (14 << 8) | 0)
# error "MulleObjC is too old"
#endif
