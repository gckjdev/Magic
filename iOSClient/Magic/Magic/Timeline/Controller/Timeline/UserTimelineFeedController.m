//
//  UserTimelineFeedController.m
//  BarrageClient
//
//  Created by pipi on 14/12/11.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#define USERTIMELINEFEEDCONTROLLER_HINTVIEW_LABELTEXT                @"点击底部中间按钮分享照片"
#define USERTIMELINEFEEDCONTROLLER_HINTVIEW_BUTTONTEXT               @"观看好友弹幕互动演示"


#define USERTIMELINEFEEDCONTROLLER_HINTVIEW_LINELABEL_PADDING            -10.0f
#define USERTIMELINEFEEDCONTROLLER_HINTVIEW_LABEL_BORDERWIDTH           1.0f

#define USERTIMELINEFEEDCONTROLLER_HINTVIEW_BUTTON_WIDTH                200.0f
#define USERTIMELINEFEEDCONTROLLER_HINTVIEW_BUTTON_HEIGHT               50.0f


#import "UserTimelineFeedController.h"
#import "FeedService.h"
#import "MJRefresh.h"
#import "FeedManager.h"
#import "REMenu.h"
#import "SCLAlertView.h"
#import "MKBlockActionSheet.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "UIViewUtils.h"
#import "UMFeedback.h"
#import "UIViewController+Utils.h"
#import "SearchUserController.h"
#import "UserHomeController.h"
#import "PlusMenu.h"
#import "Masonry.h"
#import "UILineLabel.h"
#import "AppDelegate.h"
#import "DemoViewController.h"
#import "UIViewController+Utils.h"
#import "NewMessageController.h"
#import "FileUtil.h"
#import "BadgeButton.h"
#import "ImageBadgeButton.h"

@interface UserTimelineFeedController ()

@property (nonatomic, strong) REMenu*   menu;
@property (nonatomic, assign) BOOL      hasNewMessage;
@property (nonatomic, strong) NSString* offsetFeedId;
@property (nonatomic, strong) UIView*   hintView; //when date is nil, show this view

@property (nonatomic,strong) ImageBadgeButton  *leftMessageButton;
@end

@implementation UserTimelineFeedController


- (void)viewDidLoad {
    
    self.hasNewMessage = NO;
    [super viewDidLoad];
    
    [self loadTableView];
    
    [self loadHintView];
    
    [self addLeftMessageButton];

}

-(void)addLeftMessageButton{

    
    CGRect frame = CGRectMake(0, 0, COMMON_NAV_BUTTON_SIZE , COMMON_NAV_BUTTON_SIZE);
    _leftMessageButton = [ImageBadgeButton initWithFrame:frame image:@"new_message_normal" target:self action:@selector(showNewMessageContoller)];
    _leftMessageButton.imageEdgeInsets =UIEdgeInsetsMake(0, NAVBARLEFT_BUTTON_INSET_LEFT, 0, 0);
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:_leftMessageButton];
  

//    [self.view addSubview:badge];
    self.navigationItem.leftBarButtonItem = leftButton;
   
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenPlusMenuAtHomeNavigationBar];
}
-(void)showNewMessageContoller
{
    
    [self setNewControllAnimation];
    
    NewMessageController *newFeed = [[NewMessageController alloc]init];
    
    [self.navigationController pushViewController :newFeed animated:NO];
    
}

-(void)setNewControllAnimation
{
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:0.3];
    
    [animation setType: kCATransitionPush];
    
    [animation setSubtype: kCATransitionFromLeft];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];

}
-(void)loadTableView
{
    
    /**
     *   init tableView
     */
    
    self.tableView = [[TimelineTableView alloc]initWithSuperController:self];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(self.view.mas_height);
        make.width.equalTo(self.view.mas_width);
    }];

    /**
     *  CallBack
     */
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf loadNewData];
    }];
    
    [self.tableView addFooterWithCallback:^{
        [weakSelf loadMoreData];
    }];
    
    /**
     *  添加右上角按钮
     */
    [self addPlusMenuAtHomeNavigationBar];
    
    /**
     *  设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
     */
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在帮你刷新中，不客气";
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在帮你加载中，不客气";
    
    /**
     *  刷新数据
     */
    [self.tableView headerBeginRefreshing];
    
    
    /**
     *  通知刷新可见的Cell
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshVisiableCell:)
                                                 name:NOTIFICATION_TIMELINE_RELOAD_VISIABLE_ROWS
                                               object:nil];
    
    /**
     *  通知刷新可见的Cell
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshAllCell:)
                                                 name:NOTIFICATION_TIMELINE_RELOAD_ALL_ROWS
                                               object:nil];
    
    /**
     *  通知下拉刷新
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadDataFromNetwork)
                                                 name:NOTIFICATION_TIMELINE_RELOAD_FROM_NETWORK
                                               object:nil];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_TIMELINE_RELOAD_VISIABLE_ROWS
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_TIMELINE_RELOAD_FROM_NETWORK
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_TIMELINE_RELOAD_ALL_ROWS
                                                  object:nil];
}

- (void)headerRefreshing
{
    [self.tableView headerBeginRefreshing];
}

- (void)reloadDataFromNetwork
{
    [self headerRefreshing];
}

#pragma mark  HintView
- (void) loadHintView
{
    /**
     *  init hintView
     */

    CGRect frame = self.view.bounds;
    self.hintView = [[UIView alloc]initWithFrame:frame];

    [self.hintView setHidden:YES];
    [self.tableView addSubview:self.hintView];
    
    UIButton* button = [UIView defaultTextButton:USERTIMELINEFEEDCONTROLLER_HINTVIEW_BUTTONTEXT superView:self.hintView];

    [button addTarget:self action:@selector(onShow) forControlEvents:UIControlEventTouchUpInside];
    
   [button mas_updateConstraints:^(MASConstraintMaker *make) {
       make.centerX.equalTo(self.hintView);
       make.centerY.equalTo(self.hintView).offset(-kTabBarHeight);
   }];

   
    UILineLabel *lineLabel = [[UILineLabel alloc]init];
    [lineLabel  setFont: BARRAGE_TEXTFIELD_FONT];
    [lineLabel  setTextColor: BARRAGE_TEXTFIELD_COLOR];
    [lineLabel  setLineType:UILINELABELTYPE_NONE];
    [lineLabel  setLineColor:BARRAGE_TEXTFIELD_COLOR];
    [lineLabel  setPadding: USERTIMELINEFEEDCONTROLLER_HINTVIEW_LINELABEL_PADDING];
    [lineLabel  setTextAlignment:NSTextAlignmentCenter];
    [lineLabel  setText:USERTIMELINEFEEDCONTROLLER_HINTVIEW_LABELTEXT];
    [self.hintView addSubview:lineLabel];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.centerY.equalTo(button).offset(USERTIMELINEFEEDCONTROLLER_HINTVIEW_BUTTON_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(USERTIMELINEFEEDCONTROLLER_HINTVIEW_BUTTON_WIDTH, USERTIMELINEFEEDCONTROLLER_HINTVIEW_BUTTON_HEIGHT));
    }];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showTabBar];
    
    // Q: what is this?
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    

    [self setRedNavigationBar];
    
    [self refreshBarrageView];
}

-(void)onShow{
    PPDebug(@"展示界面");

    [[AppDelegate sharedInstance]showDemoController];
}
-(void)refreshVisiableCell:(NSNotification *)notification
{
    NSArray * indexArray = [self.tableView indexPathsForVisibleRows];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)refreshAllCell:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}

-(void)judgeHaveFeedList{
    NSUInteger dataCount = [[[FeedManager sharedInstance] userTimelineFeedList] count];
    if (dataCount == 0){
        // show Hint view
        [self.hintView setHidden:NO];
    }
    else{
        // show Hint view

        [self.hintView setHidden:YES];
    }
}

- (void)reloadView
{
    [self.tableView reloadData];
    [self judgeHaveFeedList];
}

// This method is called when the Dynamic Type user setting changes (from the system Settings app)
- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self reloadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshBarrageView
{
    __weak typeof(self) weakSelf = self;
    [[FeedService sharedInstance]getMyNewFeedList:^(PBMyNewFeedList *newFeed, NSError *error) {
        if (error == nil) {
            NSInteger newNum = [newFeed.myFeeds count];
            NSString *showNum=nil;
            if (newNum>99) {
                showNum = @"N";
            }
            else if (newNum >= 1)
            {
                showNum = [NSString stringWithFormat:@"%ld",newNum];
                
            }
            [weakSelf.leftMessageButton setBadgeValue:showNum];
//            [weakSelf.leftMessageButton setBadgeValue:@"12"];
        }
        
    }];
   
}

- (void)loadNewData
{
    __weak typeof(self) weakSelf = self;
    [[FeedService sharedInstance] getTimelineFeed:nil callback:^(NSArray *feedList, NSError *error) {
        if (error == nil){
            [weakSelf reloadView];
        }
        
        [weakSelf.tableView headerEndRefreshing];
    }];
    [self refreshBarrageView];
    
}

- (NSString*)getLastFeedId
{
    NSArray* list = [[FeedManager sharedInstance] userTimelineFeedList];
    if ([list count] == 0){
        return nil;
    }
    
    Feed* feed = [list objectAtIndex:([list count]-1)];
    return feed.feedId;
}

- (void)loadMoreData
{
    NSString* lastFeedId = [self getLastFeedId];
    
    __weak typeof(self) weakSelf = self;
    [[FeedService sharedInstance] getTimelineFeed:lastFeedId callback:^(NSArray *feedList, NSError *error) {
        
        [weakSelf.tableView footerEndRefreshing];

        if ([feedList count] == 0){
            // no more data
            return;
        }
        
        if (error == nil){
            [self reloadView];
        }
    }];
}

#pragma mark - Right Button Menu
- (void)showOptionMenu
{
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"添加好友"
                                                    subtitle:nil //@""
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"意见反馈"
                                                       subtitle:@"第一时间把问题都发送给我们获得帮助！"
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"Activity"
                                                        subtitle:@"Perform 3 additional activities"
                                                           image:[UIImage imageNamed:@"Icon_Activity"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                          }];
    
    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"Profile"
                                                          image:[UIImage imageNamed:@"Icon_Profile"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    self.menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem]];
    self.menu.liveBlur = YES;
    self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleLight;
    [self.menu showFromNavigationController:self.navigationController];
}

- (void)showAlertOptionMenu
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    //Using Selector
    [alert addButton:@"First Button" actionBlock:^(void) {
        NSLog(@"Second button tapped");
    }];
    //Using Block
    [alert addButton:@"Second Button" actionBlock:^(void) {
        NSLog(@"Second button tapped");
    }];
    
    //Using Blocks With Validation
    [alert addButton:@"Validate" validationBlock:^BOOL {
        BOOL passedValidation = YES;
        return passedValidation;
    } actionBlock:^{
        // handle successful validation here
    }];
    
    [alert showSuccess:self title:@"Button View"
              subTitle:@"This alert view has buttons"
      closeButtonTitle:@"Done"
              duration:0.0f];
}

@end
