 //
//  TimelineCell.m
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "TimelineCell.h"
#import "Masonry.h"
#import "TimelineCellHeaderView.h"
#import "TimelineCellFooterView.h"
#import "FeedBarrageView.h"
#import "UIImageView+WebCache.h"
#import "Feed.h"
#import "CommentFeedController.h"
#import "ShareViewController.h"
#import "FeedManager.h"
#import "CMPopTipView.h"
#import "AvatarCollectionView.h"
#import "FriendDetailController.h"
#import "MKBlockActionSheet.h"
#import "FeedService.h"
#import "UserManager.h"
#import "FriendManager.h"
#import "TagManager.h"
#import "UserTimelineFeedController.h"
#import "TagInfoViewController.h"
#import "AppDelegate.h"
#import "UILineLabel.h"
#import "ViewInfo.h"

#define MAX_ITEM_COUNT_IN_ROW       (ISIPAD? 12:4)
#define MAX_ROW_COUNT_IN_VIEW       3

@interface TimelineCell()<AvatarCollectionViewDelegate>

@property (nonatomic, strong) TimelineCellHeaderView* headerView;
@property (nonatomic, strong) TimelineCellFooterView* footerView;
@property (nonatomic, strong) UIView* intervalView; //  间隔
@property (nonatomic, strong) FeedBarrageView* feedView;
@property (nonatomic, strong) Feed* feed;
@property (nonatomic,assign)  BOOL isShowBarrage;

@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UIView* subtitleView;
@property (nonatomic, strong) CMPopTipView* popTipAvatarsView;

@end

@implementation TimelineCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        __weak typeof(self) weakSelf = self;
        
        self.headerView = [[TimelineCellHeaderView alloc] init];
        CGRect headerFrame = CGRectMake(0, 0, kScreenWidth, TIMELINE_CELL_HEADER_HEIGHT);
        [self.headerView setFrame:headerFrame];
        [self.contentView addSubview:_headerView];

        [self.headerView setClickDisplayUserButtonBlock:^(id sender) {
            [weakSelf displayUsers];
        }];
        
        CGRect feedViewFrame = CGRectMake(0, TIMELINE_CELL_HEADER_HEIGHT, kScreenWidth, BARRAGE_HEIGHT(kScreenWidth));
        self.feedView = [FeedBarrageView barrageViewInView:self.contentView frame:feedViewFrame];

        
        // add subtitle view here
        CGRect subtitleViewFrame = CGRectMake(0, headerFrame.size.height + feedViewFrame.size.height - TIMELINE_CELL_SUBTITLE_VIEW_HEIGHT, kScreenWidth, TIMELINE_CELL_SUBTITLE_VIEW_HEIGHT);
        self.subtitleView = [[UIView alloc]initWithFrame:subtitleViewFrame];
        [self.contentView addSubview:_subtitleView];
        _subtitleView.layer.opacity = 0.9;  //  透明度，未定
        _subtitleView.backgroundColor = [UIColor whiteColor];
        
        self.subtitleLabel = [[UILabel alloc]init];
        [self.subtitleView addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_subtitleView);
            make.left.equalTo(_subtitleView).with.offset(+(TIMELINE_TIME_LABEL_LEFT_SPACE));  //  偏移值
            make.centerY.equalTo(_subtitleView);
        }];
        _subtitleLabel.font = BARRAGE_LABEL_FONT;
        _subtitleLabel.textColor = BARRAGE_LABEL_COLOR;

        self.footerView = [[TimelineCellFooterView alloc] init];
        CGRect footerViewFrame = CGRectMake(0, headerFrame.size.height + feedViewFrame.size.height, kScreenWidth, TIMELINE_CELL_FOOTER_HEIGHT);
        self.footerView.frame = footerViewFrame;
//        CGFloat footerViewY = kScreenWidth + TIMELINE_CELL_HEADER_HEIGHT;
        [self.contentView addSubview:self.footerView];


        //  消息的间隔
        //  -1和+2是为了把interView的左边和右边边框去掉
        CGRect intervalViewFrame = CGRectMake(-1, headerFrame.size.height + feedViewFrame.size.height +  footerViewFrame.size.height, kScreenWidth+2, TIMELINE_INTERVAL_VIEW_HEIGHT);
        self.intervalView = [[UIView alloc]initWithFrame:intervalViewFrame];
        
        [self.contentView addSubview:_intervalView];
        _intervalView.backgroundColor = BARRAGE_BG_COLOR;
    
        [_intervalView.layer setBorderColor:[BARRAGE_TIMELINE_INTERVIEW_BG_COLOR CGColor]];
        [_intervalView.layer setBorderWidth:0.5f];
        
        [self.footerView setClickPlayButtonBlock:^(id sender) {
            [weakSelf play:0];
        }];

        [self.footerView setClickShareButtonBlock:^(id sender) {
            [weakSelf share];
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.feedView.userInteractionEnabled = YES;
        
        /**
         *  设置默认显示弹幕
         */
        self.isShowBarrage = YES;
        
        /**
         *  添加单击和双击手势
         */
        [self addTapHandler];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)addTapHandler
{
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapActon:)];

    /**
     *  单击
     */
    singleRecognizer.numberOfTapsRequired = 1;
    [self.feedView addGestureRecognizer:singleRecognizer];
    
    /**
     *  双击的 Recognizer
     */
    UITapGestureRecognizer* doubleRecognizer;
    doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapActon)];
    doubleRecognizer.numberOfTapsRequired = 2;
    [self.feedView addGestureRecognizer:doubleRecognizer];
    
    
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
    
    /**
     * 长按的 Recognizer
     */
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addLongPressAction:)];
    
    //设置长按时间间隔
    [longPressRecognizer setNumberOfTouchesRequired:1];
    [self.feedView addGestureRecognizer:longPressRecognizer];
}
-(void)doubleTapActon{
    if (self.isShowBarrage) {
        [self.feedView showAllBarrages];
    }else{
        [self.feedView hideAllBarrages];
    }
    self.isShowBarrage = !self.isShowBarrage;
}
-(void)addLongPressAction:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSString *makeSure = @"删除图片";
#ifdef DEBUG
        NSString *saveData = @"保存数据";
        MKBlockActionSheet *actionSheet = [[MKBlockActionSheet alloc]
                                           initWithTitle:@"选项"delegate:nil
                                           cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                           otherButtonTitles:makeSure,saveData, nil];
#else
        MKBlockActionSheet *actionSheet = [[MKBlockActionSheet alloc]
                                           initWithTitle:@"选项"delegate:nil
                                           cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                           otherButtonTitles:makeSure, nil];
#endif
        
        
        
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
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIMELINE_RELOAD_ALL_ROWS
                                                                                                            object:nil];
                        }
                    }];
                }
                else{
                    POST_SUCCESS_MSG(@"只能删除自己的图片");
                }
            }
#ifdef DEBUG
            else if ([saveData isEqualToString:title]){
                [self saveLocalData];
            }
#endif
        }];
        [actionSheet showInView:self];
    }
}
-(void)saveLocalData{
    
    //    Feed *feed = [[[FeedManager sharedInstance] userTimelineFeedList] objectAtIndex:0];
    
    PBFeed *pbFeed = [_feed.feedBuilder build];
    
    NSData *data = [pbFeed data];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *path = [NSString stringWithFormat:@"/tmp/demo%@.dat",dateStr];
    BOOL status = [data writeToFile:path atomically:YES];
    
    
    PPDebug(@"neng save : %d",status);
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
- (void)showRipple
{
    UIColor *rippleColor = [UIColor redColor];
    UIColor *stroke = rippleColor ? rippleColor : [UIColor colorWithWhite:0.8 alpha:0.8];
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
    
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint shapePosition = [self convertPoint:self.center fromView:nil];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = stroke.CGColor;
    circleShape.lineWidth = 3;
    
    [self.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
}

-(void)handleLongPress:(UILongPressGestureRecognizer*)recognizer
{
    PPDebug(@"long press caught, %f", recognizer.minimumPressDuration);
    if (recognizer.state == UIGestureRecognizerStateRecognized){
        [CommentFeedController showFromController:self.superController
                                         withFeed:self.feed
                                         startPos:CGPointMake(0, 0)];
    }
}

-(void)singleTapActon:(UITapGestureRecognizer*)recognizer
{
//    PPDebug(@"single tap caught");
    CGPoint pos =[recognizer locationInView:recognizer.view];
    [CommentFeedController showFromController:self.superController
                                     withFeed:self.feed
                                     startPos:CGPointMake(pos.x, pos.y)];
}


- (void)updateCellData:(Feed*)feed
{
    self.feed = feed;
    
    [self.headerView updateData:feed];
    NSURL* url = [NSURL URLWithString:feed.feedBuilder.image];
    [self.feedView updateImageWithURL:url callback:^(NSError *error) {
        if (error == nil) {
            [self.feedView addBarrageWithActions:feed.feedBuilder.actions];
            [self autoPlay];
        }
        else{
            PPDebug(@"neng : update image error");
        }
    }];
    [self.footerView updateData:feed];
    
    //  udpate subtitle view text
    
    if ([feed.feedBuilder.text length] > 0) {
        _subtitleView.hidden = NO;
        _subtitleLabel.text = feed.feedBuilder.text;
    }else{
        _subtitleView.hidden = YES;
        _subtitleLabel.text = nil;
    }
    
    _subtitleView.hidden = YES;        // always hidden, set by Benson, consider in future
    
}

- (void)hideAllPopUps
{
    [self.popTipAvatarsView dismissAnimated:YES];
}

- (void)play:(NSUInteger)index
{
    PPDebug(@"play feed");
    [self.feedView moveTo:index];
    
    //update current play index from self.feedview
    //which will be execute every timer fired;
    __block NSString* feedId = self.feed.feedId;
    self.feedView.fbBlock = ^(NSInteger currentPlayIndex){
        [[FeedManager sharedInstance] updateFeedPlayIndex:feedId
                                                playIndex:currentPlayIndex];
    };
}

- (void)autoPlay
{
    NSUInteger index = [[FeedManager sharedInstance] getFeedCurrentPlayIndex:self.feed.feedId];
    [self play:index];
}

- (void)share
{
    PPDebug(@"share feed");
    ShareViewController* shareViewCont = [[ShareViewController alloc]init];
    shareViewCont.oringinImageURL = [NSURL URLWithString:self.feed.feedBuilder.image];
    shareViewCont.barrageList = self.feed.feedBuilder.actions;
    
    [self.superController.navigationController pushViewController:shareViewCont animated:YES];
    
}

// *******
//add by charlie
//for displaying avatars when click timeline header arrow
// *******
- (void)displayUsers
{
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
    
    /*
    //允许每一个feed都可以添加tag，但是要过滤掉不认识（没添加为好友）的人。
    //以下为lineLabel的动态变化
     */
    NSMutableArray* arr = [NSMutableArray arrayWithArray:[[FriendManager sharedInstance] filterUnknownUserFromUsers:self.feed.feedBuilder.toUsers]];
    if([arr count]<2)
        fv.hidden = YES;
    else
        fv.hidden = NO;
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
    [self.popTipAvatarsView dismissAnimated:YES];
    NSMutableArray* arr = [NSMutableArray arrayWithArray:[[FriendManager sharedInstance]filterUnknownUserFromUsers:self.feed.feedBuilder.toUsers]];
    if([arr count] == 0)
        return;
    TagInfoViewController* cont = [[TagInfoViewController alloc]initWithType:IsCreating andPBTag:nil orPBUsers:arr];
    AppDelegate *delegate = [[UIApplication  sharedApplication]delegate];
    UIViewController* currentController = delegate.currentViewController;
    
    [currentController.navigationController pushViewController:cont animated:YES];
}

@end
