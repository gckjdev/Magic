//
//  CommonBarrageCell.m
//  BarrageClient
//
//  Created by Teemo on 15/3/25.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CommonBarrageCell.h"

#import "AvatarCollectionView.h"
#import "TimelineCellFooterView.h"
#import "TimelineCellHeaderView.h"
#import "FeedBarrageView.h"
#import "Masonry.h"
#import "MKBlockActionSheet.h"
#import "ShareViewController.h"
#import "UserManager.h"
#import "FeedService.h"
#import "CommentFeedController.h"
#import "FeedManager.h"
#import "UIImageView+WebCache.h"
#import "UILineLabel.h"
#import "CMPopTipView.h"
#import "FriendManager.h"
#import "TagManager.h"
#import "FriendListController.h"
#import "FriendDetailController.h"
#import "TagInfoViewController.h"
#import "AppDelegate.h"

#define MAX_ITEM_COUNT_IN_ROW       (ISIPAD? 12:4)
#define MAX_ROW_COUNT_IN_VIEW       3

@interface CommonBarrageCell()<AvatarCollectionViewDelegate>

@property (nonatomic, strong) TimelineCellHeaderView* headerView;
@property (nonatomic, strong) TimelineCellFooterView* footerView;

@property (nonatomic, strong) FeedBarrageView* feedView;
@property (nonatomic, strong) Feed* feed;
@property (nonatomic,assign)  BOOL isShowBarrage;

@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UIView* subtitleView;
@property (nonatomic, strong) CMPopTipView* popTipAvatarsView;

@end
@implementation CommonBarrageCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
      
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self initView];
    }
    return self;
}
-(void)initView
{
    
    [self initHeadView];
    
    [self initFeedView];
 
    [self initFooterView];
    
    /**
     *  设置默认显示弹幕
     */
    self.isShowBarrage = YES;
    
    /**
     *  添加单击和双击手势
     */
    [self addTapHandler];

}


+(instancetype)initWithFrame:(CGRect)frame
                        type:(CommonBarrageCellType)type
{
    CommonBarrageCell *cell = [[CommonBarrageCell alloc]initWithFrame:frame];
    cell.type = type;
    return cell;
}

-(void)initHeadView{
    __weak typeof(self) weakSelf = self;
    
    self.headerView = [[TimelineCellHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TIMELINE_CELL_HEADER_HEIGHT)];

    [self addSubview:_headerView];

    [self.headerView setClickDisplayUserButtonBlock:^(id sender) {
        [weakSelf displayUsers];
    }];
}
-(void)initFeedView{
    CGRect feedViewFrame = CGRectMake(0, TIMELINE_CELL_HEADER_HEIGHT, kScreenWidth, BARRAGE_HEIGHT(kScreenWidth));
    self.feedView = [FeedBarrageView barrageViewInView:self frame:feedViewFrame];
    self.feedView.userInteractionEnabled = YES;
}
-(void)initFooterView
{
    
    __weak typeof(self) weakSelf = self;
    CGFloat feedViewHeight = CGRectGetHeight(self.feedView.frame);
    self.footerView = [[TimelineCellFooterView alloc] init];
    CGRect footerViewFrame = CGRectMake(0, TIMELINE_CELL_HEADER_HEIGHT + feedViewHeight, kScreenWidth, TIMELINE_CELL_FOOTER_HEIGHT);
    self.footerView.frame = footerViewFrame;
    [self addSubview:self.footerView];
    
    
    [self.footerView setClickPlayButtonBlock:^(id sender) {
        [weakSelf play];
    }];
    
    [self.footerView setClickShareButtonBlock:^(id sender) {
        [weakSelf share];
    }];
    
}

-(void)setType:(CommonBarrageCellType)type
{
    if (type == BARRAGE_CELL_SIMPLE) {
        [_footerView setHidden:YES];
        [_headerView setHidden:YES];
        CGRect frame = _feedView.frame;
        frame.origin.y = - TIMELINE_CELL_HEADER_HEIGHT;
        _feedView.frame = frame;
        self.feedView.userInteractionEnabled = NO;
    }
    else if (type == BARRAGE_CELL_WITH_HEAD_FOOT)
    {
        [_footerView setHidden:NO];
        [_headerView setHidden:NO];
        CGRect frame = _feedView.frame;
        frame.origin.y = 0;
        _feedView.frame = frame;
        self.feedView.userInteractionEnabled = YES;
    }
}
- (void)addTapHandler
{
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapActon:)];
    
    /**
     *  单击
     */
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    
    //给view添加一个手势监测；
    [self.feedView addGestureRecognizer:singleRecognizer];
    
    
    // 双击的 Recognizer
    UITapGestureRecognizer* doubleRecognizer;
    doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapActon)];
    
    /**
     *  双击
     */
    doubleRecognizer.numberOfTapsRequired = 2;
    
    //给view添加一个手势监测；
    [self.feedView addGestureRecognizer:doubleRecognizer];
    
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
    
    /**
     *  长按
     */
    
    // 长按的 Recognizer
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addLongPressAction:)];
    
    //设置长按时间间隔
    [longPressRecognizer setNumberOfTouchesRequired:1];
    [self.feedView addGestureRecognizer:longPressRecognizer];
}
-(void)addLongPressAction:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSString *makeSure = @"删除图片";
        MKBlockActionSheet *actionSheet = [[MKBlockActionSheet alloc]
                                           initWithTitle:@"选项"delegate:nil
                                           cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                           otherButtonTitles:makeSure, nil];
        
        __weak typeof (actionSheet) as = actionSheet;
        [actionSheet setActionBlock:^(NSInteger buttonIndex){
            NSString *title = [as buttonTitleAtIndex:buttonIndex];
            if ([title isEqualToString:makeSure]) {
                if ([self isCurrentUser:_feed.feedBuilder.createUser.userId]) {
                    [[FeedService sharedInstance]deleteFeed:_feed.feedId callback:^(NSString *feedId, NSError *error) {
                        PPDebug(@"neng feedId %@",feedId);
                        if (error==nil) {
                            POST_SUCCESS_MSG(@"删除图片成功");
                            // post notification to UserTimelineController
//                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIMELINE_RELOAD_ALL_ROWS
//                                                                                object:nil];
                        }
                    }];
                }
                else{
                    POST_SUCCESS_MSG(@"只能删除自己的图片");
                }
            }
        }];
        [actionSheet showInView:self];
    }
}
-(BOOL) isCurrentUser:(NSString*)tmpUserId
{
    NSString* myUserId = [[UserManager sharedInstance] userId];
    //    PPDebug(@"neng : currnt id %@ %@",myUserId,textBuilder.user.userId);
    if(![tmpUserId isEqualToString:myUserId])
    {
        return NO;
    }
    
    return YES;
}
-(void)handleLongPress:(UILongPressGestureRecognizer*)recognizer
{
    PPDebug(@"long press caught, %f", recognizer.minimumPressDuration);
    if (recognizer.state == UIGestureRecognizerStateRecognized){
        [CommentFeedController showFromController:self.superController withFeed:self.feed startPos:CGPointZero];
    }
}

-(void)singleTapActon:(UITapGestureRecognizer*)recognizer
{
//    PPDebug(@"single tap caught");
    CGPoint pos =[recognizer locationInView:recognizer.view];
//    [CommentFeedController show:self.superController feed:self.feed startPos:CGPointMake(pos.x, pos.y)];
    [_actionDelegate singleTapCellActon:_feed position:pos];
}
-(void)doubleTapActon{
    if (self.isShowBarrage) {
        [self.feedView showAllBarrages];
    }else{
        [self.feedView hideAllBarrages];
    }
    self.isShowBarrage = !self.isShowBarrage;
}

- (void)updateCellData:(Feed*)feed
{
    self.feed = feed;
    
    [self.headerView updateData:feed];
    NSURL* url = [NSURL URLWithString:feed.feedBuilder.image];
    [self.feedView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        PPDebug(@"image(%@) load, error(%@)", feed.feedBuilder.image, error);
        
        [self.feedView setImage:image];
        [self.feedView addBarrageWithActions:feed.feedBuilder.actions];
        [self.feedView play];
    }];
    [self.footerView updateData:feed];
    

}
//- (void)play:(NSUInteger)index
//{
//    PPDebug(@"play feed");
//    [self.feedView playFrom:index];
//    
//    // TODO need to be more accurate, update feed play index to last
//    NSUInteger lastIndex = 0;
//    if ([self.feed.feedBuilder.actions count] > 0){
//        lastIndex = [self.feed.feedBuilder.actions count] - 1;
//    }
//    [[FeedManager sharedInstance] updateFeedPlayIndex:self.feed.feedId playIndex:lastIndex];
//}
//
//- (void)autoPlay
//{
//    NSUInteger index = [[FeedManager sharedInstance] getFeedCurrentPlayIndex:self.feed.feedId];
//    
//    [self play:index];
//}
- (void)play
{
    PPDebug(@"play feed");
    [self.feedView play];
    
    // update feed play index to last
    NSUInteger lastIndex = 0;
    if ([self.feed.feedBuilder.actions count] > 0){
        lastIndex = [self.feed.feedBuilder.actions count] - 1;
    }
    [[FeedManager sharedInstance] updateFeedPlayIndex:self.feed.feedId playIndex:lastIndex];
}

- (void)share
{

    
    [_actionDelegate didClickShare:self.feed];
    
}

//add by charlie, for displaying avatars when click timeline header arrow
- (void)displayUsers
{
    PPDebug(@"display user");
    
    NSString* str = @"为TA们创建标签";
    CGSize lineLabelSize = [str sizeWithAttributes:@{NSFontAttributeName:BARRAGE_LITTLE_LABEL_FONT}];
    
    CGSize hSize = CGSizeMake(self.frame.size.width, 0.1);
    CGSize fSize = CGSizeMake(self.frame.size.width, lineLabelSize.height);
    UICollectionViewFlowLayout *layout = [AvatarCollectionView flowLayoutWithHeaderSize:hSize footerSize:fSize];
    
    //make customized header footer view
    UIView* hv = [AvatarCollectionView setHeaderView];
    UIView* fv = [AvatarCollectionView setFooterView];
    fv.backgroundColor = [UIColor whiteColor];
    UILineLabel* lineLabel = [UILineLabel initWithText:str
                                                  Font:BARRAGE_LITTLE_LABEL_FONT
                                                 Color:BARRAGE_LABEL_GRAY_COLOR
                                                  Type:UILINELABELTYPE_DOWN];
    
    [fv addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fv.mas_centerX);
        make.centerY.equalTo(fv.mas_centerY);
        make.height.equalTo(@COMMON_LINE_LABEL_HEIGHT);
    }];
    
    if([self.feed.feedBuilder.toUsers count]==1)
        fv.hidden = YES;
    else
        fv.hidden = NO;
    
    /*
     //允许每一个feed都可以添加tag，但是要过滤掉不认识（没添加为好友）的人。
     //以下为lineLabel的动态变化
     */
    NSMutableArray* arr = [NSMutableArray arrayWithArray:[[FriendManager sharedInstance] filterUnknownUserFromUsers:self.feed.feedBuilder.toUsers]];
    PBUserTag* tag = [[TagManager sharedInstance]checkOverTagsForArray:arr];
    if(tag == nil)//not belong to any tag
    {
        [lineLabel addTapGestureWithTarget:self selector:@selector(onClickAddTagForFriends:)];
    }
    else
    {//belong to a tag, show it
        NSUInteger diff = [self.feed.feedBuilder.toUsers count]-[[tag userIds]count]-1;
        if(diff == 0){
            NSString* str = [NSString stringWithFormat:@"%@ (%lu)",[tag name],(unsigned long)[[tag userIds]count]];
            [lineLabel setText:str];
        }
        else{
            NSString* str = [NSString stringWithFormat:@"%@ (%ld), 其他 (%ld)",[tag name],(unsigned long)[[tag userIds]count],(unsigned long)diff];
            [lineLabel setText:str];
        }
    }
    
    /*
     //
     //用用户数计算行数，从而控制高度
     //以下为该pop view的高度的动态变化
     */
    //get row count
    NSArray* userArr = self.feed.feedBuilder.toUsers;
    CGFloat num = [userArr count]*1.0/(MAX_ITEM_COUNT_IN_ROW);
    num = ceil(num);
    NSUInteger row = num;
    
    //make adaptive height
    CGFloat width = self.frame.size.width-2*COMMON_MARGIN_OFFSET_X;
    if(row>MAX_ROW_COUNT_IN_VIEW) row = MAX_ROW_COUNT_IN_VIEW;
    CGFloat height = row * layout.itemSize.height+COMMON_MARGIN_OFFSET_Y * (row+1)+layout.footerReferenceSize.height;
    CGRect frame = CGRectMake(0, 0, width, height);
    
    //creat the final view and show it
    AvatarCollectionView* avatarsView;
    avatarsView = [[AvatarCollectionView alloc]initWithFrame:frame
                                        collectionViewLayout:layout
                                            presentationMode:DisplayMode
                                                  headerView:hv
                                                  footerView:fv];
    [avatarsView loadPbUserList:userArr];
    avatarsView.actionDelegate = self;
    UIView* holderView = [[UIView alloc]initWithFrame:frame];
    [holderView addSubview:avatarsView];
    
    self.popTipAvatarsView = [[CMPopTipView alloc]initWithCustomView:holderView];
    self.popTipAvatarsView.backgroundColor = [UIColor whiteColor];
    
    [self.popTipAvatarsView presentPointingAtView:self.headerView.displayUserButton
                                           inView:self
                                         animated:YES];
    
}

- (void)didClickOnOneUserAvatar:(PBUser *)pbUser
{
    FriendDetailController* cont = [[FriendDetailController alloc]initWithUser:pbUser];
    
    [self.superController.navigationController pushViewController:cont animated:YES];
}

- (void)onClickAddTagForFriends:(id)sender
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:[[FriendManager sharedInstance]filterUnknownUserFromUsers:self.feed.feedBuilder.toUsers]];
    if([arr count] == 0)
        return;
    TagInfoViewController* cont = [[TagInfoViewController alloc]initWithType:IsCreating andPBTag:nil orPBUsers:arr];
    
    AppDelegate *delegate = [[UIApplication  sharedApplication]delegate];
    UIViewController* currentController = delegate.currentViewController;
    
    [currentController.navigationController pushViewController:cont animated:YES];
}

@end
