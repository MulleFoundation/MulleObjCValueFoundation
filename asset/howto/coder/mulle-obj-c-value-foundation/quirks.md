<!-- Keywords: quirks, pitfalls, unichar, encoding, thread-safety, no-copy -->
# Quirks

## unichar is 32-bit

`unichar` is typedef'd to `mulle_utf32_t` (32 bits), NOT 16-bit like on Apple platforms. See `src/String/NSString.h:50`.

## Three internal string encodings

NSString stores strings in one of three formats: ASCII (7-bit), UTF-16 (15-bit, no surrogate pairs), or UTF-32. UTF-8 is the external exchange format only. See `src/String/NSString.h:71-76`.

## NSMutableData is thread-unsafe

`NSMutableData` conforms to `MulleObjCThreadUnsafe`. Concurrent mutation requires external synchronization. `NSData`, `NSString`, and `NSNumber` are safe for concurrent reads. See `src/Data/NSMutableData.h:42`.

## NSMutableString is an array-of-NSStrings

`NSMutableString` stores appended strings as an internal array of `NSString *` pointers, not a contiguous buffer. Compaction happens on demand. Convert to `NSString` via `-copy`/`-autorelease` when done. See `src/String/NSMutableString.h:44-48`.

## No-copy semantics — `freeWhenDone:YES` deallocates immediately

`initWithBytesNoCopy:...freeWhenDone:YES` frees the bytes with `mulle_free()` immediately. The comment in `test/NSData/bytes-and-length.m` documents this. For safe zero-copy, use the `sharingObject:` variant (`mulleInitWithBytesNoCopy:...sharingObject:`) instead.

## `dataWithBytesNoCopy:length:` defaults to `freeWhenDone:NO`

The convenience class method `dataWithBytesNoCopy:length:` (without explicit `freeWhenDone:`) does NOT free the bytes. See `src/Data/NSData.h:59-60`.

## Hash uses FNV-1a on trailing characters

`MulleObjCGetHashStringRange` uses up to 32 characters from the end of the string. See `src/String/NSString+Hash.h`.

## NSNumber inherits from NSValue in MulleObjC

`NSValue` is defined in `MulleObjC`, not in this library. When looking up `NSValue` API, check `MulleObjC` headers. This library adds `NSCoding` categories to `NSValue`. See `src/Value/NSValue+NSCoder.h`.

## Tagged pointer limits

- Integers: `MulleObjCIntegerTPSIndex` (32+64 bit)
- Floats: `MulleObjCFloatTPSIndex` (32+64 bit)
- Doubles: `MulleObjCDoubleTPSIndex` (64 bit only)
- ASCII strings: 5 chars (`Char5`, 32+64 bit), 7 chars (`Char7`, 64 bit only)

See `src/_MulleObjCValueTaggedPointer.h:36-43`.

## `UTF8String` on non-ASCII strings may allocate a shadow buffer

UTF-16 and UTF-32 strings lazily cache a UTF-8 conversion in `_shadow` (atomic pointer). First access pays O(n) conversion cost; subsequent access is O(1). Do not hold the pointer if the string may change. See `src/String/_MulleObjCUTF16String.h`.

## NSData subclass selection by size

| Size range | Subclass |
|---|---|
| 0 bytes | `_MulleObjCZeroBytesData` |
| 1-8 bytes | `_MulleObjCEightBytesData` |
| 9-16 bytes | `_MulleObjCSixteenBytesData` |
| 1-256 bytes | `_MulleObjCTinyData` |
| 257-65792 bytes | `_MulleObjCMediumData` |
| >65792 bytes | `_MulleObjCAllocatorData` |

See `test/NSData/bytes-and-length.m` and `src/Data/_MulleObjCDataSubclasses.h`.
