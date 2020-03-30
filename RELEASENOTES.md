## 0.17.0

* adapt to `MulleObjCValidateRangeAgainstLength` returning a value now (`-1` can be used instead of `[self length]` in NSRange)
* make some previously private methods public and remove the `'_'` prefix on `NSMutableData`
* added +mulleStringWithData:encoding: convenience
* adapt to renames in `MulleObjC`
* added ``MulleObjC_vasprintf`` and ``MulleObjC_asprintf`` which return autoreleased `char` strings
* split off from MulleObjCStandardFoundation
