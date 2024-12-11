### 0.23.1

* adapted to changed names in MulleObjC

## 0.23.0


feat: enhance string enumeration and tagged pointer support

* Add improved string enumeration capabilities
  - Add MulleStringFor and MulleStringReverseFor macros for faster character access
  - Support undo/redo operations for parser development
  - Add mulleGetNonCompactedCharacters:range: for direct string access

* Enhance tagged pointer support
  - Enable double and float tagged pointer support for 32/64-bit
  - Fix TPS (Tagged Pointer String) compatibility for 32-bit systems
  - Optimize char5/char7 string handling

* Improve build system and configuration
  - Add TAO (Thread Affine Objects) debug support via `OBJC_TAO_DEBUG_ENABLED`
  - Update CMake configuration for better cross-platform support
  - Fix Windows compatibility issues

* Code cleanup and optimization
  - Remove redundant string paging functionality
  - Improve string character enumeration performance
  - Update version to 0.23.0

* fixed TPS for 32 bit
* enable double and float TPS


## 0.22.0

* new character enumeration macros MulleStringFor and MulleStringReverseFor gives you access to unichars faster and more convenient than characterAtIndex: with added undo/redo support for writing parsers
* new method mulleGetNonCompactedCharacters:range: gives you access to NSMutableString contents w/o compacting
* NSNull is now part of MulleObjC
* new experimental MulleStringFor macro
* transition from `mulle_utf8_t` to char
* also rename MulleStringGetUTF8Data to MulleStringUTF8Data


### 0.21.2

* added +mulleStringWithUTF8Data: method
* encoding methods now use options: instead of prefixWithBom: withTerminatingZero:
* NSNull now accepts all unknown messages and returns nil for them (like nil)
* fixed mulleDataUsingEncoding:prefixWithBOM:terminateWithZero: for 8 bits representations not properly terminating with zero
* iso conversion now bails, if it can't represent the string
* UTF8 can now be emitted with a BOM

### 0.21.1

* Various small improvements

## 0.21.0

* moved NSDate related stuff to MulleObjCTimeFoundation
* changed GLOBALs for Windows
* moved MulleObjCPrintf here


## 0.20.0

* rewrote the code for floating point string encoding
* improved NSDate
* NSData respects -1 as a length input as well
* supports NSISOLatin1StringEncoding on input


## 0.19.0

* renamed mulleCData to cData
* moved NSLock categories elsewhere
* renamed `stringWithFormat:arguments:` to `mulleStringWithFormat:arguments`
* added `+[NSString availableStringEncodings]` and `-[NSString dataUsingEncoding:allowLossyConversion:]`
* added `-[NSString mulleGetUTF8Characters:maxLength:range:]`
* added `-[NSMutableString mulleAppendUTF8String:]`
* renamed `mulleData` to `cData`, but as its incompatible methods still get a `mulle` prefix, so the read accessor is now `mulleCData`


## 0.18.0

* renamed methods with owner: to sharingObject:
* change `_mulleConvertToASCIICharacters` to return a `mulle_asciidata` by reference
* change hash method for NSDate
* change hash for floating point NSNumber
* MulleObjCStringByCombiningPrefixAndCapitalizedKey inherited from KVCFoundation
* fix Bugs in NSString
* debugDescription is now diffable if `MULLE_TEST` is defined or MulleDebugDescriptionEllideAddressOutput is set to YES
* renamed -[NSMutableString mulleAppendFormat:arguments:] to mulleAppendFormat:mulleVarargList:, but added a proper mulleAppendFormat:arguments: with `va_list` arguments.
* added -[NSMutableString initWithFormat:arguments:]
* fix leak in -[NSString substringWithRange:]
* use the new struct `mulle_ascii_data` instead of struct `mulle_utf8_data` where its more fitting
* improved hasPrefix: hasSuffix:
* added mulleGetASCIICharacters:length:
* rename/hide class MulleObjCBoolNumber to `_MulleObjCBoolNumber`
* improved stringValue/description for NSNumber
* characterAtIndex: gains a ':' alias
* NSMutableString will compact itself, if it detects multiple characterAtIndex: calls
* simplified stringByAppendingString: greatly
* improved hash and isEqual for NSNumber
* NSNumber is now independent from NSValue in terms of hash/isEqual: (as it's supposed to)
* do self == other check only in -isEqual: and not in isEqualToString: anymore (experimentally)
* mulleFastUTF8Characters and family have been replaced by mulleFastGetUTF8Data: and family
* moved NSData+Unicode.m here from the MulleObjCStandardFoundation
* started using `struct `mulle_data`` that combines -bytes and -length
* added `-[NSMutableData mulleReplaceInvalidCharactersWithASCIICharacter:encoding:]`
* added `mulleSwapUTF16Characters` and `mulleSwapUTF32Characters`
* fix constant in `-initWithUnsignedLongLong`
* faster isEqualToString: (at least in my tests)
* added fnv1a hash functions for ``mulle_utf16_t`` and ``mulle_utf32_t`` characters
* can create tagged pointers from ``mulle_utf16_t`` and ``mulle_utf32_t`` characters now


### 0.17.2

* remove duplicate objc-loader.inc

### 0.17.1

* moved unicode functionality to MulleObjCUnicodeFoundation, basic ctype functionality remains

## 0.17.0

* adapt to `MulleObjCValidateRangeAgainstLength` returning a value now (`-1` can be used instead of `[self length]` in NSRange)
* make some previously private methods public and remove the `'_'` prefix on `NSMutableData`
* added +mulleStringWithData:encoding: convenience
* adapt to renames in `MulleObjC`
* added ``MulleObjC_vasprintf`` and ``MulleObjC_asprintf`` which return autoreleased `char` strings
* split off from MulleObjCStandardFoundation
