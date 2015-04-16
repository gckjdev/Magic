//
//  ShareBarrageView.m
//  BarrageClient
//
//  Created by HuangCharlie on 1/15/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "ShareBarrageView.h"
#import "BarrageTextView.h"
#import "UIViewUtils.h"
#import "UIView+Dragging.h"

#import "BarrageConfigManager.h"
#import "BarrageActionManager.h"


@interface ShareBarrageView ()


@end

@implementation ShareBarrageView

+ (instancetype)shareBarrageWithFrame:(CGRect)frame
                          andImageURL:(NSURL*)url
                       barrageActions:(NSArray*)feedActions
{
    CGRect rect = CGRectMake(0, 0, BARRAGE_VIEW_WIDTH, BARRAGE_VIEW_HEIGHT);
    ShareBarrageView* share = [[ShareBarrageView alloc]initWithFrame:rect];
    
    // update image with url, then add barrages on it
    [share updateImageWithURL:url callback:^(NSError *error) {
        if(error!=nil) PPDebug(@"update bgimage with url success!");
        
        [share addBarrageWithActions:feedActions];
        [share addClickBarrageAction];
    }];
    
    // add line grid, press butt -> show/hidden
    [share initLineGridsView];
    
    //resize with holder view method
    [share setMyScale:frame];

    return share;
}



//change bview position for a shape//change bview position for a shape
-(void)updateQueue:(NSArray*)matrix
{
  
    NSArray *posPoints =  [BarrageActionManager barrageCommonAction:self.feedActions matrix:matrix maxWidthCount:8 maxHeightCount:8 posX:0 poxY:0];
    [self updateViewsPosWithPoints:posPoints];
    
}
-(void)addBarrageWithActions:(NSArray*)actions
{
    [super addBarrageWithActions:actions];
    [self.barrageViews enumerateObjectsUsingBlock:^(UIView* obj,NSUInteger idx, BOOL *stop){
        [obj setViewDraggable];
    }];
}

#pragma mark --- grid view relerant
-(void)initLineGridsView{
    UILineGridsView *lineGridsView = [[UILineGridsView alloc]initWithFrame:self.bounds];
    self.lineGridsView = lineGridsView;
    [lineGridsView setBackgroundColor:COLOR_LUCENCY];
    [lineGridsView setLineColor:COMMENTEDITVIEW_GRIDSVIEW_BG_COLOR];
    [lineGridsView setHidden:!APP_EDITVIEW_GRID];
    [self addSubview:lineGridsView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.lineGridsView.frame = self.bounds;
}
-(void)setLineGridsHidden:(BOOL)hidden
{
    [self.lineGridsView setHidden:hidden];
}
-(void)setMyScale:(CGRect)rect{
    UIView* holderView = [[UIView alloc] initWithFrame:rect];
    [holderView addSubview:self];
    CGFloat scale = [self scaleInView:holderView];
    [self setScale:scale];
    [self setMinScale:scale];
}

@end
