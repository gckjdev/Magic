//
//  NSArrayExt.m
//  Draw
//
//  Created by gamy on 13-8-7.
//
//

#import "NSArray+Ext.h"

@implementation NSArray(Ext)

- (id)firstObject;
{
    return ([self count] == 0) ? nil : [self objectAtIndex:0];
}

- (void)reversEnumWithHandler:(void (^)(id object))handler
{
    if(handler != NULL){
        for (NSInteger i = [self count] - 1; i >= 0; i --) {
            id object = [self objectAtIndex:i];
            handler(object);
        }
    }
//    handler = NULL;
}

- (NSArray *)subarrayWithRangeSafe:(NSRange)range{
    
    NSUInteger start = range.location;
    NSUInteger length = range.length;
    
    NSUInteger end = start + length - 1;
    
    
    if (start >= [self count]) {
        return nil;
    }
    
    if (end >= [self count]) {
        end = [self count] - 1;
    }
    
    NSUInteger actualLength = end - start + 1;
    
    NSRange safeRange = NSMakeRange(start, actualLength);
    return [self subarrayWithRange:safeRange];
}

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end

@implementation NSMutableArray (Reverse)

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end
