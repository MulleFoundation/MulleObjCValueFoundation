# This file will be regenerated by `mulle-match-to-cmake` via
# `mulle-sde reflect` and any edits will be lost.
#
# This file will be included by cmake/share/Headers.cmake
#
if( MULLE_TRACE_INCLUDE)
   MESSAGE( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# contents are derived from the file locations

set( INCLUDE_DIRS
src
src/Data
src/Date
src/String
src/Value
src/reflect
)

#
# contents selected with patternfile ??-header--private-generated-headers
#
set( PRIVATE_GENERATED_HEADERS
src/reflect/_MulleObjCValueFoundation-import-private.h
src/reflect/_MulleObjCValueFoundation-include-private.h
)

#
# contents selected with patternfile ??-header--private-generic-headers
#
set( PRIVATE_GENERIC_HEADERS
src/import-private.h
src/include-private.h
)

#
# contents selected with patternfile ??-header--private-headers
#
set( PRIVATE_HEADERS
src/String/NSString+Substring-Private.h
src/Value/_MulleObjCConcreteValue-Private.h
src/Value/NSNumber-Private.h
src/Value/NSValue-Private.h
)

#
# contents selected with patternfile ??-header--public-generated-headers
#
set( PUBLIC_GENERATED_HEADERS
src/reflect/_MulleObjCValueFoundation-export.h
src/reflect/_MulleObjCValueFoundation-import.h
src/reflect/_MulleObjCValueFoundation-include.h
src/reflect/_MulleObjCValueFoundation-provide.h
)

#
# contents selected with patternfile ??-header--public-generic-headers
#
set( PUBLIC_GENERIC_HEADERS
src/import.h
src/include.h
)

#
# contents selected with patternfile ??-header--public-headers
#
set( PUBLIC_HEADERS
src/Data/_MulleObjCConcreteMutableData.h
src/Data/_MulleObjCDataSubclasses.h
src/Data/NSData+NSCoder.h
src/Data/NSData+Unicode.h
src/Data/NSData.h
src/Data/NSMutableData+Unicode.h
src/Data/NSMutableData.h
src/Date/_MulleObjCDateSubclasses.h
src/Date/NSDateFactory.h
src/Date/NSDate.h
src/MulleObjCLoader+MulleObjCValueFoundation.h
src/MulleObjCValueFoundation.h
src/String/_MulleObjCASCIIString.h
src/String/_MulleObjCCheatingASCIIString.h
src/String/_MulleObjCTaggedPointerChar5String.h
src/String/_MulleObjCTaggedPointerChar7String.h
src/String/_MulleObjCUTF16String.h
src/String/_MulleObjCUTF32String.h
src/String/NSConstantString.h
src/String/NSMutableData+NSString.h
src/String/NSMutableString.h
src/String/NSObject+NSString.h
src/String/NSString+ClassCluster.h
src/String/NSString+NSCoder.h
src/String/NSString+NSData.h
src/String/NSStringObjCFunctions.h
src/String/NSString+Sprintf.h
src/String/NSString.h
src/Value/_MulleObjCConcreteNumber.h
src/Value/_MulleObjCConcreteValue.h
src/Value/_MulleObjCTaggedPointerIntegerNumber.h
src/Value/NSNull.h
src/Value/NSNumber+NSCoder.h
src/Value/NSNumber+NSString.h
src/Value/NSNumber.h
src/Value/NSThread+NSDate.h
src/Value/NSValue+NSCoder.h
src/Value/NSValue.h
)

