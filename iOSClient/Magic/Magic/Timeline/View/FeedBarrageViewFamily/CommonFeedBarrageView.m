//
//  CommonFeedBarrageView.m
//  BarrageClient
//
//  Created by HuangCharlie on 3/30/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "CommonFeedBarrageView.h"
#import "BarrageTextView.h"
#import "UIImageView+WebCache.h"
#import "PPDebug.h"

@interface CommonFeedBarrageView ()
{
    
}

@end

@implementation CommonFeedBarrageView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setClipsToBounds:YES];
    [self setBounds:frame];
    [self setUserInteractionEnabled:YES];
    
    return self;
}

-(void)addBgImage:(UIImage*)image
{
    [self setImage:image];
}

-(void)addBarrageWithActions:(NSArray*)actions
{
    [self removeAllBarrageViews];
    
    self.feedActions = actions;
    
    __block NSMutableArray* bArray = [NSMutableArray array];
    [self.feedActions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PBFeedAction* action = (PBFeedAction*)obj;
        BarrageTextView* bView;
        bView =[BarrageTextView initWithFeedAction:action mode:BARRAGE_SHOWMODE];
        [bView setTag:VIEW_TAG_BARRAGE_BEGIN+idx];
        [self addSubview:bView];
        [bArray addObject:bView];
        
        if(stop){
            self.barrageViews = bArray;
        }
    }];
    
}
-(void)updateViewsPosWithPoints:(NSArray*)points
{
    [self.barrageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BarrageTextView* bView = (BarrageTextView*)obj;
        CGPoint point = [points[idx] CGPointValue];
        CGRect frame = bView.frame;
        frame.origin = point;
        bView.frame = frame;
    }];
}
-(void)showAllBarrages
{
    [self.barrageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BarrageTextView* bView = (BarrageTextView*)obj;
        [bView setHidden:NO];
    }];
}
-(void)hideAllBarrages
{
    [self.barrageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BarrageTextView* bView = (BarrageTextView*)obj;
        [bView setHidden:YES];
    }];
}
-(void)removeAllBarrageViews
{
    [self.barrageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BarrageTextView* bView = (BarrageTextView*)obj;
        [bView removeFromSuperview];
    }];
}
-(void)addClickBarrageAction
{
    [self.barrageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BarrageTextView* bView = (BarrageTextView*)obj;
        __weak typeof(BarrageTextView*) weakSelf = bView;
        weakSelf.longPressBlock = ^(BarrageTextView* barrageTextView){
            [barrageTextView removeFromSuperview];
        };
    }];
}


-(void)updateImageWithURL:(NSURL*)url
                 callback:(LoadImageCallBackBlock)callback
{
    //set image with an url
    [self sd_setImageWithURL:url
            placeholderImage:nil
                     options:SDWebImageRetryFailed
                   completed:
     ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error == nil) {
             [self setImage:image];
         }
         else
         {
             [self setImage:nil];
         }
         EXECUTE_BLOCK(callback,error);
         
     }];
}

@end
