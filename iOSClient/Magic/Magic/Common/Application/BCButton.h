//
//  BCButton.h
//  BarrageClient
//
//  Created by Teemo on 15/3/31.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCButton : UIButton

+(instancetype)buttonWithImage:(UIImage*)image
                         title:(NSString*)title
                  imagePercent:(CGFloat)imagePercent;

//图片占按钮的高度的百分比
@property (nonatomic, assign) CGFloat imagePercent;
@end
