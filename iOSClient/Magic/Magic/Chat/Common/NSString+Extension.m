//
//  NSString.m
//  02-qq
//
//  Created by Teemo on 15/1/12.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//


#import "NSString+Extension.h"

@implementation NSString(Extension)
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
