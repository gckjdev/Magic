//
//  UILineLabel.h
//  BarrageClient
//
//  Created by Teemo on 15/2/9.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum UILineLabelType :NSUInteger{
    
    UILINELABELTYPE_NONE,//没有画线
    UILINELABELTYPE_UP ,// 上边画线
    UILINELABELTYPE_MIDDLE,//中间画线
    UILINELABELTYPE_DOWN,//下边画线
    
} UILineLabelType;
/**
 *  带下划线的Lable
 */
@interface UILineLabel : UILabel

@property (nonatomic,strong) UIView*   line;

@property (assign, nonatomic) UILineLabelType lineType;
@property (strong, nonatomic) UIColor *lineColor;
@property (nonatomic, assign) CGFloat  lineHeight;
@property (nonatomic, assign) CGFloat  padding;

//使用完init之后,如果使用autolayout，必须设定高度
+(UILineLabel*)initWithText:(NSString*)text
                       Font:(UIFont*)font
                      Color:(UIColor*)color
                       Type:(UILineLabelType)tpye;
//-(void)setPosition:(CGPoint)position;

-(void)setLineType:(UILineLabelType)lineType;


@end
