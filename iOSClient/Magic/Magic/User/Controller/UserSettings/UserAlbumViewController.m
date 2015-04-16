//
//  UserAlbumViewController.m
//  BarrageClient
//
//  Created by Teemo on 15/3/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "UserAlbumViewController.h"
#import "UserAlbumCollectionView.h"
#import "FeedService.h"
#import "NewFeedSelectController.h"
#import "Feed.h"
#import "UserManager.h"
#import "ViewInfo.h"
#import "UIViewUtils.h"
#import "UIScrollView+MJRefresh.h"


#define LIMIT_FEED_COUNT    30

@interface UserAlbumViewController () <UserAlbumCollectionViewDelegate>

@property (nonatomic,strong) UserAlbumCollectionView   *collectionView;
@property (nonatomic,strong) NSArray   *myFeeds;
@property (nonatomic, assign) NSInteger      currentCount;
@end

@implementation UserAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}

-(void)initView{
    
    self.title = @"相册";
    
    _collectionView = [UserAlbumCollectionView initWithFeeds:nil];
    _collectionView.actionDelegate = self;
    [self.view addSubview:_collectionView];
    
    
    [_collectionView addHeaderWithTarget:self action:@selector(headRefreshAction)];
    [_collectionView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    
    CGRect frame = self.view.bounds;
    frame.size.height -= kTabBarHeight + kNavigationBarHeight + kStatusBarHeight;
    _collectionView.frame = frame;
    
    
    _collectionView.headerPullToRefreshText = @"下拉可以刷新了";
    _collectionView.headerReleaseToRefreshText = @"松开马上刷新了";
    _collectionView.headerRefreshingText = @"正在帮你刷新中，不客气";
    _collectionView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _collectionView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _collectionView.footerRefreshingText = @"正在帮你加载中，不客气";
    
    _currentCount = 0;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshData];
}

-(void)headRefreshAction{
    
    _currentCount -= LIMIT_FEED_COUNT;
    if (_currentCount<0) {
        _currentCount = 0;
    }
    [self refreshData];
    
    
}
-(void)footerRefreshAction{
    NSInteger num = [_collectionView numberOfItemsInSection:0];
    if (num<LIMIT_FEED_COUNT) {
        [_collectionView footerEndRefreshing];
        return;
    }
    _currentCount += LIMIT_FEED_COUNT;
   
    [self refreshData];
}
-(void)refreshData{
    __weak typeof(self) weakSelf = self;

    PPDebug(@"neng : curentCount %d",_currentCount);
    [[FeedService sharedInstance]getUserFeed:(int)_currentCount callback:^(NSArray *feedList, NSError *error) {
        if (error == nil) {
            weakSelf.myFeeds = feedList;
            [weakSelf.collectionView updateViewWithData:weakSelf.myFeeds];
        }
        [weakSelf.collectionView headerEndRefreshing];
        [weakSelf.collectionView footerEndRefreshing];
    }];
}

-(void)didClickFeed:(PBFeed *)feed
{
    Feed *myFeed = [Feed feedWithPBFeed:feed];
    
    NewFeedSelectController *newSelectController = [NewFeedSelectController initWithFeed:nil];
    [newSelectController updateData:myFeed];
    [self.navigationController pushViewController:newSelectController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
