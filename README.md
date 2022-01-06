# MulleObjCValueFoundation

#### 💶 Value classes NSNumber, NSString, NSDate, NSData

These classes build on [MulleObjC](//github.com/mulle-objc/MulleObjC) and
[mulle-core](//github.com/mulle-objc/mulle-core) to provide the usual
value classes expected in a Foundation library.

> A good distinction if a class is a value or a container is if it has a
> -count or a -length method. If it counts members with -length (number of
> bytes) it's a value.

There is no I/O in these classes. That is added by MulleObjcOSFoundation
and later.


#### Classes

Class             | Description
------------------|-----------------
`NSData`          |
`NSDate`          |
`NSMutableData`   |
`NSMutableString` |
`NSNull`          |
`NSNumber`        |
`NSString`        |
`NSValue`         |


#### Protocols

Protocol          | Description
------------------|-----------------
`NSDateFactory`   |


### You are here

![Overview](overview.dot.svg)



## Install

See [foundation-developer](//github.com//foundation-developer) for
installation instructions.


## Author

[Nat!](//www.mulle-kybernetik.com/weblog) for
[Mulle kybernetiK](//www.mulle-kybernetik.com) and
[Codeon GmbH](//www.codeon.de)
