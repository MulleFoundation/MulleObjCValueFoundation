<!-- Keywords: value, string, data, number, nsstring, nsdata, nsnumber -->
# MulleObjCValueFoundation coder guide

Use this guide when writing or modifying code that uses the value classes from MulleObjCValueFoundation: **NSString**, **NSMutableString**, **NSData**, **NSMutableData**, **NSNumber**, and related categories.

## Dominant API families

| Family | Classes | Surface |
|---|---|---|
| String | NSString, NSMutableString | Creation (`stringWithUTF8String:`, `string`), mutation (`appendString:`, `appendFormat:`), enumeration (`MulleStringFor`), encoding conversion, hash, NSCoding |
| Data | NSData, NSMutableData | Creation (`dataWithBytes:length:`, `data`), mutation (`appendBytes:length:`, `setLength:`), equality, range search, subdata |
| Number | NSNumber | Factory methods (`numberWithInt:`, `numberWithDouble:`), accessors (`intValue`, `doubleValue`), comparison (`compare:`), string conversion |
| Tagged Pointer | (internal) | Integers, floats, doubles, and small ASCII strings stored inline in the pointer; no heap allocation |
| Coder | NSValue+NSCoder, NSData+NSCoder, NSString+NSCoder, NSNumber+NSCoder | NSCoding conformance for persistence |
| Printf/Utility | NSStringObjCFunctions | `MulleObjCPrintf`, `NSStringFromClass`, `NSClassFromString`, `MulleStringUTF8Data` |

## Understand first

```bash
mulle-sde api cat class NSString
mulle-sde api cat class NSMutableString
mulle-sde api cat class NSData
mulle-sde api cat class NSMutableData
mulle-sde api cat class NSNumber
mulle-sde api apropos tagged-pointer
```

## Local references

| Path | What |
|---|---|
| `src/String/` | NSString, NSMutableString, encoding, enumeration, hash, printing |
| `src/Data/` | NSData, NSMutableData, Unicode BOM helpers |
| `src/Value/` | NSNumber, NSValue+NSCoder |
| `src/_MulleObjCValueTaggedPointer.h` | Tagged pointer indices (Char5, Char7, Integer, Float, Double) |
| `src/MulleObjCValueFoundation.h` | Umbrella header, version macro |
| `test/NSString/` | String creation, mutation, iteration, encoding, format tests |
| `test/NSData/` | Data creation, bytes-access, mutation, equality, range-search tests |
| `test/NSNumber/` | Number boxing, conversion, comparison, stringification tests |

## Primary workflow

1. Import `MulleObjCValueFoundation.h`.
2. Use factory methods (not `alloc`/`init`) to create value objects.
3. Prefer immutable classes (`NSString`, `NSData`, `NSNumber`) for read-heavy or concurrent use.
4. Use `NSMutableString` / `NSMutableData` only for incremental construction, then convert to immutable via `-copy` / `-autorelease`.
5. For string iteration, use the `MulleStringFor(s, c)` macro from `NSString+Enumerator.h`.
6. For NSLog-style output, use `MulleObjCPrintf()` with an NSString format string.

## Verify

```bash
mulle-sde test
```
