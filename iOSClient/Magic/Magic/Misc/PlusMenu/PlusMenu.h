//
//  PlusMenu.h
//  BarrageClient
//
//  Created by pipi on 15/1/30.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//
//  added by Shaowu Cai on 15/3/26

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CMPopTipView.h"
#import "PlusMenuTableViewController.h"

@interface PlusMenu : NSObject

+ (CMPopTipView*)homePopTipView;
+ (PlusMenuTableViewController*)homePopController;

+ (CMPopTipView*)friendPopTipView;
+ (PlusMenuTableViewController*)friendPopController;

@end

@interface UIViewController (AddPlusMenu)

- (void)addPlusMenuAtHomeNavigationBar;
- (void)addPlusMenuAtFriendNavigationBar;

- (void)hiddenPlusMenuAtHomeNavigationBar;
- (void)hiddenPlusMenuAtFriendNavigationBar;

@end