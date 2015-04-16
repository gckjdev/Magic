//
//  AppDelegate.h
//  BarrageClient
//
//  Created by pipi on 14/11/27.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSLayoutConstraint+MASDebugAdditions.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;

- (UINavigationController*)currentNavigationController;

- (UIViewController*)currentViewController;

+ (AppDelegate*)sharedInstance;
- (void)showNormalHome;
- (void)showDemoController;
-(void)test;
- (void)customizeBlackNavigationBar;
- (void)customizeNavigationBar;

@end

