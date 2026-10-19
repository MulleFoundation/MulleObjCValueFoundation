## 0.27.0








* Document the `MulleObjCStringPrimitive` protocol family (base, ASCII, UTF16, UTF32) that concrete `NSString` class-cluster classes must implement
* Document new global constructors `MulleNewNumberWithUTF8Data` and `MulleNewBoolWithUTF8Data`
* Note `NSMutableString` conformance to `MulleObjCStringPrimitive` and bump referenced version macro to 0.27.0



* Document the `MulleObjCStringPrimitive` protocol family (base, ASCII, UTF16, UTF32) that concrete `NSString` class-cluster classes must implement
* Document new global constructors `MulleNewNumberWithUTF8Data` and `MulleNewBoolWithUTF8Data`
* Note `NSMutableString` conformance to `MulleObjCStringPrimitive` and bump referenced version macro to 0.27.0





* NSMutableData -mutableBytes no longer promotes a recorded capacity into -length or exposes uninitialized bytes as data
* -dataWithLength: and -initWithLength: now return zero-filled contents instead of undefined bytes
* tagged pointer float and double NSNumber values now convert to ASCII, fixing -stringValue/plist/JSON number output for those types
* MulleNewNumberWithUTF8Data and MulleNewBoolWithUTF8Data are now exported for use across library boundaries


### 0.26.1



* `-UTF8String` on UTF-32 backed strings now returns a properly autoreleased character buffer, preventing memory leaks and dangling pointers
