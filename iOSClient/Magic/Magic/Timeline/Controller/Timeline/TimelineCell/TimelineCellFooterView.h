//
//  TimelineCellFooterView.h
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewUtils.h"

#import "TimelineCellHeaderView.h"

@class Feed;

@interface TimelineCellFooterView : UIView

- (void)updateData:(Feed*)feed;
- (void)setClickShareButtonBlock:(ButtonClickActionBlock)block;
- (void)setClickPlayButtonBlock:(ButtonClickActionBlock)block;

@end
