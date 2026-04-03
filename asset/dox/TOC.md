# MulleObjCValueFoundation Library Documentation for AI
<!-- Keywords: values, boxing -->

## 1. Introduction & Purpose

MulleObjCValueFoundation provides Objective-C wrapper classes for fundamental C value types, including NSNumber (numeric values), NSString (text), NSData (binary data), NSNull (nil representation), and NSValue (generic value boxing). Enables treating primitive types as first-class objects in Objective-C collections and APIs.

## 2. Key Concepts & Design Philosophy

- **Value Boxing**: Wrap primitive types (int, float, char, etc.) as objects
- **Immutability**: All value classes are immutable after creation
- **Class Clusters**: Using class cluster pattern for efficient subclass variants
- **Collection Friendly**: Enable storage in NSArray, NSDictionary
- **Type Safety**: Preserve original type information through NSValue

## 3. Core API & Data Structures

### NSNumber - Numeric Values

#### Creation & Convenience Methods

- `+ numberWithInt:(int)value` → `instancetype`
- `+ numberWithUnsignedInt:(unsigned int)value` → `instancetype`
- `+ numberWithLong:(long)value` → `instancetype`
- `+ numberWithUnsignedLong:(unsigned long)value` → `instancetype`
- `+ numberWithFloat:(float)value` → `instancetype`
- `+ numberWithDouble:(double)value` → `instancetype`
- `+ numberWithBool:(BOOL)value` → `instancetype`
- `+ numberWithChar:(char)value` → `instancetype`

#### Value Accessors

- `- intValue` → `int`: Extract as int
- `- unsignedIntValue` → `unsigned int`
- `- longValue` → `long`
- `- floatValue` → `float`
- `- doubleValue` → `double`
- `- boolValue` → `BOOL`: YES/NO
- `- charValue` → `char`
- `- stringValue` → `NSString *`: String representation

#### Comparison

- `- compare:(NSNumber *)other` → `NSComparisonResult`
- `- isEqualToNumber:(NSNumber *)other` → `BOOL`

### NSString - Text Values

#### Creation

- `+ stringWithCString:(const char *)cString` → `instancetype`
- `+ stringWithFormat:(NSString *)format, ...` → `instancetype`
- `- initWithCString:(const char *)cString` → `instancetype`

#### Accessors

- `- cString` → `const char *`: C string pointer
- `- length` → `NSUInteger`: Character count
- `- characterAtIndex:(NSUInteger)index` → `unichar`

#### Substrings & Manipulation

- `- substringFromIndex:(NSUInteger)from` → `NSString *`
- `- substringToIndex:(NSUInteger)to` → `NSString *`
- `- substringWithRange:(NSRange)range` → `NSString *`
- `- stringByAppendingString:(NSString *)str` → `NSString *`

#### Search & Replace

- `- rangeOfString:(NSString *)substring` → `NSRange`
- `- stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement` → `NSString *`

### NSData - Binary Data

#### Creation

- `+ dataWithBytes:(const void *)bytes length:(NSUInteger)length` → `instancetype`
- `- initWithBytes:(const void *)bytes length:(NSUInteger)length` → `instancetype`

#### Accessors

- `- bytes` → `const void *`: Pointer to data
- `- length` → `NSUInteger`: Size in bytes

#### Manipulation

- `- subdataWithRange:(NSRange)range` → `NSData *`
- `- dataByAppendingData:(NSData *)data` → `NSData *`

### NSNull - Null Object

#### Singleton

- `+ null` → `NSNull *`: Canonical NSNull instance
- Represents nil in collections where nil cannot be stored

### NSValue - Generic Value Boxing

#### Creation

- `+ valueWithPointer:(const void *)pointer` → `instancetype`
- `+ valueWithRange:(NSRange)range` → `instancetype`
- `+ valueWithBytes:(const void *)value objCType:(const char *)type` → `instancetype`

#### Accessors

- `- pointerValue` → `void *`
- `- rangeValue` → `NSRange`
- `- getValue:(void *)buffer` → `void`: Extract raw bytes
- `- objCType` → `const char *`: Type encoding

## 4. Performance Characteristics

- **Creation**: O(1); small allocation
- **Value Access**: O(1); direct field access
- **String Operations**: O(n) for search/replace operations
- **Data Copy**: O(n) copying data on creation
- **Memory**: Immutable; can be safely cached and shared
- **Thread-Safety**: All value types are thread-safe (immutable)

## 5. AI Usage Recommendations & Patterns

### Best Practices

- **Use Appropriate Type**: Choose NSNumber variant matching actual type
- **Value Extraction**: Use accessor methods matching creation type
- **String Constants**: Use string literals directly when possible
- **NSNull for Nil**: Use NSNull singleton in collections requiring non-nil values
- **Value Boxing**: Use NSValue for complex type storage

### Common Pitfalls

- **Type Mismatch**: Extracting as different type (e.g., floatValue from intValue NSNumber) may lose precision
- **Nil Assumption**: NSNull != nil; need explicit checks
- **String Mutability**: NSString is immutable; create new strings for modifications
- **Data Modification**: Cannot modify NSData contents; create new NSData if needed
- **Performance**: Don't box/unbox repeatedly in tight loops

## 6. Integration Examples

### Example 1: NSNumber Operations

```objc
#import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>

int main() {
    NSNumber *num1 = [NSNumber numberWithInt:42];
    NSNumber *num2 = [NSNumber numberWithFloat:3.14];
    
    NSLog(@"num1 as int: %d", [num1 intValue]);
    NSLog(@"num1 as string: %@", [num1 stringValue]);
    
    NSComparisonResult result = [num1 compare:num2];
    NSLog(@"42 > 3.14: %s", result == NSOrderedDescending ? "yes" : "no");
    
    return 0;
}
```

### Example 2: NSString Operations

```objc
#import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>

int main() {
    NSString *str = @"Hello, World!";
    NSLog(@"Length: %lu", [str length]);
    NSLog(@"Char at 0: %c", [str characterAtIndex:0]);
    
    NSString *substring = [str substringFromIndex:7];
    NSLog(@"Substring: %@", substring);
    
    NSRange range = [str rangeOfString:@"World"];
    NSLog(@"Found at: %lu", range.location);
    
    return 0;
}
```

### Example 3: NSData Creation

```objc
#import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>

int main() {
    unsigned char bytes[] = { 0x48, 0x65, 0x6C, 0x6C, 0x6F };
    NSData *data = [NSData dataWithBytes:bytes length:5];
    
    NSLog(@"Data length: %lu", [data length]);
    const unsigned char *ptr = [data bytes];
    printf("First byte: 0x%02X\n", ptr[0]);
    
    return 0;
}
```

### Example 4: NSNull in Collection

```objc
#import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>

int main() {
    NSArray *array = [NSArray arrayWithObjects:
        @"string",
        [NSNumber numberWithInt:42],
        [NSNull null],
        nil];
    
    NSLog(@"Array count: %lu", [array count]);
    
    id third = [array objectAtIndex:2];
    if ([third isEqual:[NSNull null]]) {
        NSLog(@"Third element is null");
    }
    
    return 0;
}
```

### Example 5: NSValue for Complex Types

```objc
#import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>

int main() {
    NSRange range = NSMakeRange(10, 20);
    NSValue *value = [NSValue valueWithRange:range];
    
    NSRange retrieved = [value rangeValue];
    NSLog(@"Range: location=%lu, length=%lu", 
          retrieved.location, retrieved.length);
    
    return 0;
}
```

### Example 6: String Formatting

```objc
#import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>

int main() {
    NSString *formatted = 
        [NSString stringWithFormat:@"Number: %d, Float: %.2f", 42, 3.14159];
    NSLog(@"%@", formatted);
    
    return 0;
}
```

## 7. Dependencies

- MulleObjC
- MulleFoundationBase
