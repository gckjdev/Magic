//
//  BadgeView.h
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeView : UIButton

+ (id)badgeViewWithNumber:(NSInteger)number;

@property(nonatomic, assign) NSInteger maxNumber; //default is 99
@property(nonatomic, assign) NSInteger number; //default is 99
- (void)setBGImage:(UIImage *)image;

@end
