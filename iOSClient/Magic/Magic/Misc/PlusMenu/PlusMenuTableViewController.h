//
//  PlusMenuTableViewController.h
//  BarrageClient
//
//  Created by gckj on 15/2/3.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//
//  added by Shaowu Cai

#import <UIKit/UIKit.h>

@class CMPopTipView;

@interface PlusMenuTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

+ (id)menuForHome;
+ (id)menuForFriend;

@property (nonatomic,assign)CMPopTipView* popTipView;


@end
