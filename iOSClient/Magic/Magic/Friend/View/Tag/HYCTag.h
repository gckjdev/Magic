//
//  HYCTag.h
//  BarrageClient
//
//  Created by HuangCharlie on 1/22/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ColorInfo.h"

#define TAG_TEXT_FONT              ([UIFont systemFontOfSize:13])


#define TAG_COLOR_GREEN      OPAQUE_COLOR(0x7b, 0xc5, 0x67)
#define TAG_COLOR_YELLOW     OPAQUE_COLOR(0xec, 0xbc, 0x25)
#define TAG_COLOR_PURPLE     OPAQUE_COLOR(0xc7, 0x92, 0xe0)
#define TAG_COLOR_LBLUE      OPAQUE_COLOR(0x6b, 0xb5, 0xe5)
#define TAG_COLOR_RED        OPAQUE_COLOR(0xed, 0x6e, 0x74)
#define TAG_COLOR_DBLUE      OPAQUE_COLOR(0x79, 0x97, 0xf2)
#define TAG_COLOR_ORANGE     OPAQUE_COLOR(0xf6, 0x8a, 0x54)


@interface HYCTag : NSObject

//for style of tag text
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIFont *font;

//for style of tag button
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic) CGFloat inset;

//for action of tag button
@property (nonatomic, strong) id target;
@property (nonatomic) SEL action;

- (instancetype)initWithText:(NSString *)text;

+ (instancetype)tagWithText:(NSString *)text;


@end