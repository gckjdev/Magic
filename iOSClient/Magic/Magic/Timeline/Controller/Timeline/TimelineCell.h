//
//  TimelineCell.h
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineCellHeaderView.h"
#import "TimelineCellFooterView.h"
#import "TimelineCellMainView.h"
#import "FeedBarrageView.h"
#import "UIViewUtils.h"

@class Feed;

//#define kTimelineNewMessageHeaderHeight 25
#define kTimelineNewMessageHeaderHeight 60

#define kTimelineCellReuseIdentifier    @"kTimelineCellReuseIdentifier"
//#define kTimelineCellInternalOffset     5
#define kTimelineCellHeight             (TIMELINE_CELL_HEADER_HEIGHT + TIMELINE_CELL_FOOTER_HEIGHT + BARRAGE_HEIGHT(kScreenWidth) + TIMELINE_INTERVAL_VIEW_HEIGHT)

@interface TimelineCell : UITableViewCell

@property (nonatomic, weak) UIViewController* superController;

//update with data
- (void)updateCellData:(Feed*)feed;

//hide popups like cmpoptipview
- (void)hideAllPopUps;

@end
