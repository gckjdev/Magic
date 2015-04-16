//
//  MobClickUtils.m
//  Draw
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MobClickUtils.h"

@implementation MobClickUtils

+ (int)getIntValueByKey:(NSString*)key defaultValue:(int)defaultValue
{
    NSString* value = [MobClick getConfigParams:key];
    if (value == nil || [value length] == 0){
        return defaultValue;
    }
    
    return [value intValue];
}

+ (double)getDoubleValueByKey:(NSString*)key defaultValue:(double)defaultValue
{
    NSString* value = [MobClick getConfigParams:key];
    if (value == nil || [value length] == 0){
        return defaultValue;
    }
    return [value doubleValue];
}
+ (CGFloat)getFloatValueByKey:(NSString*)key defaultValue:(CGFloat)defaultValue
{
    NSString* value = [MobClick getConfigParams:key];
    if (value == nil || [value length] == 0){
        return defaultValue;
    }
    return [value floatValue];
}

+ (int)getBoolValueByKey:(NSString*)key defaultValue:(BOOL)defaultValue
{
    NSString* value = [MobClick getConfigParams:key];
    if (value == nil || [value length] == 0){
        return defaultValue;
    }
    
    return ([value intValue] != 0);
}


+ (NSString*)getStringValueByKey:(NSString*)key defaultValue:(NSString*)defaultValue
{
    NSString* value = [MobClick getConfigParams:key];
    if (value == nil || [value length] == 0){
        return defaultValue;
    }
    
    return value;    
}


@end
