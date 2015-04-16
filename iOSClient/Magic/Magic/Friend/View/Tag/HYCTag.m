//
//  HYCTag.m
//  BarrageClient
//
//  Created by HuangCharlie on 1/22/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "HYCTag.h"



@implementation HYCTag

- (instancetype)initWithText:(NSString *)text
{
    self = [super init];
    if (self)
    {
        self.text = text;
        self.font = TAG_TEXT_FONT;
        self.textColor = [UIColor whiteColor];
        self.bgColor = [UIColor blackColor];
    }
    
    return self;
}

+ (instancetype)tagWithText:(NSString *)text
{
    return [[self alloc] initWithText:text];
}


@end