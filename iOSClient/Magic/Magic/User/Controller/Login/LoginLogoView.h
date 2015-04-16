//
//  LoginLogoView.h
//  BarrageClient
//
//  Created by Teemo on 15/3/31.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewUtils.h"
#import "Feed.h"

#define LOGOVIEW_HIEGHT (0.731*kScreenHeight)

@interface LoginLogoView : UIView
+(instancetype)viewInitWithFeed:(Feed*)feed
                          frame:(CGRect)frame;
-(void)updateViewWithFeed:(Feed*)feed;
@end
