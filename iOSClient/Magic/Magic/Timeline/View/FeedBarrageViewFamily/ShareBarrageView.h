//
//  ShareBarrageView.h
//  BarrageClient
//
//  Created by HuangCharlie on 1/15/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Barrage.pb.h"
#import "CommonFeedBarrageView.h"
#import "UIViewUtils.h"
#import "FeedBarrageView.h"
#import "UILineGridsView.h"


@interface ShareBarrageView : CommonFeedBarrageView
{
    
}

@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic,strong) UILineGridsView   *lineGridsView;

+ (instancetype)shareBarrageWithFrame:(CGRect)frame
                          andImageURL:(NSURL*)url
                       barrageActions:(NSArray*)feedActions;

//change bview position for a shape
-(void)updateQueue:(NSArray*)matrix;

//show grid or hide grid
-(void)setLineGridsHidden:(BOOL)hidden;


@end
