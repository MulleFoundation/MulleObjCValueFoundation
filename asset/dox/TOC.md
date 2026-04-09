# MulleObjCValueFoundation Library Documentation for AI
<!-- Keywords: objc, string, data, number, value, tagged-pointer -->
## 1. Introduction & Purpose

- MulleObjCValueFoundation provides Objective-C value classes: NSString/NSMutableString, NSData/NSMutableData, NSNumber, and NSValue plus supporting utilities and NSCoder integrations.
- Solves boxed-value and text/binary handling needs for MulleObjC-based projects, with memory and tagged-pointer optimizations.
- Relationship: depends on the MulleObjC runtime; is a value-focused companion to MulleObjCFoundation.

## 2. Key Concepts & Design Philosophy

- Class-cluster public APIs (NSString, NSData, NSNumber, NSValue) with concrete subclasses and tagged-pointer representations for small/fast values.
- Small-object optimization: many value types are stored as tagged pointers when possible (integers, small strings, small numbers).
- Categories provide codec/utility APIs (NSCoder, NSString<>NSData conversion, sprintf-style formatting).
- Allocator-agnostic design: follows MulleObjC memory/allocator conventions; do not access internal _-prefixed fields.

## 3. Core API & Data Structures

### 3.1. [src/MulleObjCValueFoundation.h]
- Purpose: Umbrella header that exports the public API and version macros.
- Usage: #import "MulleObjCValueFoundation.h"

### 3.2. [String: src/String/*.h]
- NSString (class cluster)
  - Purpose: Immutable Unicode string abstraction.
  - Key categories: NSString+Sprintf.h, NSString+NSData.h, NSString+NSCoder.h, NSString+Hash.h, NSString+Enumerator.h.
  - Lifecycle: create via factory methods (stringWithUTF8String:, stringWithFormat:, named initializers); mutable variant is NSMutableString.
  - Core ops: length, characterAtIndex:, substringWithRange:, compare:, UTF conversions.
- NSMutableString: mutable operations (append, insert, replace).

### 3.3. [Data: src/Data/*.h]
- NSData
  - Purpose: Immutable byte buffer, with helpers for Unicode conversion and NSCoder.
  - Core ops: bytes, length, subdataWithRange:.
- NSMutableData
  - Purpose: Resizable byte buffer; append, setLength:, replaceBytesInRange:.
  - Concrete small/medium/large subclasses exist for performance.

### 3.4. [Value: src/Value/*.h]
- NSNumber
  - Purpose: Box numeric C types (int, float, double, bool). Provides conversion accessors and stringification.
  - Tagged-pointer optimizations for small/typical numbers.
  - Core ops: intValue, doubleValue, boolValue, compare:, stringValue.
- NSValue
  - Purpose: Box arbitrary C structs and typed values. Use valueWithBytes:objCType: and getValue: to extract.

### 3.5. Tagged-pointer and internals
- Headers: _MulleObjCValueTaggedPointer.h and multiple _MulleObjCTaggedPointer*.h
- Purpose: Internal compact representations. Avoid direct usage; use public APIs.

### 3.6. Reflection & build glue
- src/reflect/* provide export/import and version checks used during build and packaging.

## 4. Performance Characteristics

- Small-object/tagged-pointer: O(1) allocation and fast operations for small values.
- Immutable read ops: O(1) for length/values; substring/copy: O(n) when copying required.
- Mutable ops: append/replace may be amortized O(1) depending on implementation.
- Thread-safety: Immutable classes safe for concurrent reads; mutable classes require external synchronization.

## 5. AI Usage Recommendations & Patterns

- Best practices:
  - Import the umbrella header. Use factory methods and provided lifecycle functions.
  - Prefer immutable classes for concurrency; use NSMutable* only when mutability is required.
  - Use provided NSCoder categories for persistence.
- Pitfalls:
  - Do not access _-prefixed internals.
  - Beware borrowed pointers returned by bytes/UTF8String—do not free them unless documented.
  - Avoid excessive boxing/unboxing in hot loops.

## 6. Integration Examples

(All examples assume: #import "MulleObjCValueFoundation.h")

### Example 1: Creating and printing a string

```c
#import "MulleObjCValueFoundation.h"

int
main()
{
   NSString  *s;

   s = [NSString stringWithUTF8String:"Hello World"]; 
   printf("%s\n", [s UTF8String]);
   return( 0);
}
```

### Example 2: Using NSData and NSMutableData

```c
#import "MulleObjCValueFoundation.h"

int
main()
{
   unsigned char   bytes[] = { 0x41, 0x42, 0x43 };
   NSData         *d;
   NSMutableData  *m;

   d = [NSData dataWithBytes:bytes length:3];
   m = [NSMutableData dataWithData:d];
   [m appendBytes:"D" length:1];
   return( 0);
}
```

### Example 3: Boxing numbers

```c
#import "MulleObjCValueFoundation.h"

int
main()
{
   NSNumber  *n;

   n = [NSNumber numberWithInt:42];
   printf("%d\n", [n intValue]);
   return( 0);
}
```

## 7. Dependencies

- mulle-objc/MulleObjC
- mulle-objc/mulle-objc-list

## 8. Tests & examples

- Authoritative examples and edge-case behavior live in test/NSString, test/NSData, test/NSNumber, and test/NSValue. Consult those tests for lifecycle sequences, expected outputs, and corner cases.

---
Generated for AI consumption. Refer to src/ headers and test/ for authoritative details.
