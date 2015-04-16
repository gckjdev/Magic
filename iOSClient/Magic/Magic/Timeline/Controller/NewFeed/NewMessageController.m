//
//  NewMessageController.m
//  BarrageClient
//
//  Created by Teemo on 15/3/20.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "NewMessageController.h"
#import "NewFeedCollectionView.h"
#import "Masonry.h"
#import "UIViewController+Utils.h"
#import "UILineLabel.h"
#import "FeedService.h"
#import "NewFeedSelectController.h"
#import "UIViewUtils.h"
#import "FontInfo.h"
#import "ColorInfo.h"
#import "UIScrollView+MJRefresh.h"
#import "Feed.h"
#import "ViewInfo.h"



#define LINELABEL_TOP_INSET 30.0f

@interface NewMessageController ()<NewFeedCollectionViewDelegate>
@property (nonatomic,strong) PBMyNewFeedList   *myNewFeedList;
@property (nonatomic,strong) NewFeedCollectionView   *myNewFeedView;
@property (nonatomic,strong) Feed*   feedData;
@property (nonatomic,strong) NewFeedSelectController   *newfeedController;
@property (nonatomic,strong) UILineLabel   *lineLabel;
@end

@implementation NewMessageController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setDefaultBackButton:@selector(backAction)];
    [self initView];
    [self initMyNewFeedView];
    [self initLabel];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /**
     *  刷新数据
     */
    [_myNewFeedView headerBeginRefreshing];
}
-(void)refreshData{
    __weak typeof(self) weakSelf = self;
    [[FeedService sharedInstance]getMyNewFeedList:^(PBMyNewFeedList *newFeed, NSError *error) {
        [weakSelf.myNewFeedView headerEndRefreshing];
        if (error == nil) {
            [weakSelf.myNewFeedView updateData:newFeed];
            if ([newFeed.myFeeds count]) {
                weakSelf.myNewFeedList = newFeed;
                [weakSelf.lineLabel setHidden:YES];
            }
            else{
                [weakSelf.lineLabel setHidden:NO];
            }
            
        }
        
    }];
}
-(void)backAction{
    
    
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:0.3];
    
    [animation setType: kCATransitionPush];
    
    [animation setSubtype: kCATransitionFromRight];
    
    animation.fillMode=kCAFillModeForwards;
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)initMyNewFeedView{
    _myNewFeedView = [NewFeedCollectionView initWithNewFeed:nil];
    _myNewFeedView.actionDelegate = self;
    [self.view addSubview:_myNewFeedView];
    CGRect frame = self.view.bounds;
    frame.size.height -= kNavigationBarHeight + kTabBarHeight + kStatusBarHeight;
    _myNewFeedView.frame = self.view.bounds;
    
    [_myNewFeedView addHeaderWithTarget:self action:@selector(headRefreshAction)];
    
    _myNewFeedView.headerPullToRefreshText = @"下拉可以刷新了";
    _myNewFeedView.headerReleaseToRefreshText = @"松开马上刷新了";
    _myNewFeedView.headerRefreshingText = @"正在帮你刷新中，不客气";
}
-(void)headRefreshAction
{
    [self refreshData];
}

-(void)didClickOnOneNewFeed:(PBMyNewFeed*)pbNewFeed
{    
    [[FeedService sharedInstance]readMyNewFeed:pbNewFeed.feedId callback:^(NSError *error) {
      
    }];
    
    __weak typeof(self) weakSelf = self;
   [[FeedService sharedInstance]getFeedById:pbNewFeed.feedId callback:^(PBFeed *feed, NSError *error) {
       if (error ==nil) {
           Feed *myFeed =[ Feed feedWithPBFeed:feed];
           weakSelf.feedData = myFeed;
           
           [weakSelf.newfeedController updateData:myFeed];
       }
    }];
    NewFeedSelectController *newSelectController = [NewFeedSelectController initWithFeed:nil];
    [self.navigationController pushViewController:newSelectController animated:YES];
    _newfeedController = newSelectController;

}
-(void)initView{
  self.title = @"新消息";
}
-(void)initLabel{
    _lineLabel = [UILineLabel initWithText:@"无新消息" Font:BARRAGE_BUTTON_FONT Color:BARRAGE_LABEL_COLOR Type:UILINELABELTYPE_NONE];
    [_myNewFeedView addSubview:_lineLabel];

    _lineLabel.center = _myNewFeedView.center;
    CGRect frame = _lineLabel.frame;
    frame.origin.y = LINELABEL_TOP_INSET;
    _lineLabel.frame = frame;
    
    [_lineLabel setHidden:YES];
}

@end
