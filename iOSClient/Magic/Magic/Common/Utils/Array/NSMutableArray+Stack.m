//
//  NSMutableArray+Stack.m
//  Draw
//
//  Created by Kira on 12-10-31.
//
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

- (void) push: (id)item {
    [self addObject:item];
}

- (id) pop {
    id item = nil;
    if ([self count] != 0) {
        item = [self lastObject];
        [self removeLastObject];
    }
    return item;
}

- (id) peek {
    id item = nil;
    if ([self count] != 0) {
        item = [self lastObject];
    }
    return item;
}

@end
