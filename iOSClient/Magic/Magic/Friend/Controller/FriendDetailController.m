//
//  FriendDetailController.m
//  BarrageClient
//
//  Created by gckj on 15/1/29.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "FriendDetailController.h"
#import "UserAvatarCell.h"
#import "UserManager.h"
#import "UIViewUtils.h"
#import "ColorInfo.h"
#import "Masonry.h"
#import "FriendService.h"
#import "PublishSelectView.h"
#import "FeedService.h"
#import "FeedManager.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"
#import "UserAvatarView.h"
#import "UIViewController+Utils.h"
#import "UserDetailCell.h"

#import "TagManager.h"

#define kFriendDetailBasicCell  @"kFriendDetailBasicCell"
#define kUserCell               @"kUserCell"

@interface FriendDetailController ()

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)PBUser *user;
@property (nonatomic,assign)BOOL isFriend;
@property (nonatomic,assign)int avatarSection;  //  头像那个section
@property (nonatomic,assign)int basicSection;  //  其他基本section
@property (nonatomic,assign)int sectionIndex;  //  section索引，计数功能
@property (nonatomic,assign)int indexOfSection;
@property (nonatomic,strong)NSArray *basicItemArray;

@end

#define TITLE_LOCATION @"位置"
#define TITLE_SINATURE @"签名"
#define TITLE_TAG      @"标签"

@implementation FriendDetailController

#pragma mark - Public methods
//  根据user和isFriend产生
-(instancetype)initWithUser:(PBUser*)user
{
    self = [super init];
    self.user = user;
    self.isFriend = [[FriendManager sharedInstance] isFriend:user.userId];
    return self;
}

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [[UIApplication sharedApplication]setStatusBarHidden:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication]setStatusBarHidden:NO];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//  加载页面基本设置
-(void)loadView
{
    [super loadView];
    self.title = @"详细资料";
    [self loadData];
    [self loadTableView];
    [self loadButton];
//    [self setupNavBackButton];
}
#pragma mark - Private methods
- (void)loadTableView
{
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    
//    CGFloat tableViewHeight = COMMON_AVATARCELL_HEIGHT * 1 + COMMON_TABLEVIEW_ROW_HEIGHT * self.basicItemArray.count;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
//        make.height.equalTo(@(tableViewHeight));
        make.height.equalTo(self.view.mas_width);
        make.width.equalTo(self.view);
    }];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //  separatorNone
    self.view.backgroundColor = BARRAGE_BG_COLOR;
    self.tableView.tableFooterView = [[UIView alloc]init];  //  去看tableview最下面的线
    self.tableView.backgroundColor = BARRAGE_BG_COLOR;
    self.tableView.dataSource = self;
    self.tableView.delegate  = self;
}
//  加载按钮
- (void)loadButton
{
    UIButton *button;
    if (self.isFriend){
        button = [UIButton defaultTextButton:@"分享照片" superView:self.view];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        if (self.user.addStatus == FriendAddStatusTypeReqStatusNone){
            button = [UIButton defaultTextButton:@"添加为好友"  superView:self.view];
            [button addTarget:self
                       action:@selector(clickToAddFriend:)
             forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            switch (self.user.addDir){
                case FriendRequestDirectionReqDirectionReceiver:
                    // 提供【同意】和【拒绝】选项
                    button = [UIButton defaultTextButton:@"同意"  superView:self.view];
                    [button addTarget:self
                               action:@selector(clickToAcceptFriend:)
                     forControlEvents:UIControlEventTouchUpInside];
                    break;
                    
                    
                case FriendRequestDirectionReqDirectionSender:
                    button = [UIButton defaultTextButton:@"添加为好友"  superView:self.view];
                    [button addTarget:self
                               action:@selector(clickToAddFriend:)
                     forControlEvents:UIControlEventTouchUpInside];
                    break;
            }
        }
    }
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).with.offset(COMMON_MARGIN_OFFSET_Y*2);
    }];
}
//  加载数据
-(void)loadData
{
    //  确定section的排列
    self.avatarSection = self.indexOfSection++;
    self.basicSection = self.indexOfSection++;

    if (self.isFriend){
        self.basicItemArray = @[TITLE_SINATURE,TITLE_LOCATION,TITLE_TAG];
    }else{
        self.basicItemArray = @[TITLE_SINATURE,TITLE_LOCATION];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int row;
    if (section == self.avatarSection) {
        row = 1;
    }else{
        row = (int)self.basicItemArray.count;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section == self.avatarSection) {
//            UserAvatarCell *avatarCell = [[UserAvatarCell alloc]initWithStyle:UITableViewCellStyleDefault
//                                                              reuseIdentifier:nil
//                                                                         user:self.user
//                                                              superViewController:self];
            UserDetailCell *detailCell = [[UserDetailCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                              reuseIdentifier:nil
                                                                         user:self.user];
//            detailCell.tagTextLabel.text = TITLE_TAG;
//            detailCell.locationTextLabel.text = TITLE_LOCATION;
            detailCell.tagDetailTextLabel.text = [self acquireTagString];
            detailCell.avatarView.clickOnAvatarBlock = ^(void){
                NSURL *url = [NSURL URLWithString:self.user.avatar];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                TGRImageViewController *vc = [[TGRImageViewController alloc] initWithImage:image];
                [self presentViewController:vc animated:YES completion:nil];
            };
//            return avatarCell;
            return detailCell;
        }else {
            UITableViewCell *basicCell = [tableView dequeueReusableCellWithIdentifier:kFriendDetailBasicCell];
            if (basicCell == nil)
            {
                basicCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                  reuseIdentifier:kFriendDetailBasicCell];
            }
            basicCell.backgroundColor = [UIColor clearColor];
            //  cell下方的横线
            [UIView addSingleLineWithColor:BARRAGE_CELL_LAYER_COLOR
                               borderWidth:COMMON_LAYER_BORDER_WIDTH
                                 superView:basicCell];
            basicCell.textLabel.font = BARRAGE_LABEL_FONT; //  字体
            basicCell.textLabel.textColor = BARRAGE_TEXTFIELD_COLOR;   //  颜色
            
            basicCell.detailTextLabel.font = BARRAGE_LITTLE_LABEL_FONT;    //字体
            
            basicCell.textLabel.text = self.basicItemArray[indexPath.row];
            if ([self.basicItemArray[indexPath.row] isEqualToString: TITLE_SINATURE]) {
                NSString *signatureStr = @"什么也没有";
                if ([_user.signature length] != 0) {
                    signatureStr = _user.signature;
                }
                basicCell.detailTextLabel.text = signatureStr;
            }else if([self.basicItemArray[indexPath.row] isEqualToString: TITLE_LOCATION]){

                NSString *locationStr = @"未设置";
                if ([_user.location length] != 0) {
                    locationStr = _user.location;
                }
                basicCell.detailTextLabel.text = locationStr;
            }else if([self.basicItemArray[indexPath.row] isEqualToString: TITLE_TAG]){
//                NSMutableString *tagStr = [[NSMutableString alloc]init];
//
//                NSArray *userTagList = [[TagManager sharedInstance]getTagWithUser:self.user];
//                if (userTagList != nil && userTagList.count != 0) {
//                    for (int i = 0; i<userTagList.count; i++) {
//                        PBUserTag *tempTag = userTagList[i];
//                        NSString *tempTagName = tempTag.name;
//                        if (i == userTagList.count - 1) {
//                            [tagStr appendFormat:@"%@",tempTagName];
//                        }else{
//                            [tagStr appendFormat:@"%@，",tempTagName];
//                        }
//                    }
//                    
//                }else{
//                    [tagStr appendString: @"未设置"];
//                }
                basicCell.detailTextLabel.text = [self acquireTagString];
            }else{
                //TODO
                basicCell.textLabel.text = @"未知，待增加！";
            }
            return basicCell;
        }
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _avatarSection) {
        return self.view.frame.size.width;
    }else{
        return COMMON_TABLEVIEW_ROW_HEIGHT;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.avatarSection) {
        NSURL *url = [NSURL URLWithString:self.user.avatarBg];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        TGRImageViewController *vc = [[TGRImageViewController alloc] initWithImage:image];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        tableView.allowsSelection = NO;
    }
}
#pragma mark - Utils
-(void)clickButton:(id)sender
{
    if (_isFriend) {
        CGRect frame = [UIApplication sharedApplication].keyWindow.bounds;
        PublishSelectView *publishSelectView = [[PublishSelectView alloc] initWithFrame:frame];
        
        [[UIApplication sharedApplication].keyWindow addSubview:publishSelectView];
        
        NSArray* array = [NSArray arrayWithObject:self.user];
        
        [[FeedManager sharedInstance] setShareToFriendsCache:array];
        
    } else {
        //  TODO  不是朋友 添加好友
        [self clickToAddFriend:sender];
    }
}

-(void)clickToAddFriend:(id)sender
{
    PBAddUserFriendRequestBuilder* builder = [PBAddUserFriendRequest builder];
    [builder setFriend:_user];
    [builder setSourceType:FriendAddSourceTypeAddBySearch]; //  来源类型
    [builder setMemo:@""];  //  备注
    
    [[FriendService sharedInstance] addUserFriend:[builder build] callback:^(NSError *error) {
        if(error)
        {
            PPDebug(@"<Add user by search> error in adding user");
            return;
        }
        else{
            PPDebug(@"Add user success");
            POST_SUCCESS_MSG(@"添加请求已发出");
        }
    }];
}

- (void)clickToAcceptFriend:(id)sender
{
    PBProcessUserFriendRequestBuilder* builder = [PBProcessUserFriendRequest builder];
    [builder setMemo:@""];
    [builder setFriendId:self.user.userId];
    [builder setProcessResult:PBProcessFriendResultTypeAcceptFriend];
    
    [[FriendService sharedInstance] processUserFriendRequest:[builder build] callback:^(NSError *error) {
        if(error)
        {
            PPDebug(@"<clickToAcceptFriend> error in accept user");
            return;
        }
        else{
            PPDebug(@"<clickToAcceptFriend> success");
            [self.navigationController popViewControllerAnimated:YES];
            POST_SUCCESS_MSG(@"已同意添加好友");
        }
    }];
}
- (NSMutableString*)acquireTagString
{
    NSMutableString *tagStr = [[NSMutableString alloc]init];
    
    NSArray *userTagList = [[TagManager sharedInstance]getTagWithUser:self.user];
    if (userTagList != nil && userTagList.count != 0) {
        for (int i = 0; i<userTagList.count; i++) {
            PBUserTag *tempTag = userTagList[i];
            NSString *tempTagName = tempTag.name;
            if (i == userTagList.count - 1) {
                [tagStr appendFormat:@"%@",tempTagName];
            }else{
                [tagStr appendFormat:@"%@，",tempTagName];
            }
        }
        
    }else{
        //  TODO
    }
    return tagStr;
}
@end
