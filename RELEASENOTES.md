## 0.19.0

* Various small improvements


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
