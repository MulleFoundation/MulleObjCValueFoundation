#import "NSNumber.h"

#import "_MulleObjCValueTaggedPointer.h"
#import "_MulleObjCTaggedPointerFloatNumber.h"
#import "_NSNumberHash.h"
#import "import-private.h"


#ifdef __MULLE_OBJC_TPS__

@implementation _MulleObjCTaggedPointerFloatNumber

+ (void) load
{
   MulleObjCTaggedPointerRegisterClassAtIndex( self, MulleObjCFloatTPSIndex);
}

- (int32_t) _int32Value     { return( (int32_t) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (int64_t) _int64Value     { return( (int64_t) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }

- (BOOL) boolValue          { return( _MulleObjCTaggedPointerFloatNumberGetFloatValue( self) != 0.0 ? YES : NO); }
- (char) charValue          { return( (char) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (short) shortValue        { return( (short) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (int) intValue            { return( (int) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (long) longValue          { return( (long) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (NSInteger) integerValue  { return( (NSInteger) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (long long) longLongValue { return( (long long) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }

- (float) floatValue              { return( (float) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (double) doubleValue            { return( (double) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }
- (long double) longDoubleValue   { return( (long double) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self)); }


- (void) getValue:(void *) p_value
{
   float   value;

   value              = _MulleObjCTaggedPointerFloatNumberGetFloatValue( self);
   *(float *) p_value = value;
}


- (char *) objCType
{
   return( @encode( float));
}


- (enum MulleNumberIsEqualType) __mulleIsEqualType
{
#ifdef _C_LNG_DBL
   return( MulleNumberIsEqualLongDouble);
#else
   return( MulleNumberIsEqualDouble);
#endif
}


- (NSUInteger) hash
{
   float   value;

   value = _MulleObjCTaggedPointerFloatNumberGetFloatValue( self);
   return( NSNumberHashFloat( value));
}


- (BOOL) isEqualToNumber:(NSNumber *) other
{
   enum MulleNumberIsEqualType   otherType;
   long double                   value;

   if( self == other)
      return( YES);

   otherType = [other __mulleIsEqualType];
#ifdef _C_LNG_DBL
   if( otherType != MulleNumberIsEqualDefault)
   {
      if( MulleNumberIsEqualLongDouble != otherType)
         return( NO);
      value = (long double) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self);
      return( value == [other longDoubleValue]);
   }
#else
   if( otherType != MulleNumberIsEqualDefault)
   {
      if( MulleNumberIsEqualDouble != otherType)
         return( NO);
      value = (double) _MulleObjCTaggedPointerFloatNumberGetFloatValue( self);
      return( value == [other doubleValue]);
   }
#endif
   return( [other compare:self] == NSOrderedSame);
}

@end

#endif
