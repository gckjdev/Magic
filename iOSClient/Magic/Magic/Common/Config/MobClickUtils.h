//
//  MobClickUtils.h
//  Draw
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobClick.h"

@interface MobClickUtils : NSObject

+ (int)getIntValueByKey:(NSString*)key defaultValue:(int)defaultValue;
+ (double)getDoubleValueByKey:(NSString*)key defaultValue:(double)defaultValue;
+ (CGFloat)getFloatValueByKey:(NSString*)key defaultValue:(CGFloat)defaultValue;
+ (NSString*)getStringValueByKey:(NSString*)key defaultValue:(NSString*)defaultValue;
+ (int)getBoolValueByKey:(NSString*)key defaultValue:(BOOL)defaultValue;

@end

#define UMENG_INTVALUE(key, intValue) [MobClickUtils getIntValueByKey:key defaultValue:intValue]
#define UMENG_BOOLVALUE(key, boolValue) [MobClickUtils getBoolValueByKey:key defaultValue:boolValue]
#define UMENG_STRVALUE(key, strValue)[MobClickUtils getStringValueByKey:key defaultValue:strValue]
