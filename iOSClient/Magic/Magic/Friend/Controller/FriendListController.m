//
//  FriendListController.m
//  BarrageClient
//
//  Created by pipi on 14/12/5.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

//codes added by charlie 2015 1 19
#import "FriendListController.h"
#import "FriendService.h"
#import "TagManager.h"
#import "HYCTagView.h"
#import "FriendListTableViewCell.h"
#import "UIViewUtils.h"
#import "User.pb.h"
#import "PlusMenu.h"
#import "FriendDetailController.h"
#import "TagInfoViewController.h"
#import "TagDetailViewController.h"
#import "FriendListTableView.h"
#import "HYCScrollView.h"
#import "UserAvatarView.h"
#import "UserManager.h"
#import <Masonry.h>
#import "MessageCenter.h"

#define ONEROW_SCROLL_VIEW_HEIGHT 78
#define TWOROW_SCROLL_VIEW_HEIGHT 128
#define MAX_SCROLL_VIEW_HEIGHT 178

@interface FriendListController ()<HYCTagViewDelegate,FriendListActionDelegate,TagInfoDelegate>
{

}

//view
@property (nonatomic,strong) HYCScrollView* tagScrollView;
@property (nonatomic,strong) UIView* noTagView;
@property (nonatomic,strong) FriendListTableView *friendListTableView;
@property (nonatomic,strong) UIView* noFriendView;

@property (nonatomic,assign) BOOL hasAddNew;


@end

@implementation FriendListController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self addPlusMenuAtFriendNavigationBar];
    
    //navigation property
    [self setTitle:@"我的好友"];
    
    //view
    [self addScrollViewOfTagList];
    [self addTableViewOfFriendList];
    [self addNoFriendView];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenPlusMenuAtFriendNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    //add by neng.analyze
    [super viewDidAppear:animated];
    
    //把读数据，reload视图都放在viewdidappear能少写一些回调
    //get data
    [self getTagPBDataList];
    [self getFriendPBDataList];
    
    //reload view with data
    [self reloadTagView];
    [self reloadFriendListView];
    
    
    BOOL isHintUser = ![[UserManager sharedInstance]hasSetNameAndAvatar];
    if (isHintUser) {
        POSTMSG(@"请设置信息");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- get data from server and store locally
//get pb data from server, stored in tag manager
- (void)getTagPBDataList
{
    SHOW_LOADING(LOADING_TEXT, self.view);
    [[FriendService sharedInstance]getAllTags:^(PBUserTagList *tagList, NSError *error)
    {
        HIDE_LOADING(self.view);
        if (error){
            PPDebug(@"error while getting tag list");
        }
    }];
}

//add friend pb list, will be stored by friend manager
- (void)getFriendPBDataList
{
    SHOW_LOADING(LOADING_TEXT, self.view);
    [[FriendService sharedInstance] getFriendList:PBGetUserFriendListTypeTypeAll
                                         callback:^(PBUserFriendList *friendList, NSError *error) {
                                             HIDE_LOADING(self.view);
                                             if (error){
                                                 PPDebug(@"error while getting friend list");
                                             }
                                             else{
                                                 [self reloadFriendListView];
                                             }
                                         }];
}

- (void)reloadTagView
{
    if([self getTagCount]==0)
    {
        self.tagScrollView.hidden = YES;
        
        CGRect tableRect = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
        [self.friendListTableView setFrame:tableRect];
    }
    else
    {
        self.tagScrollView.hidden = NO;
        
        NSArray* pbtagList = [[[TagManager sharedInstance]allTags]tags];
        
        NSUInteger type = [HYCTagView getArrangedRowCountWithFrame:self.view.frame andTags:pbtagList];
        
        CGRect scrollRect;
        if(type == 0){
            scrollRect = CGRectMake(0, 0,self.view.frame.size.width, ONEROW_SCROLL_VIEW_HEIGHT);
        }
        else if (type == 1){
            scrollRect = CGRectMake(0, 0,self.view.frame.size.width, TWOROW_SCROLL_VIEW_HEIGHT);
        }
        else{
            scrollRect = CGRectMake(0, 0,self.view.frame.size.width,MAX_SCROLL_VIEW_HEIGHT);
        }
        [self.tagScrollView setFrame:scrollRect];
        NSArray *viewArray = [HYCTagView createTagViewsWithFrame:scrollRect
                                                    allPbTagList:pbtagList
                                                   selectedUsers:nil
                                                        delegate:self];
        
        [self.tagScrollView updateScrollViewWithViewArray:viewArray];
        
        //如果是新建了一个tag然后返回的话，利用delegate传回这个消息，然后reload的时候就把page已到最后一页，然后还原状态。TODO 这样做比较蠢，，需要改进。。
        [self.tagScrollView moveToLastPage:self.hasAddNew];
        self.hasAddNew = NO;
        
        CGRect tableRect = CGRectMake(0, scrollRect.size.height, self.view.frame.size.width,self.view.frame.size.height-scrollRect.size.height);
        [self.friendListTableView setFrame:tableRect];
    }
}

- (void)reloadFriendListView
{
    NSArray *addedFriendList = [[FriendManager sharedInstance]friendList];
    NSArray *requestFriendList = [[FriendManager sharedInstance]requestFriendList];
    
    NSArray *allFriendList = [FriendManager addUserList:addedFriendList
                                          toOldUserList:requestFriendList];
    
    PBUser* me = [[UserManager sharedInstance]pbUser];
    if(me==nil)
    {
        return;
    }
    NSMutableArray *allFriendsPlusMe = [allFriendList mutableCopy];
    [allFriendsPlusMe insertObject:me atIndex:0];
    
    self.friendListTableView.pbFriendList = allFriendsPlusMe;
    if([allFriendList count]==0)
    {
        self.friendListTableView.hidden = YES;
        self.noFriendView.hidden=NO;
    }
    else
    {
        self.friendListTableView.hidden = NO;
        self.noFriendView.hidden=YES;
        [self.friendListTableView updateTableView];
    }
}

- (void)didProcessTag:(PBUserTag *)tag newlyAdd:(BOOL)flag
{
    //TODO 已经通过delegate传入tag参数，后面还可以进行更多操作
    self.hasAddNew = flag;
}

#pragma mark --- getter of count and pb data
//tag getter from tag manager, after stored by getTagPBDataList
- (PBUserTag*)getTag:(NSUInteger)count
{
    PBUserTag *userTag = [[[TagManager sharedInstance] allTags] tagsAtIndex:count];
    
    return userTag;
}

- (NSUInteger)getTagCount
{
    NSUInteger tagCount = [[[[TagManager sharedInstance] allTags] tags] count];
    return tagCount;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//at the top of controller, show user information, same style with friendlist

#pragma mark --- scroll view for tags and some delegate implementation
- (void)addScrollViewOfTagList
{
    CGRect visibleRect = CGRectMake(0,0,self.view.frame.size.width,MAX_SCROLL_VIEW_HEIGHT);
    
    self.tagScrollView = [[HYCScrollView alloc]initWithFrame:visibleRect];
    [self.view addSubview:self.tagScrollView];
}

- (void)didLongPressTag:(PBUserTag *)pbTag
{
    
}
- (void)didTapTag:(PBUserTag *)pbTag inStatus:(BOOL)isSelected
{
    TagDetailViewController* cont = [[TagDetailViewController alloc]initWithPbUserTag:pbTag];
    [self.navigationController pushViewController:cont animated:YES];
}

#pragma mark --- no friend view
- (void)addNoFriendView
{
    CGRect noFriendRect = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    self.noFriendView = [[UIView alloc]initWithFrame:noFriendRect];
    self.noFriendView.backgroundColor = BARRAGE_BG_COLOR;
    [self addMyInfoBarInNoFriendView];
    [self.view addSubview:self.noFriendView];
    
    UILabel* label = [UIView defaultLabel:@"点击右上角➕号添加好友"
                                superView:self.noFriendView];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.noFriendView.mas_centerY).dividedBy(2);
    }];
}
- (void)addMyInfoBarInNoFriendView
{
    UIView* myInfoHolderView = [[UIView alloc]init];
    [myInfoHolderView setBackgroundColor:BUTTON_TITLE_COLOR];
    [self.noFriendView addSubview:myInfoHolderView];
    [myInfoHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noFriendView.mas_left);
        make.right.equalTo(self.noFriendView.mas_right);
        make.top.equalTo(self.noFriendView.mas_top);
        make.height.equalTo(@(50));
    }];
    PBUser* user = [[UserManager sharedInstance]pbUser];
    CGRect avatarFrame = CGRectMake(0, 0, AVATAR_HEIGHT, AVATAR_HEIGHT);
    UserAvatarView* avatarView = [[UserAvatarView alloc] initWithUser:user frame:avatarFrame borderWidth:0.0f];
    [myInfoHolderView addSubview:avatarView];
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myInfoHolderView.mas_left).with.offset(COMMON_PADDING);
        make.centerY.equalTo(myInfoHolderView.mas_centerY);
        make.width.equalTo(@(AVATAR_HEIGHT));
        make.height.equalTo(@(AVATAR_HEIGHT));
    }];
    
    UILabel* nickLabel = [[UILabel alloc]init];
    [nickLabel setText:@"我"];
    [nickLabel setFont:BARRAGE_BUTTON_FONT];
    [nickLabel setTextColor:BARRAGE_LABEL_COLOR];
    [myInfoHolderView addSubview:nickLabel];
    [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).with.offset(COMMON_PADDING);
        make.centerY.equalTo(myInfoHolderView.mas_centerY);
    }];
    
    [myInfoHolderView addTapGestureWithTarget:self
                                     selector:@selector(onClickMyInfoBar:)];
}

-(void)onClickMyInfoBar:(id)sender
{
    PBUser* user = [[UserManager sharedInstance]pbUser];
    FriendDetailController* cont = [[FriendDetailController alloc]initWithUser:user];
    [self.navigationController pushViewController:cont animated:YES];
}


#pragma mark --- table view for friends list and some delegate
-(void)addTableViewOfFriendList
{
    self.friendListTableView = [[FriendListTableView alloc]init];

    // 设置tableView的委托,委托了self做一些事情，例如点击事件的处理等
    self.friendListTableView.actionDelegate = self;

    // UI design of friendlist tableview
    [self.view addSubview:self.friendListTableView];
}

-(void)clickOnItem:(PBUser *)user
{
    FriendDetailController *friendDetailCont = [[FriendDetailController alloc]initWithUser:user];
    [self.navigationController pushViewController:friendDetailCont animated:YES];
}

- (void)clickDeteleButton
{
    [self reloadFriendListView];
}

@end
