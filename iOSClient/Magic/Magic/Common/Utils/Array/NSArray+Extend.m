//
//  NSArray+Extend.m
//  Draw
//
//  Created by 王 小涛 on 13-7-1.
//
//

#import "NSArray+Extend.h"

@implementation NSArray (Extend)

- (NSArray *)subarrayWithRangeSafe:(NSRange)range{
    
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    
    if (location >= [self count] || length <= 0) {
        return nil;
    }
    
    NSUInteger safeLength = MIN(length, [self count] - location);
    
    NSRange safeRange = NSMakeRange(location, safeLength);
    NSArray *arr = [self subarrayWithRange:safeRange];
    
    return arr;
}

@end
