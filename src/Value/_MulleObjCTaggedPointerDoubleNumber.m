#import "NSNumber.h"

#import "_MulleObjCValueTaggedPointer.h"
#import "_MulleObjCTaggedPointerDoubleNumber.h"
#import "_NSNumberHash.h"

#import "import-private.h"



#ifdef __MULLE_OBJC_TPS__

@implementation _MulleObjCTaggedPointerDoubleNumber

+ (void) load
{
   // if we can't register than no problem
   MulleObjCTaggedPointerRegisterClassAtIndex( self, MulleObjCDoubleTPSIndex);
}

- (int32_t) _int32Value     { return( (int32_t) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (int64_t) _int64Value     { return( (int64_t) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }

- (BOOL) boolValue          { return( _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self) != 0.0 ? YES : NO); }
- (char) charValue          { return( (char) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (short) shortValue        { return( (short) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (int) intValue            { return( (int) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (long) longValue          { return( (long) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (NSInteger) integerValue  { return( (NSInteger) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (long long) longLongValue { return( (long long) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (NSUInteger) unsignedDoubleValue    { return( (NSUInteger) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }

- (float) floatValue              { return( (float) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (double) doubleValue            { return( (double) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }
- (long double) longDoubleValue   { return( (long double) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self)); }


- (void) getValue:(void *) p_value
{
   double   value;

   value               = _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self);
   *(double *) p_value = value;
}


- (char *) objCType
{
   return( @encode( double));
}


- (enum MulleNumberIsEqualType) __mulleIsEqualType
{
   return( MulleNumberIsEqualLongDouble);
}


- (NSUInteger) hash
{
   double   value;

   value = _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self);
   return( NSNumberHashDouble( value));
}


- (BOOL) isEqualToNumber:(NSNumber *) other
{
   enum MulleNumberIsEqualType   otherType;
   long double                   value;

   if( self == other)
      return( YES);

   otherType = [other __mulleIsEqualType];
   if( otherType != MulleNumberIsEqualDefault)
   {
      if( MulleNumberIsEqualLongDouble != otherType)
         return( NO);
      value = (long double) _MulleObjCTaggedPointerDoubleNumberGetDoubleValue( self);
      return( value == [other longDoubleValue]);
   }

   return( [other compare:self] == NSOrderedSame);
}

@end

#endif
