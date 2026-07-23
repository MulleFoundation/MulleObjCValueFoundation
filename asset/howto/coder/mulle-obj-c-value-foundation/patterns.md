<!-- Keywords: pattern, snippet, creation, mutation, enumeration, boxing -->
# Patterns

## NSString creation

Use factory methods, not `alloc`/`init`:

```bash
s = [NSString stringWithUTF8String:"Hello World"];
s = [NSString string];                        // @""
s = [NSString stringWithString:other];
s = [NSString mulleStringWithUTF8Characters:"abcdef" length:3];  // non-null-terminated
s = [NSString stringWithCharacters:unichars length:len];          // UTF-32 input
s = [NSString stringWithFormat:@"val=%d", 42];
```

See `test/NSString/string.m`, `test/NSString/sprintf.m`, `test/NSString/classinit.m`.

## NSString iteration

Use the `MulleStringFor` / `MulleStringReverseFor` macros:

```bash
NSString   *s = [NSString stringWithUTF8String:"Hello"];
unichar    c;

MulleStringFor( s, c)
   mulle_printf( "%c", (char) c);
```

`unichar` is `mulle_utf32_t` (32-bit, not 16-bit). For reverse iteration use `MulleStringReverseFor`. For parser look-ahead use `_MulleStringEnumeratorUndoNext`.

See `test/NSString/for.m`, `test/NSString/for-reverse.m`, `test/NSString/for-undo.m`, `test/NSString/for-parser.m`.

## NSMutableString construction

Build incrementally, then convert to immutable:

```bash
m = [NSMutableString stringWithCapacity:32];
[m appendString:@"Hello"];
[m appendString:@" "];
[m appendFormat:@"%s %d", "World", 42];
s = [[m copy] autorelease];   // convert to immutable NSString
```

`setString:` with nil clears the string. `initWithStrings:count:` accepts an array of NSString pointers.

See `test/NSString/mutable.m`, `test/NSString/mutable-ops.m`, `src/String/NSMutableString.h:44`.

## NSData creation

```bash
d = [NSData data];                                          // zero-length
d = [NSData dataWithBytes:src length:len];                  // copies
d = [NSData dataWithBytesNoCopy:buf length:len];            // no copy (freeWhenDone:NO)
d = [NSData dataWithBytesNoCopy:buf length:len freeWhenDone:YES];
d = [NSData dataWithData:other];
d = [NSData mulleDataWithCData:some_mulle_data];            // from struct mulle_data
```

Use `mulleCData` to extract a `struct mulle_data` from an NSData.

See `test/NSData/data.m`, `test/NSData/bytes-and-length.m`, `test/NSData/data_with_data.m`.

## NSMutableData mutation

```bash
m = [NSMutableData dataWithCapacity:64];
[m appendBytes:src length:4];
[m appendData:otherData];
[m setLength:10];                          // zero-fills when growing
[m increaseLengthBy:2];                    // extends by N bytes (zero-filled)
[m replaceBytesInRange:range withBytes:repl];
[m replaceBytesInRange:range withBytes:repl length:replLen];
[m resetBytesInRange:range];               // zero-fills range
[m setData:newData];                       // replaces entire contents
```

`mutableBytes` returns a writable pointer. `mulleNonZeroedDataWithLength:` skips zero-fill.

See `test/NSData/mutable-ops.m`, `test/NSData/mutabledata.m`.

## NSNumber boxing

```bash
n = [NSNumber numberWithInt:42];
n = [NSNumber numberWithDouble:3.14];
n = [NSNumber numberWithBool:YES];
n = [NSNumber numberWithUnsignedLongLong:ULLONG_MAX];

int   iv = [n intValue];
double dv = [n doubleValue];
BOOL   bv = [n boolValue];
```

Comparison uses `_ns_superquad` (128-bit) internally. Use `compare:` or `isEqualToNumber:` for cross-type comparison.

See `test/NSNumber/values.m`, `test/NSNumber/compare-types.m`, `test/NSNumber/float-conversion.m`.

## Output / printf

```bash
MulleObjCPrintf(@"Hello %s %d\n", "World", 42);
MulleObjCFprintf(stderr, @"error: %s\n", msg);
```

`NSStringFromClass(cls)`, `NSClassFromString(s)`, `NSStringFromSelector(sel)`, `NSStringFromRange(range)`.

See `test/NSString/objcfunctions.m`, `src/String/NSStringObjCFunctions.h`.

## NSData range search

```bash
NSRange result = [haystack rangeOfData:needle
                               options:0
                                 range:NSMakeRange(0, [haystack length])];
// result.location == NSNotFound if not found
// options: NSDataSearchBackwards, NSDataSearchAnchored
```

See `test/NSData/range-search.m`.
