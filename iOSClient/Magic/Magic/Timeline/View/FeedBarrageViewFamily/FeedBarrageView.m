//
//  FeedBarrageView.m
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "FeedBarrageView.h"
#import "POP.h"
#import "BarrageTextView.h"
#import "PPDebug.h"
#import "UIViewUtils.h"
#import "UserManager.h"
#import "HYCEmitterLayer.h"
#import "FeedService.h"
#import "UserTimelineFeedController.h"
#import "CHAudioPlayer.h"

#define TIME_INTERVAL 1.0

@interface FeedBarrageView()
{

}


@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic,assign)  BOOL isPlaying;

@property (strong) HYCEmitterLayer *ringEmitter;

@end

@implementation FeedBarrageView
{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//Modified by Charlie 2014 12 17
//adding popping barrage using Facebook Pop

+ (instancetype)barrageViewInView:(UIView*)superView frame:(CGRect)frame
{
    UIView* holderView = [[UIView alloc] initWithFrame:frame];
    
    // add barrage view into holder view, 800*800 and then resize by holder
    CGRect rect = CGRectMake(0, 0, BARRAGE_VIEW_WIDTH, BARRAGE_VIEW_HEIGHT);
    FeedBarrageView* barrageView = [[FeedBarrageView alloc] initWithFrame:rect];
    [barrageView setBounds:rect];
    [holderView addSubview:barrageView];
    
    CGFloat scale = [barrageView scaleInView:holderView];
    [barrageView setScale:scale];
    [barrageView setMinScale:scale];
//    [barrageView setLongPressAction];
    [superView addSubview:holderView];
    
    return barrageView;
}

-(void)addClickBarrageAction
{
   
    for(int i = 0; i < [self.barrageViews count]; i++)
    {
        BarrageTextView* bView = self.barrageViews[i];
        __weak typeof(BarrageTextView*) weakSelf = bView;
        weakSelf.longPressBlock = ^(BarrageTextView* barrageTextView){
            
        if ([self isCurrentUser:barrageTextView.textBuilder]) {
            NSString *aciontId = barrageTextView.textBuilder.actionId;
            NSString *feedId = barrageTextView.textBuilder.feedId;
            DeleteFeedActionCallBackBlock block = ^(NSString *feedActionId, NSError *error) {
                if (error==nil) {
                    POST_SUCCESS_MSG(@"删除评论成功");
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIMELINE_RELOAD_VISIABLE_ROWS
                                                                        object:nil];
                }};

            [[FeedService sharedInstance]deleteFeedAction:aciontId
                                                   feedId:feedId
                                                 callback:block];
        }
        else{
            POST_SUCCESS_MSG(@"只能删除自己的评论");
        }
        
    };
    }
}

// 设置弹幕数组，每一个是一个PBFeedAction对象
- (void)addBarrageWithActions:(NSArray*)actions
{
    [super addBarrageWithActions:actions];
    
    [self addClickBarrageAction];
}


-(BOOL) isCurrentUser:(PBFeedActionBuilder*)textBuilder
{
     NSString* myUserId = [[UserManager sharedInstance] userId];

    if(![textBuilder.user.userId isEqualToString:myUserId])
    {
        return NO;
    }
    
    return YES;
}

- (PBFeedAction*)getFeedAction:(NSUInteger)index
{
    if (index < [self.feedActions count]){
        PBFeedAction* feedAction = [self.feedActions objectAtIndex:index];
        return feedAction;
    }
    
    return nil;
}

- (CGPoint)getStartPosition:(NSInteger)index
                   WithType:(NSInteger)type
{
    /*
     当pop类型不为decay的时候，bView的起始位置位于superView的最底部
     当pop类型为decay的时候，由于物理上的计算需要，bView的起始位置位于某个更底部的position
     其计算方式如下
     */
    PBFeedAction* feedAction = [self getFeedAction:index];
    if (feedAction == nil){
        return CGPointZero;
    }
    
    BarrageTextView* bView = (BarrageTextView*)[self viewWithTag:VIEW_TAG_BARRAGE_BEGIN+index];

    CGFloat viewWidth = bView.frame.size.width;
    //从topLeft点到center点的offset，若以后成为动态计算，则需要输入整个弹幕的长度，
    //然后offsetX为弹幕宽度的一半，offsetY为弹幕高度的一半
    CGFloat offsetX = viewWidth/2;
    CGFloat offsetY = BARRAGE_VIEW_HEIGHT + BARRAGE_TEXT_VIEW_DEFAULT_HEIGHT/2;
    
    //从底部弹出，x y 为出发点的坐标，估x做一个topleft到center的偏移，y则为固定的view底部
    CGFloat beginningCenterX = feedAction.posX + offsetX;
    CGFloat beginningCenterY = offsetY;
    
    if(type == PBBarrageStylePopDecay)
        beginningCenterY +=feedAction.posY;
    
    CGPoint p = CGPointMake(beginningCenterX, beginningCenterY);
    return p;
}


- (CGPoint)getEndPosition:(NSInteger)index
{
    PBFeedAction* feedAction = [self getFeedAction:index]; // [self.barrageList objectAtIndex:index];
    if (feedAction == nil){
        return CGPointZero;
    }
    
    //从topLeft点到center点的offset，若以后成为动态计算，则需要输入整个弹幕的长度，
    //然后offsetX为弹幕宽度的一半，offsetY为弹幕高度的一半
    
    BarrageTextView* bView = (BarrageTextView*)[self viewWithTag:VIEW_TAG_BARRAGE_BEGIN+index];
    CGFloat viewWidth = bView.frame.size.width;
    CGFloat viewHeight = bView.frame.size.height;
    CGFloat offsetX = viewWidth/2;
    CGFloat offsetY = viewHeight/2;
    
    //从底部弹出，x,y为target position
    CGFloat endingCenterX = feedAction.posX + offsetX;
    CGFloat endingCenterY = feedAction.posY + offsetY;
    
    CGPoint p = CGPointMake(endingCenterX, endingCenterY);
    return p;
}


#pragma mark ---- play, pause, stop, resume, hide all, display all, so on
// 播放、暂停、停止弹幕
- (void)playFrom:(NSUInteger)index
{
    //if barrages are playing, just let it play along
    if(self.isPlaying == YES)
        return;
    
    //add by neng fix bug
    if (self.timer != nil) {
        [self stop];
    }
    if ([self.feedActions count] == 0){
        return;
    }
    
    //barrage counter
    self.currentPlayIndex = index;
    
    //Add a timer for popping
    NSTimeInterval interval = TIME_INTERVAL;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                             target:self
                                           selector:@selector(onTimerFired:)
                                           userInfo:nil
                                            repeats:YES];
    
    self.isPlaying = YES;
    [self.timer fire];
}

- (void)play
{
    [self stop];
    [self playFrom:0];
}
- (void)pause
{
    self.isPlaying = NO;
    [_timer setFireDate:[NSDate distantFuture]];
}
- (void)resume
{
    self.isPlaying = YES;
   [_timer setFireDate:[NSDate distantPast]];
}
- (void)stop
{
    self.isPlaying = NO;
    [self.timer invalidate];
    self.timer = nil;
    self.currentPlayIndex = 0;
    
    for(BarrageTextView* bView in self.barrageViews){
        [bView pop_removeAllAnimations];
    }
    
}
- (void)moveTo:(NSUInteger)index
{
    [self hideAllBarrages];
    
    //show part of them, since they are shown before
    for(int i = 0 ; i < index; i++)
    {
        [self viewWithTag:VIEW_TAG_BARRAGE_BEGIN+i].center = [self getEndPosition:i];
    }
    
    [self playFrom:index];
}

// 隐藏/显示所有弹幕
- (void)hideAllBarrages
{
    //renew position list
    NSInteger type = [[UserManager sharedInstance]barrageStyle];
    
    for(UIView *v in self.subviews)
    {
        if([v isKindOfClass:[BarrageTextView class]])
        {
            BarrageTextView *view = (BarrageTextView*)v;
            NSUInteger index = view.tag - VIEW_TAG_BARRAGE_BEGIN;
            [view pop_removeAllAnimations];
            view.center = [self getStartPosition:index
                                        WithType:type];
        }
    }

    [self stop];
}

- (void)showAllBarrages
{
    for(UIView *v in self.subviews)
    {
        if([v isKindOfClass:[BarrageTextView class]])
        {
            BarrageTextView *view = (BarrageTextView*)v;
            NSInteger index = view.tag - VIEW_TAG_BARRAGE_BEGIN;
            view.center = [self getEndPosition:(int)index];
        }
    }

    [self stop];
}

#pragma mark ---- timer response
- (void)onTimerFired:(id)sender
{
    if(self.currentPlayIndex >= [self.feedActions count])
    {
        self.isPlaying = NO;
        [sender setFireDate:[NSDate distantFuture]];
        self.currentPlayIndex = 0;
        EXECUTE_BLOCK(self.fbBlock,self.currentPlayIndex);
        
        PPDebug(@"Time's out!");
    }
    else
    {
        PBBarrageSpeed speed = [[UserManager sharedInstance]barrageSpeed];
        switch ([[UserManager sharedInstance] barrageStyle]) {
            case PBBarrageStylePopDecay:
            {
                //滑动摩擦
                [self popDecayBarrageTextView:self.currentPlayIndex];
            }
                break;
            case PBBarrageStylePopSpring:
            {
                //来回弹力
                [self popSpringBarrageTextView:self.currentPlayIndex
                                     withSpeed:speed];
            }
                break;
            case PBBarrageStylePopLinear:
            {
                //线性匀速滑动
                [self popNormalBarrageTextView:self.currentPlayIndex
                                      WithType:PBBarrageStylePopLinear
                                      andSpeed:speed];
            }
                break;
            case PBBarrageStylePopEaseIn:
            {
                //加速滑动
                [self popNormalBarrageTextView:self.currentPlayIndex
                                      WithType:PBBarrageStylePopEaseIn
                                      andSpeed:speed];
            }
                break;
            case PBBarrageStylePopEaseOut:
            {
                //减速滑动
                [self popNormalBarrageTextView:self.currentPlayIndex
                                      WithType:PBBarrageStylePopEaseOut
                                      andSpeed:speed];

            }
                break;
            case PBBarrageStylePopEaseInout:
            {
                //加速后减速滑动
                [self popNormalBarrageTextView:self.currentPlayIndex
                                      WithType:PBBarrageStylePopEaseInout
                                      andSpeed:speed];
            }
                break;
            default:
            {
                //默认设置为滑动摩擦
                [self popDecayBarrageTextView:self.currentPlayIndex];
            }
                break;
        }
        
        //audio of system sound
//        [[CHAudioPlayer sharedInstance]play];
        
        //update timer counter, which can also be the index of process
        self.currentPlayIndex ++;
        EXECUTE_BLOCK(self.fbBlock, self.currentPlayIndex);
    }
}


#pragma mark ---- pop barrage function with different style
- (void)popDecayBarrageTextView:(NSInteger)number
{
    //get a barrage text view with tag, which includes order info of subviews
    BarrageTextView *bView = (BarrageTextView*)[self viewWithTag:VIEW_TAG_BARRAGE_BEGIN+number];
    POPDecayAnimation *positionAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
    //根据落点的预算，来推算起始点的位置。
    CGPoint fromPos = [self getStartPosition:number WithType:PBBarrageStylePopDecay];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPos];
    //根据加速度和距离的计算，做成自适应的速度应该是全view高度的两倍,方向向上。
    positionAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(0, -2 * BARRAGE_VIEW_HEIGHT)];
    
    
    //如果需要在完成animation的时候做一些操作，则可以使用completionBlock如下：
    positionAnimation.completionBlock = ^(POPAnimation *positionAnimation, BOOL finished){
        if (finished) {
            [bView pop_removeAnimationForKey:@"layerPositionDecayAnimation"];
        }
    };
    
    
    [bView pop_addAnimation:positionAnimation forKey:@"layerPositionDecayAnimation"];
}

- (void) popSpringBarrageTextView:(NSInteger)number
                        withSpeed:(NSInteger)speed
{
    //get a barrage text view with tag, which includes order info of subviews
    BarrageTextView *bView = (BarrageTextView*)[self viewWithTag:VIEW_TAG_BARRAGE_BEGIN+number];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    //设置落点
    CGPoint toPos = [self getEndPosition:number];
    positionAnimation.toValue = [NSValue valueWithCGPoint:toPos];
    positionAnimation.springBounciness = 20;
    //根据传入的速度类型选择适合的速度参数(和弹跳次数)
    switch (speed) {
        case PBBarrageSpeedVeryLow:
        {
            positionAnimation.springSpeed = 1.0;
        }
            break;
        case PBBarrageSpeedLow:
        {
            positionAnimation.springSpeed = 5.0;
        }
            break;
        case PBBarrageSpeedHigh:
        {
            positionAnimation.springSpeed = 15.0;
        }
            break;
        case PBBarrageSpeedSuperHigh:
        {
            positionAnimation.springSpeed = 20.0;
        }
            break;
        default:
        {
            positionAnimation.springSpeed = 10.0;
        }
            break;
    }

    //如果需要在完成animation的时候做一些操作，则可以使用completionBlock如下：
    positionAnimation.completionBlock = ^(POPAnimation *positionAnimation, BOOL finished){
        if (finished) {
            [bView pop_removeAnimationForKey:@"layerPositionSpringAnimation"];
        }
    };
    
    [bView pop_addAnimation:positionAnimation forKey:@"layerPositionSpringAnimation"];
}

- (void) popNormalBarrageTextView:(NSInteger)number
                         WithType:(NSInteger)type
                         andSpeed:(NSInteger)speed
{
    //get a barrage text view with tag, which includes order info of subviews
    BarrageTextView* bView = (BarrageTextView*)[self viewWithTag:VIEW_TAG_BARRAGE_BEGIN+number];
    
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    //根据落点的预算，来推算起始点的位置。
    CGPoint fromPos = [self getStartPosition:number WithType:type ];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPos];
    CGPoint toPos = [self getEndPosition:number];
    positionAnimation.toValue = [NSValue valueWithCGPoint:toPos];

    //basic类型的pop目前主要使用以下几种数学模型
    //kCAMediaTimingFunctionLinear 匀速
    //kCAMediaTimingFunctionEaseOut 减速
    //kCAMediaTimingFunctionEaseIn 加速
    //kCAMediaTimingFunctionEaseInEaseOut 加速后减速
    switch (type) {
        case PBBarrageStylePopLinear:
        {
            positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        }
            break;
        case PBBarrageStylePopEaseIn:
        {
            positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        }
            break;
        case PBBarrageStylePopEaseOut:
        {
            positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        }
            break;
        case PBBarrageStylePopEaseInout:
        {
            positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        }
            break;
        default:
            break;
    }

    //根据传入的速度类型选择适合的速度参数
    switch (speed) {
        case PBBarrageSpeedVeryLow:
        {
            positionAnimation.duration = 9.0;
        }
            break;
        case PBBarrageSpeedLow:
        {
            positionAnimation.duration = 7.0;
        }
            break;
        case PBBarrageSpeedHigh:
        {
            positionAnimation.duration = 3.0;
        }
            break;
        case PBBarrageSpeedSuperHigh:
        {
            positionAnimation.duration = 1.0;
        }
            break;
        default:
        {
            positionAnimation.duration = 5.0;
        }
            break;
    }
    
    //如果需要在完成animation的时候做一些操作，则可以使用completionBlock如下：
    positionAnimation.completionBlock = ^(POPAnimation *positionAnimation, BOOL finished){
        if (finished) {
            [bView pop_removeAnimationForKey:@"layerPositionNormalAnimation"];
        }
    };

    [bView pop_addAnimation:positionAnimation forKey:@"layerPositionNormalAnimation"];
}

#pragma mark --- gesture long press
- (void)setLongPressAction
{
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self addGestureRecognizer:longPressGes];
    [self setUserInteractionEnabled:YES];
}

- (void)onLongPress:(id)sender
{
    CGPoint clickedPosition = CGPointMake([sender locationInView:self].x,[sender locationInView:self].y);
    CGRect viewBounds = self.layer.bounds;
    
    self.ringEmitter = [HYCEmitterLayer emitterViewInView:self AtPoint:clickedPosition AndBounds:viewBounds];
}

@end
