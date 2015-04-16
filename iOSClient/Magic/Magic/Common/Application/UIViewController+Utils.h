//
//  UIViewController+Utils.h
//  BarrageClient
//
//  Created by pipi on 15/1/24.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CENTER_TAB_BAR_BUTTON_TAG       (2015020488)

@interface UIViewController (Utils)


- (void)setDefaultBackButton:(SEL)backAction;

- (void)setDefaultLeftButton:(SEL)leftAction;

-(void)setLeftButton:(NSString*)title backAction:(SEL)backAction;



//左上角加图片按钮和事件
- (void)addLeftButton:(NSString*)imageName
                target:(id)target
                action:(SEL)action;

- (void)addRightButton:(NSString*)imageName
                action:(SEL)action;

//右上角加图片按钮和事件
- (void)addRightButton:(NSString*)imageName
                target:(id)target
                action:(SEL)action;
//右上角加文字按钮和事件
- (void)addRightButtonWithTitle:(NSString*)title
                target:(id)target
                action:(SEL)action;

- (void)hideTabBar;

- (void)showTabBar;

-(void)setRedNavigationBar;

-(void)setBlackNavigationBar;

@end
