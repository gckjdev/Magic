//
//  FriendDetailController.h
//  BarrageClient
//
//  Created by gckj on 15/1/29.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//
//  Modified by Shaowu Cai on 15/3/14

#import <UIKit/UIKit.h>
#import "BCUIViewController.h"

@class PBUser;

@interface FriendDetailController : BCUIViewController<UITableViewDataSource,UITableViewDelegate>

-(instancetype)initWithUser:(PBUser*)user;

@end
