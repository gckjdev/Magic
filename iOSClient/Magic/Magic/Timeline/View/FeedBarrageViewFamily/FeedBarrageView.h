//
//  FeedBarrageView.h
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Barrage.pb.h"
#import "CommonFeedBarrageView.h"

typedef void (^FeedBarrageViewBlock)(NSInteger currentPlayIndex);

@interface FeedBarrageView : CommonFeedBarrageView

@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic,strong) FeedBarrageViewBlock fbBlock;
@property (nonatomic,assign) NSUInteger currentPlayIndex;

+ (instancetype)barrageViewInView:(UIView*)superView
                            frame:(CGRect)frame;


// 设置弹幕数组，每一个是一个PBFeedAction对象
- (void)addBarrageWithActions:(NSArray*)actions;

// 播放、暂停、停止弹幕
- (void)play;
- (void)playFrom:(NSUInteger)index;
- (void)pause;
- (void)resume;
- (void)stop;
- (void)moveTo:(NSUInteger)index;

// 隐藏/显示所有弹幕
- (void)hideAllBarrages;
- (void)showAllBarrages;



@end
