//
//  NSArrayExt.h
//  Draw
//
//  Created by gamy on 13-8-7.
//
//

#import <Foundation/Foundation.h>

@interface NSArray(Ext)

- (id)firstObject;
- (void)reversEnumWithHandler:(void (^)(id object))handler;
- (NSArray *)subarrayWithRangeSafe:(NSRange)range;
- (NSArray *)reversedArray;

@end


