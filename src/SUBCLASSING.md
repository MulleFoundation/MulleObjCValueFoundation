Subclassing NSSet and NSMutableSet
==================================

If you subclass either one of them, you are probably going to write your own
storage mechanism. Not because it makes sense, but because Foundation compatibility
forces you to do it.

In MulleObjCValueFoundation, subclassing NSSet inherits all the internal NSHashTable mechanisms,
which means, you must override all methods in NSSet, otherwise there will be problems.
To conserve memory, you also must subclass allocWithZone: which will otherwise allocate some
extra memory for a NSHashTable. You also need to create your own NSEnumerator subclass.

Subclassing NSSet to add instance variables, should be avoided, because you lose
compatibility with other Foundations. If that's no concern. Feel free, then you don't
need to override anything:

Methods you need to override:

+ (id) allocWithZone:(NSZone *) zone

- (id) initWithFirstObject:(id) value 
argumentList:(va_list) args
- (id) initWithObjects:(id *) objects
count:(NSUInteger) count
- (id) initWithSet:(NSSet *) set 
- (id) initWithSet:(NSSet *) set 
copyItems:(BOOL) flag
- (id) initWithArray:(NSArray *) array

- (id) member:(id) object
- (BOOL) containsObject:(id) object
- (NSEnumerator *) objectEnumerator
- (NSUInteger) count;
