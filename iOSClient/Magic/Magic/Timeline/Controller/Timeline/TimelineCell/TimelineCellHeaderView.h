//
//  TimelineCellHeaderView.h
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewUtils.h"

#define TIMELINE_CELL_HEADER_HEIGHT   44
#define TIMELINE_CELL_FOOTER_HEIGHT   35
#define TIMELINE_CELL_SUBTITLE_VIEW_HEIGHT   35
#define TIMELINE_INTERVAL_VIEW_HEIGHT   15  //  间隔高度

#define TIMELINE_CELL_HEADER_AVATAR_HEIGHT   (28+4)   //  1 is border width
#define TIMELINE_CELL_HEADER_AVATAR_WIDTH    (28+4)   //  1 is border width

#define TIMELINE_BUTTON_WIDTH         45
#define TIMELINE_BUTTON_LEFT_SPACE    10
#define TIMELINE_BUTTON_RIGHT_SPACE   5


#define TIMELINE_TIME_LABEL_LEFT_SPACE    15    //  时间和subtitleView距离左边的间隔

@class Feed;

@interface TimelineCellHeaderView : UIView

@property (nonatomic, strong) UIButton* displayUserButton;

- (void)updateData:(Feed*)feed;
- (void)setClickDisplayUserButtonBlock:(ButtonClickActionBlock)block;

@end
