//
//  UserTimelineFeedController.h
//  BarrageClient
//
//  Created by pipi on 14/12/11.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "BCUIViewController.h"
#import "TimelineTableView.h"
#import "ViewInfo.h"

// 根据本地数据，刷新可见弹幕流
#define NOTIFICATION_TIMELINE_RELOAD_VISIABLE_ROWS     @"NOTIFICATION_TIMELINE_RELOAD_VISIABLE_ROWS"

// 根据本地数据，刷新整个弹幕流
#define NOTIFICATION_TIMELINE_RELOAD_ALL_ROWS          @"NOTIFICATION_TIMELINE_RELOAD_ALL_ROWS"

// 从网络重新加载后，刷新整个弹幕流
#define NOTIFICATION_TIMELINE_RELOAD_FROM_NETWORK      @"NOTIFICATION_TIMELINE_RELOAD_FROM_NETWORK"


#import <UIKit/UIKit.h>

@interface UserTimelineFeedController : UIViewController

@property (nonatomic,strong) TimelineTableView *tableView;

@end
