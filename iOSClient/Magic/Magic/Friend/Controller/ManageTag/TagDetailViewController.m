//
//  TagDetailViewController.m
//  BarrageClient
//
//  Created by HuangCharlie on 1/30/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "TagDetailViewController.h"
#import "User.pb.h"
#import "TagManager.h"
#import "FriendService.h"
#import "UserAvatarView.h"
#import "FriendAvatarCollectionViewCell.h"
#import "UIViewUtils.h"
#import <Masonry.h>
#import "EditingController.h"
#import "AvatarCollectionView.h"
#import "UIViewController+Utils.h"
#import "TagInfoViewController.h"
#import "PublishSelectView.h"
#import "FeedService.h"
#import "FeedManager.h"

#define MAX_ITEM_COUNT_IN_ROW       (ISIPAD? 12:5)

@interface TagDetailViewController ()
{
    
}

@property (nonatomic,strong) UILabel* nameLabel;
@property (nonatomic,strong) UILabel* label;
@property (nonatomic,strong) AvatarCollectionView* avatarsView;
@property (nonatomic,strong) UIButton* button;

@end

@implementation TagDetailViewController

- (instancetype)initWithPbUserTag:(PBUserTag*)userTag
{
    self = [super init];
    self.currentTag = userTag;
    self.currentUserList = [[TagManager sharedInstance]userListByTag:self.currentTag];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"标签详情"];
    [self.view setBackgroundColor:BARRAGE_BG_COLOR];
    [self addRightButtonWithTitle:@"编辑" target:self action:@selector(onEdit:)];
    
    [self addAvatarCollectionView];
    [self updateAvatarCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    //add by neng, Analyze
    [super viewDidAppear:animated];
    
    //update tag info at the beginning or after edit
    self.currentTag = [[TagManager sharedInstance]getTagWithTID:self.currentTag.tid];
    self.currentUserList = [[TagManager sharedInstance]userListByTag:self.currentTag];
    [self updateAvatarCollectionView];
}

- (void)onEdit:(id)sender
{
    TagInfoViewController *cont = [[TagInfoViewController alloc]initWithType:IsEditing andPBTag:self.currentTag orPBUsers:nil];
    cont.fromController = self;
    [self.navigationController pushViewController:cont animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addAvatarCollectionView
{
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kTabBarHeight-kStatusBarHeight-kNavigationBarHeight);
    
    CGSize hSize = CGSizeMake(self.view.frame.size.width, 2*COMMON_TEXTFIELD_HEIGHT+2*COMMON_MARGIN_OFFSET_Y);
    CGSize fSize = CGSizeMake(self.view.frame.size.width, COMMON_BUTTON_HEIGHT+2*COMMON_MARGIN_OFFSET_Y);
    UICollectionViewFlowLayout *layout = [AvatarCollectionView flowLayoutWithHeaderSize:hSize footerSize:fSize];
    
    //header view design
    UIView *hv = [AvatarCollectionView setHeaderView];
    
    self.nameLabel = [[UILabel alloc]init];
    [self.nameLabel setBackgroundColor:[UIColor whiteColor]];
    [self.nameLabel setText:[self.currentTag name]];
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    [hv addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hv.mas_left);
        make.right.equalTo(hv.mas_right);
        make.top.equalTo(hv.mas_top).with.offset(COMMON_MARGIN_OFFSET_Y);
        make.height.equalTo(@(COMMON_TEXTFIELD_HEIGHT));
    }];

    self.label = [[UILabel alloc]init];
    self.label.backgroundColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.textColor = BARRAGE_LABEL_GRAY_COLOR;
    self.label.font = BARRAGE_LABEL_FONT;
    self.label.numberOfLines = 0;
    UIView* holder = [[UIView alloc]init];
    holder.backgroundColor = [UIColor whiteColor];
    [hv addSubview:holder];
    [holder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(hv);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(COMMON_MARGIN_OFFSET_Y);
        make.width.equalTo(hv);
        make.height.equalTo(@(COMMON_TEXTFIELD_HEIGHT));
    }];
    [holder addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(holder.mas_left).with.offset(COMMON_MARGIN_OFFSET_Y);
        make.right.equalTo(holder.mas_right);
        make.top.equalTo(holder.mas_top);
        make.bottom.equalTo(holder.mas_bottom);
    }];

    
    //footer view design
    UIView *fv = [AvatarCollectionView setFooterView];
    UIButton* shareButt = [UIView defaultTextButton:@"分享照片" superView:fv];
    [shareButt addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
    [shareButt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fv.mas_top).with.offset(COMMON_MARGIN_OFFSET_Y);
    }];
    
    self.avatarsView = [[AvatarCollectionView alloc]initWithFrame:frame
                                             collectionViewLayout:layout
                                                 presentationMode:DisplayMode
                                                       headerView:hv
                                                       footerView:fv];
    [self.view addSubview:self.avatarsView];
}

- (void)updateAvatarCollectionView
{
    self.nameLabel.text = self.currentTag.name;
    
    NSString* str = [NSString stringWithFormat:@"成员（%lu）",(unsigned long)[self.currentUserList count]];
    self.label.text = str;

    [self.avatarsView loadPbUserList:self.currentUserList];
    
    //根据collectionview的内容自动调整整个collectionview高度，若高度超出屏幕则frame为屏幕大小
    CGFloat num = [self.currentUserList count]*1.0/(MAX_ITEM_COUNT_IN_ROW);
    num = ceil(num);
    NSUInteger row = num;
    
    CGFloat visibleHeight = (CELL_AVATAR_HEIGHT+CELL_NAME_HEIGHT+COMMON_MARGIN_OFFSET_Y)*row+COMMON_MARGIN_OFFSET_Y*4+COMMON_TEXTFIELD_HEIGHT*2+COMMON_BUTTON_HEIGHT*1;
        
    if(visibleHeight<self.view.frame.size.height){
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, visibleHeight);
        [self.avatarsView setFrame:rect];
    }
    else{
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kStatusBarHeight-kToolBarHeight-kTabBarHeight);
        [self.avatarsView setFrame:rect];
    }

}

- (void)onShare:(id)sender
{
    CGRect frame = [UIApplication sharedApplication].keyWindow.bounds;
    PublishSelectView *publishSelectView = [[PublishSelectView alloc] initWithFrame:frame];
    
    [[UIApplication sharedApplication].keyWindow addSubview:publishSelectView];
    
    [[FeedManager sharedInstance] setShareToFriendsCache:self.currentUserList];
}

@end
