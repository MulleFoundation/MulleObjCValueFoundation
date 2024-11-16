#import "import-private.h"


#import "NSString+Sprintf.h"


@implementation NSThread( NSString)

- (NSString *) description
{
   return( [NSString stringWithUTF8String:[self UTF8String]]);
}


- (NSString *) mulleTestDescription
{
   return( [self description]);
}


- (NSString *) mulleDebugContentsDescription      MULLE_OBJC_THREADSAFE_METHOD
{
   return( nil);
}


- (NSString *) debugDescription                   MULLE_OBJC_THREADSAFE_METHOD
{
   return( [NSString stringWithFormat:@"<%@ %p \"%s\">", [self class], self, [self mulleNameUTF8String]]);
}


@end
