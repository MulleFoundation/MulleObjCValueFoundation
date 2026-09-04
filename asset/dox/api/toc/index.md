# MulleObjCValueFoundation Library Documentation for AI
<!-- Keywords: objc, string, data, number, value, tagged-pointer -->
## 1. Introduction & Purpose

- MulleObjCValueFoundation provides Objective-C value classes: NSString/NSMutableString, NSData/NSMutableData, NSNumber and their supporting utilities, NSCoder integrations, string enumeration, and formatting.
- Solves boxed-value and text/binary handling needs for MulleObjC-based projects, with memory and tagged-pointer optimizations.
- Relationship: depends on MulleObjC (which provides NSValue, NSObject, NSCoder, etc); is a value-focused companion to MulleObjCStandardFoundation. Part of the MulleFoundation umbrella.

## 2. Key Concepts & Design Philosophy

- Class-cluster public APIs (NSString, NSData, NSNumber) with concrete subclasses and tagged-pointer representations for small/fast values.
- Three internal string storage formats: ASCII (7-bit), UTF-16 (15-bit, no surrogate pairs), and UTF-32 (full Unicode). UTF-8 is the primary external exchange format.
- NSNumber inherits from NSValue (defined in MulleObjC, not here). This project adds NSCoder categories and NSString conversions to NSValue.
- Small-object optimization: many value types are stored as tagged pointers when possible (integers, 5-char ASCII strings, 7-char ASCII strings, floats, doubles).
- Allocator-aware design: follows MulleObjC memory/allocator conventions. Concrete classes support no-copy allocation via allocator or shared-object owners.
- DO NOT access internal `_`-prefixed fields in concrete subclass structs.

## 3. Core API & Data Structures

**All signatures below are copied verbatim from headers. Use exact types as shown.**

### 3.1. Umbrella Header: `src/MulleObjCValueFoundation.h`

- Purpose: Umbrella header that exports the public API and version macros.
- Version macro: `MULLE_OBJC_VALUE_FOUNDATION_VERSION` (currently `((0UL << 20) | (26 << 8) | 0)`).
- Usage: `#import "MulleObjCValueFoundation.h"`

### 3.2. String Classes: `src/String/*.h`

#### `NSMutableString` (NSMutableString.h)

A class to temporarily construct strings from other strings. Uses internal array of NSString pointers. Best practice: convert to a regular NSString after construction via copy/autorelease.

```
@interface NSMutableString : NSString < MulleObjCMutableValueProtocols>
```

Key methods:
- `+ (instancetype) stringWithCapacity:(NSUInteger) capacity;`
- `- (instancetype) initWithCapacity:(NSUInteger) capacity;`
- `- (instancetype) initWithStrings:(NSString **) strings count:(NSUInteger) count;`
- `- (void) appendString:(NSString *) s;`
- `- (void) appendFormat:(NSString *) format, ...;`
- `- (void) replaceCharactersInRange:(NSRange) aRange withString:(NSString *) replacement;`
- `- (void) deleteCharactersInRange:(NSRange) aRange;`
- `- (void) setString:(NSString *) s;` (nil is allowed, clears the string)
- `- (void) mulleAppendCharacters:(unichar *) buf length:(NSUInteger) length;`
- `- (void) mulleAppendUTF8String:(char *) cStr;`
- `- (void) mulleGetNonCompactedCharacters:(unichar *) buf range:(NSRange) inRange;`

#### `NSString` Category Additions on `NSMutableString` (NSMutableString.h)

- `- (NSString *) stringByAppendingString:(NSString *) other;`
- `- (NSString *) mulleStringByRemovingPrefix:(NSString *) other;`
- `- (NSString *) mulleStringByRemovingSuffix:(NSString *) other;`

#### Full Namespace: Enumeration & Hash

- `unichar` typedef = `mulle_utf32_t`
- `NSStringCompareOptions` enum: `NSCaseInsensitiveSearch`, `NSLiteralSearch`, `NSBackwardsSearch`, `NSAnchoredSearch`, `NSNumericSearch`

#### Concrete String Subclasses

**ASCII hierarchy** (`_MulleObjCASCIIString.h`):
- `_MulleObjCASCIIString` (abstract base, knows its own length)
- `_MulleObjCTinyASCIIString` (1-256 chars, inline storage)
- `_MulleObjCGenericASCIIString` (257+ chars, inline flexible array)
- `_MulleObjCReferencingASCIIString` (points to external storage, has shadow for UTF8)
- `_MulleObjCAllocatorASCIIString` (owned via mulle_allocator)
- `_MulleObjCSharedASCIIString` (owned via sharing object, prevents dealloc)
- `_MulleObjCAllocatorZeroTerminatedASCIIString` (zero-terminated, owned via allocator)

**UTF-16 hierarchy** (`_MulleObjCUTF16String.h`):
- `_MulleObjCUTF16String` (abstract base — no length, no storage, no shadow; used as base for NSConstantStringUTF16)
- `_MulleObjCUTF16ShadowingString` (extends base, adds `_length` and `_shadow` for cached UTF8; used by allocatable subclasses)
- `_MulleObjCGenericUTF16String` (inline flexible array, extends shadowing)
- `_MulleObjCAllocatorUTF16String` (owned via mulle_allocator, extends shadowing)
- `_MulleObjCSharedUTF16String` (owned via sharing object, extends shadowing)

**UTF-32 hierarchy** (`_MulleObjCUTF32String.h`):
- `_MulleObjCUTF32String` (abstract base, no shadow)
- `_MulleObjCUTF32ShadowingString` (adds `_length` and `_shadow`, for allocatable subclasses)
- `_MulleObjCGenericUTF32String` (inline flexible array, extends shadowing)
- `_MulleObjCAllocatorUTF32String` (owned via mulle_allocator, extends shadowing)
- `_MulleObjCSharedUTF32String` (owned via sharing object, extends shadowing)

**Constant Strings** (`NSConstantString.h`):
- `NSConstantString` (extends `_MulleObjCASCIIString`, compiler-generated, ivar layout fixed for ABI)
- `NSConstantStringUTF16` (extends `_MulleObjCUTF16String`, compiler-generated UTF-15 strings)
- `NSConstantStringUTF32` (extends `_MulleObjCUTF32String`, compiler-generated)

**Tagged-Pointer Strings**:
- `_MulleObjCTaggedPointerChar5String` (5-char ASCII inline in pointer, 32+64bit)
- `_MulleObjCTaggedPointerChar7String` (7-char ASCII inline in pointer, 64bit only)

#### `NSString` Categories

**NSString+Hash.h** — FNV-1a hashing for all string encodings:
- `MulleObjCGetHashStringRange(NSUInteger length)` → uses up to 32 chars from end
- `MulleObjCStringHashASCII(char *buf, NSUInteger length)`
- `MulleObjCStringHashUTF16Bit15(mulle_utf16_t *buf, NSUInteger length)`
- `MulleObjCStringHashUTF32(mulle_utf32_t *buf, NSUInteger length)`
- Global functions: `_mulle_utf16_15bit_fnv1a(...)`, `_mulle_utf32_fnv1a(...)` and chained variants

**NSString+Sprintf.h** — sprintf-style string creation:
- `+ (instancetype) stringWithFormat:(NSString *) format, ...;`
- `+ (instancetype) stringWithFormat:(NSString *) format mulleVarargList:(mulle_vararg_list) arguments;`
- `+ (instancetype) mulleStringWithFormat:(NSString *) format arguments:(va_list) args;`
- `- (instancetype) initWithFormat:(NSString *) format, ...;`
- `- (instancetype) initWithFormat:(NSString *) format mulleVarargList:(mulle_vararg_list) arguments;`
- `- (instancetype) initWithFormat:(NSString *) format arguments:(va_list) va_list;`
- `- (NSString *) stringByAppendingFormat:(NSString *) format, ...;`

**NSString+NSData.h** — Encoding conversion and data interop:
- `+ (NSStringEncoding *) availableStringEncodings;`
- `- (NSStringEncoding) fastestEncoding;`
- `- (NSStringEncoding) smallestEncoding;`
- `- (BOOL) canBeConvertedToEncoding:(NSStringEncoding) encoding;`
- `- (NSData *) dataUsingEncoding:(NSStringEncoding) encoding;`
- `- (instancetype) initWithData:(NSData *) data encoding:(NSUInteger) encoding;`
- `- (instancetype) initWithBytes:(void *) bytes length:(NSUInteger) length encoding:(NSStringEncoding) encoding;`
- `- (BOOL) getBytes:(void *) buffer maxLength:(NSUInteger) maxLength usedLength:(NSUInteger *) usedLength encoding:(NSStringEncoding) encoding options:(NSStringEncodingConversionOptions) options range:(NSRange) range remainingRange:(NSRangePointer) leftover;`
- `- (NSUInteger) lengthOfBytesUsingEncoding:(NSStringEncoding) encoding;`
- Mulle additions: `+ (instancetype) mulleStringWithUTF8Data:(NSData *) data;`, `- (instancetype) mulleInitWithUTF16Characters:(mulle_utf16_t *) chars length:(NSUInteger) length;`, `- (instancetype) mulleInitWithDataNoCopy:(NSData *) s encoding:(NSStringEncoding) encoding;`

**NSString+NSCoder.h** — NSCoding conformance:
- `@interface NSString( NSCoder) <NSCoding>` (conforms to NSCoding, decode/encode)

**NSString+Enumerator.h** — Character-by-character iteration via `struct MulleStringEnumerator`:
- `struct MulleStringEnumerator` with fields: `_curr`, `_start`, `_sentinel`, `_size`, `_get` (function pointer), `_buf[]`
- `void _MulleStringEnumeratorInit(struct MulleStringEnumerator *rover, NSString *s);`
- Inline forward iteration: `MulleStringEnumeratorNext(rover, &c)`, `MulleStringFor(s, c)` macro
- Inline reverse iteration: `MulleStringEnumeratorPrevious(rover, &c)`, `MulleStringReverseFor(s, c)` macro
- `MulleStringEnumeratorGetIndex(rover)` — current character index
- `MulleStringEnumeratorHasCharacters(rover)`, `MulleStringEnumeratorRestart(rover)`, `MulleStringEnumeratorFinish(rover)`
- `_MulleStringEnumeratorUndoNext(rover, &c, &d)`, `_MulleStringEnumeratorUndoPrevious(rover, &c, &d)` — parser look-back

**NSStringObjCFunctions.h** — Utility C functions:
- `MulleObjCClassFromString(NSString *)`, `MulleObjCSelectorFromString(NSString *)`
- `MulleObjCStringFromClass(Class)`, `MulleObjCStringFromSelector(SEL)`, `MulleObjCStringFromRange(NSRange)`
- Static-inline aliases: `NSClassFromString()`, `NSSelectorFromString()`, `NSStringFromClass()`, `NSStringFromSelector()`, `NSStringFromRange()`
- `MulleObjCStringByCombiningPrefixAndCapitalizedKey(NSString *prefix, NSString *key, BOOL tailingColon)`
- Printf wrappers: `MulleObjCPrintf(NSString *format, ...)`, `MulleObjCFprintf(FILE *fp, NSString *format, ...)`, plus va_list/mulle_vararg_list variants

**NSString+ClassCluster.h** — Placeholder class management for NSString cluster.

**NSObject+NSString.h** — Description on all objects:
- `- (NSString *) description;`
- `- (NSString *) mulleTestDescription;` (no variable data like addresses)
- `- (NSString *) mulleQuotedDescriptionIfNeeded;` (quotes for NSString/NSNumber)
- `- (NSComparisonResult) mulleCompareDescription:(id) other;`

**NSStringEncoding.h** — Encoding constants and types.

**mulle-chardata.h** — C data structures for character data:
- `struct MulleCharData { char *characters; NSUInteger length; }` + factory/conversion functions
- `struct MulleUnicharData { unichar *characters; NSUInteger length; }` + factory/conversion functions

### 3.3. Data Classes: `src/Data/*.h`

#### `NSData` (NSData.h)

```
@interface NSData : NSObject < MulleObjCClassCluster, MulleObjCValueProtocols>
```

Key methods:
- `- (instancetype) initWithBytesNoCopy:(void *) bytes length:(NSUInteger) length;`
- `- (instancetype) initWithBytesNoCopy:(void *) bytes length:(NSUInteger) length freeWhenDone:(BOOL) flag;`
- `- (instancetype) initWithData:(NSData *) other;`
- `+ (instancetype) dataWithBytes:(void *) bytes length:(NSUInteger) length;`
- `+ (instancetype) dataWithBytesNoCopy:(void *) bytes length:(NSUInteger) length;`
- `+ (instancetype) dataWithBytesNoCopy:(void *) bytes length:(NSUInteger) length freeWhenDone:(BOOL) flag;`
- `+ (instancetype) data;`
- `+ (instancetype) dataWithData:(NSData *) other;`
- `+ (instancetype) mulleDataWithCData:(struct mulle_data) data;`
- `- (void) getBytes:(void *) bytes;`
- `- (void) getBytes:(void *) bytes length:(NSUInteger) length;`
- `- (void) getBytes:(void *) bytes range:(NSRange) range;`
- `- (BOOL) isEqualToData:(NSData *) other;`
- `- (NSData *) subdataWithRange:(NSRange) range;`
- `- (NSUInteger) hash;`
- `- (BOOL) isEqual:(id) other;`
- `- (NSRange) rangeOfData:(id) other options:(NSUInteger) options range:(NSRange) range;`

SubclassesFuture protocol:
- `- (NSUInteger) length;`
- `- (void *) bytes;`
- `- (struct mulle_data) mulleCData;`

#### `NSMutableData` (NSMutableData.h)

```
@interface NSMutableData : NSData < MulleObjCClassCluster, MulleObjCThreadUnsafe>
```

Key methods:
- `+ (instancetype) dataWithCapacity:(NSUInteger) aNumItems;`
- `+ (instancetype) dataWithLength:(NSUInteger) length;`
- `- (instancetype) initWithLength:(NSUInteger) length;`
- `- (instancetype) initWithCapacity:(NSUInteger) capacity;`
- `- (void) appendBytes:(void *) bytes length:(NSUInteger) length;`
- `- (void) appendData:(NSData *) otherData;`
- `- (void) setData:(NSData *) aData;`
- `- (void) increaseLengthBy:(NSUInteger) extraLength;`
- `- (void *) mutableBytes;`
- `- (struct mulle_data) mulleMutableData;`
- `- (void) resetBytesInRange:(NSRange) range;`
- `- (void) replaceBytesInRange:(NSRange) range withBytes:(void *) bytes;`
- `- (void) replaceBytesInRange:(NSRange) range withBytes:(void *) replacementBytes length:(NSUInteger) replacementLength;`
- `- (void) setLength:(NSUInteger) length;`
- Mulle additions: `- (void) mulleSetLengthDontZero:(NSUInteger) length;`, `+ (instancetype) mulleNonZeroedDataWithLength:(NSUInteger) length;`

#### Concrete Data Subclasses (`_MulleObjCDataSubclasses.h`)

- `_MulleObjCConcreteData` (abstract base with bytes)
- `_MulleObjCZeroBytesData` (literal zero-length data)
- `_MulleObjCEightBytesData` (8-byte fixed storage)
- `_MulleObjCSixteenBytesData` (16-byte fixed storage)
- `_MulleObjCTinyData` (1-256 bytes, inline `_storage[3]` with `uint8_t _length`)
- `_MulleObjCMediumData` (257-65792 bytes, inline `_storage[2]` with `uint16_t _length`)
- `_MulleObjCAllocatorData` (owned via mulle_allocator)
- `_MulleObjCSharedData` (owned via sharing object, extends `_MulleObjCAllocatorData`)

#### Data Categories

**NSData+Unicode.h** — BOM detection and UTF conversion:
- `_MulleObjCByteOrderMark` enum: `_MulleObjCNoByteOrderMark`, `_MulleObjCUTF8ByteOrderMark`, `_MulleObjCUTF16LittleEndianByteOrderMark`, `_MulleObjCUTF16BigEndianByteOrderMark`
- `- (_MulleObjCByteOrderMark) _byteOrderMark;`
- `- (NSData *) mulleConvertedUTF16ToUTF8Data;`
- `- (NSData *) mulleSwappedUTF16CharacterData;`
- `- (NSData *) mulleSwappedUTF32CharacterData;`

**NSData+NSCoder.h** — NSCoding conformance for NSData.

**NSMutableData+Unicode.h** — Unicode conversion operations for mutable data.

### 3.4. Number Classes: `src/Value/*.h`

#### `NSNumber` (NSNumber.h)

```
@interface NSNumber : NSValue < NSCopying, MulleObjCImmutableCopying, MulleObjCClassCluster>
```

Factory methods (each returns instancetype):
- `numberWithChar:(char)`, `numberWithUnsignedChar:(unsigned char)`
- `numberWithShort:(short)`, `numberWithUnsignedShort:(unsigned short)`
- `numberWithInt:(int)`, `numberWithUnsignedInt:(unsigned int)`
- `numberWithInteger:(NSInteger)`, `numberWithUnsignedInteger:(NSUInteger)`
- `numberWithLong:(long)`, `numberWithUnsignedLong:(unsigned long)`
- `numberWithLongLong:(long long)`, `numberWithUnsignedLongLong:(unsigned long long)`
- `numberWithFloat:(float)`, `numberWithDouble:(double)`
- `numberWithLongDouble:(long double)` (if `_C_LNG_DBL`)
- `numberWithBool:(BOOL)`

Init methods mirror the factory list. Accessor methods:
- `- (BOOL) boolValue;`, `- (char) charValue;`, `- (unsigned char) unsignedCharValue;`
- `- (short) shortValue;`, `- (unsigned short) unsignedShortValue;`
- `- (int) intValue;`, `- (unsigned int) unsignedIntValue;`
- `- (long) longValue;`, `- (unsigned long) unsignedLongValue;`
- `- (float) floatValue;`
- `- (NSUInteger) unsignedIntegerValue;`
- `- (unsigned long long) unsignedLongLongValue;`

Comparison and type query:
- `- (NSComparisonResult) compare:(id) other;`
- `- (BOOL) isEqualToNumber:(id) other;`
- `- (enum MulleNumberIsEqualType) __mulleIsEqualType;` (returns `MulleNumberIsEqualDefault`, `MulleNumberIsEqualDouble`, `MulleNumberIsEqualLongDouble`, or `MulleNumberIsEqualLongLong`)
- `- (_ns_superquad) _superquadValue;` (128-bit representation for comparison)
- `Type _ns_superquad { uint64_t lo; int64_t hi; }` with `_ns_superquad_compare()`

SubclassesFuture protocol:
- `- (NSInteger) integerValue;`
- `- (double) doubleValue;`
- `- (long double) longDoubleValue;` (if `_C_LNG_DBL`)
- `- (long long) longLongValue;`

#### Concrete Number Subclasses

- `_MulleObjCConcreteNumber` (allocated NSNumber for values that don't fit tagged pointers)
- `_MulleObjCTaggedPointerIntegerNumber` (inlined integer via tagged pointer, `MulleObjCIntegerTPSIndex`)
- `_MulleObjCTaggedPointerFloatNumber` (inlined float via tagged pointer, `MulleObjCFloatTPSIndex`)
- `_MulleObjCTaggedPointerDoubleNumber` (inlined double via tagged pointer, 64bit only, `MulleObjCDoubleTPSIndex`)

#### Number Categories

**NSNumber+NSString.h** — `- (NSString *) stringValue;` and stringification.

**NSNumber+NSCoder.h** — NSCoding conformance.

#### `NSValue` Categories (NSValue is defined in MulleObjC, not here)

**NSValue+NSCoder.h** — NSCoding conformance:
- `- (void) encodeWithCoder:(NSCoder *) coder;`
- `- (instancetype) initWithCoder:(NSCoder *) coder;`
- `- (void) decodeWithCoder:(NSCoder *) coder;`

**NSValue+NSString.m** — String conversion for NSValue.

### 3.5. Tagged Pointer Infrastructure

`src/_MulleObjCValueTaggedPointer.h` defines tagged-pointer indices:
```
enum {
   MulleObjCChar5TPSIndex   = 0x1,  // 5-char ASCII string (32+64 bit)
   MulleObjCIntegerTPSIndex = 0x2,  // integer number (32+64 bit)
   MulleObjCFloatTPSIndex   = 0x3,  // float number (32+64 bit)
   MulleObjCChar7TPSIndex   = 0x4,  // 7-char ASCII string (64 bit only)
   MulleObjCDoubleTPSIndex  = 0x5,  // double number (64 bit only)
};
```

### 3.6. Reflection & Build Glue: `src/reflect/`

Auto-generated headers for export/import and version checks used during build and packaging. Not part of the public API but necessary for the build system.

## 4. Performance Characteristics

- Small-object/tagged-pointer: O(1) "allocation" and fast operations for small values (integers, small strings, floats). No heap allocation needed.
- Immutable read ops: O(1) for length/values; substring/copy: O(n) when copying is required.
- `UTF8String` on UTF-16/UTF-32 strings: lazy caching via `_shadow` field (`mulle_atomic_pointer_t`), O(n) on first access, O(1) after.
- Mutable ops: append/replace may trigger reallocation and string compaction; amortized O(1) for many operations.
- Thread-safety: Immutable classes (NSString, NSData, NSNumber, NSValue) are safe for concurrent reads. Mutable classes (NSMutableString, NSMutableData) require external synchronization. NSMutableData explicitly conforms to `MulleObjCThreadUnsafe`.
- Data subclasses select inline vs. allocated storage based on size: 0 bytes (ZeroBytes), 8 bytes, 16 bytes, Tiny (1-256), Medium (257-65792), Allocator (large).

## 5. AI Usage Recommendations & Patterns

- **Best Practices:**
  - Import the umbrella header: `#import "MulleObjCValueFoundation.h"`
  - Use factory methods (`+stringWithUTF8String:`, `+dataWithBytes:length:`, `+numberWithInt:`) for creation.
  - Prefer immutable classes for concurrency; use NSMutable* only when mutability is required.
  - When done constructing, convert NSMutableString to NSString via copy/autorelease.
  - Use `MulleStringFor(s, c)` and `MulleStringReverseFor(s, c)` macros for safe, efficient string iteration.
  - Use `MulleObjCPrintf()` / `MulleObjCFprintf()` for printf-style output with NSString format.
  - Use provided NSCoder categories for persistence.
  - For hash computation, use `MulleObjCStringHashASCII()`, `MulleObjCStringHashUTF16Bit15()`, or `MulleObjCStringHashUTF32()`.

- **Common Pitfalls:**
  - Do NOT access `_`-prefixed internal fields in concrete subclass structs.
  - Beware borrowed pointers returned by `bytes`/`UTF8String` — DO NOT free them unless documented as owned.
  - `UTF8String` on UTF-16/UTF-32 strings may allocate a shadow buffer; do not hang onto the pointer if the string changes (for mutable strings).
  - Avoid excessive boxing/unboxing of numbers in hot loops.
  - NSNumber inherits from NSValue which is defined in MulleObjC, not here. When looking up NSValue API, check MulleObjC headers.
  - `unichar` is typedef'd to `mulle_utf32_t` (32-bit), NOT 16-bit.
  - `initWithBytesNoCopy:...freeWhenDone:` with YES frees bytes immediately; this is documented as "a lie" — prefer no-copy sharing-object variants.

- **Idiomatic Usage:**
  - Use `[NSString mulleStringWithUTF8Characters:length:]` for length-delimited UTF-8 without zero terminator.
  - Use `[NSString mulleStringWithCharactersNoCopy:length:allocator:]` for zero-copy string creation with custom allocator.
  - Use `[NSData mulleDataWithCData:]` to convert `struct mulle_data` to NSData.
  - Use `MulleStringUTF8Data(NSString *, struct mulle_utf8data)` global function for safe UTF8 data extraction.

## 6. Integration Examples

### Example 1: Creating and using strings

```c
#import "MulleObjCValueFoundation.h"

int   main( void)
{
   NSString   *s;

   s = [NSString stringWithUTF8String:"Hello World"];
   mulle_printf( "%s\n", [s UTF8String]);

   // Use length-delimited UTF-8 (not zero-terminated)
   s = [NSString mulleStringWithUTF8Characters:"abcdef"
                                        length:3];
   mulle_printf( "%s\n", [s UTF8String]);  // prints "abc"

   return( 0);
}
```

### Example 2: String iteration with MulleStringFor

```c
#import "MulleObjCValueFoundation.h"

int   main( void)
{
   NSString   *s;
   unichar    c;

   s = [NSString stringWithUTF8String:"Hello"];

   MulleStringFor( s, c)
      mulle_printf( "%c", (char) c);
   mulle_printf( "\n");

   return( 0);
}
```

### Example 3: NSMutableString construction

```c
#import "MulleObjCValueFoundation.h"

int   main( void)
{
   NSMutableString   *m;
   NSString          *s;

   m = [NSMutableString string];
   [m appendString:@"Hello"];
   [m appendString:@" "];
   [m appendFormat:@"%s %d", "World", 42];

   s = [[m copy] autorelease];  // convert to immutable
   mulle_printf( "%s\n", [s UTF8String]);

   return( 0);
}
```

### Example 4: Using NSData and NSMutableData

```c
#import "MulleObjCValueFoundation.h"

int   main( void)
{
   unsigned char    bytes[] = { 0x41, 0x42, 0x43 };
   NSData          *d;
   NSMutableData   *m;

   d = [NSData dataWithBytes:bytes
                      length:3];
   m = [NSMutableData dataWithData:d];
   [m appendBytes:"D"
          length:1];
   [m setLength:10];  // extend, zero-filled

   mulle_printf( "%ld\n", (long) [m length]);

   return( 0);
}
```

### Example 5: Boxing numbers and comparison

```c
#import "MulleObjCValueFoundation.h"

int   main( void)
{
   NSNumber   *n;
   NSNumber   *m;

   n = [NSNumber numberWithInt:42];
   m = [NSNumber numberWithDouble:42.0];

   mulle_printf( "intValue: %d\n", [n intValue]);
   mulle_printf( "equal: %d\n", [n isEqualToNumber:m]);

   return( 0);
}
```

### Example 6: String encoding conversion

```c
#import "MulleObjCValueFoundation.h"

int   main( void)
{
   NSString   *s;
   NSData     *data;

   s    = [NSString stringWithUTF8String:"Cafe"];
   data = [s dataUsingEncoding:NSUTF8StringEncoding];
   s    = [[[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding] autorelease];

   mulle_printf( "%s\n", [s UTF8String]);

   return( 0);
}
```

## 7. Dependencies

- mulle-objc/MulleObjC (provides NSObject, NSValue, NSCoder, tagged-pointer support, allocator, and runtime)
- mulle-objc/mulle-objc-list (build-time only, no-link, no-header)

## 8. Tests & Examples

Authoritative examples and edge-case behavior live in:
- `test/NSString/` — string creation, iteration, hashing, encoding, mutable ops, UTF-16 roundtrip, format, substring
- `test/NSData/` — data creation, byte access, mutable ops, equality, range search
- `test/NSNumber/` — integer/float/double conversion, comparison, stringification, hash, type-specific behavior
- `test/NSValue/` — value boxing/extraction, stringification

Consult those tests for lifecycle sequences, expected outputs, and corner cases.

---
Generated for AI consumption. Refer to src/ headers and test/ for authoritative details.
