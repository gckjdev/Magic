//
//  NewFeedSelectController.m
//  BarrageClient
//
//  Created by Teemo on 15/3/25.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "NewFeedSelectController.h"
#import "PPDebug.h"
#import "TimelineCell.h"
#import "Feed.h"
#import "CommonBarrageCell.h"
#import "ColorInfo.h"
#import "ShareViewController.h"
#import "UIViewUtils.h"
#import "Feed.h"
#import "CommentFeedController.h"
#import "UIViewController+Utils.h"
#import "UserTimelineFeedController.h"
#import "FeedService.h"


@interface NewFeedSelectController ()<CommonBarrageCellDelegate>
@property (nonatomic,strong) Feed*   feedData;
@property (nonatomic,strong) UIScrollView   *holderView;
@property (nonatomic,strong) CommonBarrageCell*   cell;
@end

@implementation NewFeedSelectController
+(instancetype)initWithFeed:(Feed*)feed
{
    NewFeedSelectController *newController = [[NewFeedSelectController alloc]init];
//    newController.feedData = feed;
//    [newController updateData:feed];
    return newController;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setRedNavigationBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)initView{
    [self setTitle:@"详情"];

    
    _holderView = [[UIScrollView alloc]init];
    _holderView.frame = self.view.bounds;
    _holderView.contentSize  = CGSizeMake(kScreenWidth, kTimelineCellHeight+kNavigationBarHeight+kStatusBarHeight+kTabBarHeight);
    [self.view addSubview:_holderView];
    
    _cell = [CommonBarrageCell initWithFrame:CGRectMake(0, 0, kScreenWidth, kTimelineCellHeight)
             type:BARRAGE_CELL_WITH_HEAD_FOOT];
    _cell.actionDelegate = self;
    [_holderView addSubview:_cell];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshFeed)
                                                 name:NOTIFICATION_TIMELINE_RELOAD_VISIABLE_ROWS
                                               object:nil];
}
-(void)refreshFeed{
     [[FeedService sharedInstance]getFeedById:_feedData.feedId callback:^(PBFeed *feed, NSError *error) {
         if (error == nil) {
             Feed *newFeed = [Feed feedWithPBFeed:feed];
             [_cell updateCellData:newFeed];
         }
     }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_TIMELINE_RELOAD_VISIABLE_ROWS
                                                  object:nil];
}
-(void)didClickShare:(Feed*)feed
{
    ShareViewController* shareViewCont = [[ShareViewController alloc]init];
    shareViewCont.oringinImageURL = [NSURL URLWithString:feed.feedBuilder.image];
    shareViewCont.barrageList = feed.feedBuilder.actions;
    [self.navigationController pushViewController:shareViewCont animated:YES];
}

-(void)singleTapCellActon:(Feed*)feed  position:(CGPoint)position
{
    [CommentFeedController showFromController:self withFeed:feed startPos:position];
}
-(void)updateData:(Feed*)feed
{
    PPDebug(@"neng : feedId %@ ",feed.feedId);
//    Feed *newFeed = [Feed feedWithPBFeed:feed];
    _feedData = feed;
    [_cell updateCellData:feed];
}

@end
