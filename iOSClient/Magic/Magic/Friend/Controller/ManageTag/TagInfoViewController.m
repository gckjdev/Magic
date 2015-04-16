//
//  TagInfoViewController.m
//  BarrageClient
//
//  Created by gckj on 15/2/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

//add by Charlie 2015 2 5
#import "TagInfoViewController.h"
#import "AvatarCollectionView.h"
#import "FriendAvatarCollectionViewCell.h"
#import "UIViewUtils.h"
#import "TagManager.h"
#import "FriendManager.h"
#import "FriendService.h"
#import "FeedService.h"
#import "PublishSelectView.h"
#import <Masonry.h>
#import "FriendListController.h"
#import "PickFriendListViewController.h"
#import "FriendDetailController.h"
#import "UIViewController+Utils.h"

#define MAX_ITEM_COUNT_IN_ROW   (ISIPAD? 12:5)

@interface TagInfoViewController ()<AvatarCollectionViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{

}

@property (nonatomic,assign) TagInfoType type;
@property (nonatomic,strong) AvatarCollectionView *avatarsView;
@property (nonatomic,strong) UILabel* label;
@property (nonatomic,strong) UITextField* textField;

@property (nonatomic,strong) UIAlertView* backAlert;
@property (nonatomic,strong) UIAlertView* delAlert;

@end

@implementation TagInfoViewController

- (instancetype)initWithType:(TagInfoType)type
                    andPBTag:(PBUserTag*)tag
                   orPBUsers:(NSArray*)users
{
    if(type == IsCreating)
    {
        self = [super init];
        
        self.currentTag = [[TagManager sharedInstance]buildNewTag:@""];
        if(users != nil)
            self.originUserList = users;
        else
            self.originUserList = [[NSArray alloc]init];
        self.currentUserList = [NSMutableArray arrayWithArray:self.originUserList];
        self.type = IsCreating;
        
        return self;
    }
    else if(type == IsEditing)
    {
        self = [super init];
        
        self.currentTag = tag;
        self.originUserList = [[TagManager sharedInstance]userListByTag:tag];
        self.currentUserList = [NSMutableArray arrayWithArray:self.originUserList];
        self.type = IsEditing;
        
        return self;
    }
    else
        return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:BARRAGE_BG_COLOR];
    [self setDefaultBackButton:@selector(onBack:)];
    
    [self addAvatarsCollectionView];
    
    if(self.type == IsCreating){
        [self setTitle:@"创建标签"];
        [self.textField becomeFirstResponder];
    }
    else{
        [self setTitle:@"编辑标签"];
        [self.textField resignFirstResponder];
    }
    [self addRightButtonWithTitle:@"确定" target:self action:@selector(onFinish:)];

    [self updateCollectionView];
}

- (BOOL)checkEmptyList
{
    if([self.currentUserList count]==0)
    {
        POST_ERROR(@"请至少选一个好友再点击确定～");
        return NO;
    }

    return YES;
}

- (BOOL)checkTagName
{
    if([self.textField.text length] == 0)
    {
        POST_ERROR(@"请输入标签名字再点击确定～");
        [self.textField becomeFirstResponder];
        return NO;
    }
    
    if([self.textField.text length] > 20)
    {
        POSTMSG(@"这标签名。。太长了吧。。");
        [self.textField becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)checkChange
{
    if([self.currentUserList isEqualToArray:self.originUserList])
        return NO;//没有改动过用户列表
    else
        return YES;
}


- (void)onFinish:(id)sender
{
    BOOL flag = ([self checkTagName] && [self checkEmptyList]);
    if(!flag)
        return;
        
    //update tag name
    self.currentTag = [[TagManager sharedInstance]updateTag:self.currentTag withNewName:self.textField.text];
        
    //add or update tag to server
    if(self.type == IsCreating)
    {
        [[FriendService sharedInstance]addTag:self.currentTag callback:^(PBUserTag *retTag, NSError *error) {
            if(error) return;
            
            self.currentTag = retTag;
                
            //add new user to tag
            NSMutableArray* addIdArray = [[NSMutableArray alloc]init];
            for(PBUser* user in self.currentUserList)
                [addIdArray addObject:user.userId];
            [[FriendService sharedInstance]addUsersToTag:self.currentTag addUserIds:addIdArray callback:^(PBUserTag *retTag, NSError *error) {
                if(error) return;
            }];
            
            [self.delegate didProcessTag:retTag newlyAdd:YES];
        }];
    }
    else if (self.type == IsEditing)
    {
        NSMutableArray* addingUserIds = [[NSMutableArray alloc]init];
        for(PBUser* user in self.currentUserList)
            [addingUserIds addObject:user.userId];
        [[FriendService sharedInstance]updateUserTag:self.currentTag currentUserIds:addingUserIds callback:^(PBUserTag *retTag, NSError *error) {
            if(error) return;
            
            [self.delegate didProcessTag:retTag newlyAdd:NO];
        }];
    }
    
    if(self.fromController == nil)
        [self.navigationController popToRootViewControllerAnimated:YES];
    else
        [self.navigationController popToViewController:self.fromController animated:YES];
    
}

- (void)onBack:(id)sender
{
    PPDebug(@"navigation go back");
    if(![self checkChange]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        self.backAlert = [[UIAlertView alloc]initWithTitle:@"放弃编辑？"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
        [self.backAlert show];
    }
}

- (void)onDelete:(id)sender
{
    //回归到编辑模式
    [self.avatarsView backToEditMode];
    
    self.delAlert = [[UIAlertView alloc]initWithTitle:@"你真的舍得删除这个标签？"
                                              message:nil
                                             delegate:self
                                    cancelButtonTitle:@"取消"
                                    otherButtonTitles:@"确定", nil];
    
    [self.delAlert show];
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
#pragma mark --- core view and its update
- (void)addAvatarsCollectionView
{
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kTabBarHeight-kStatusBarHeight-kNavigationBarHeight);
    
    CGSize hSize = CGSizeMake(self.view.frame.size.width, 2*COMMON_TEXTFIELD_HEIGHT+2*COMMON_MARGIN_OFFSET_Y);
    CGFloat fSizeHeight = (self.type == IsCreating)? 0.1:COMMON_BUTTON_HEIGHT+2*COMMON_MARGIN_OFFSET_Y;
    CGSize fSize = CGSizeMake(self.view.frame.size.width, fSizeHeight);
    UICollectionViewFlowLayout *layout = [AvatarCollectionView flowLayoutWithHeaderSize:hSize footerSize:fSize];
    
    //header view design
    UIView *hv = [AvatarCollectionView setHeaderView];

    self.textField = [UIView defaultTextField:@"请输入标签名字，例如死党" superView:hv];
    [self.textField setText:[self.currentTag name]];
    [self.textField setDelegate:self];
    [self.textField setKeyboardType:UIKeyboardTypeDefault];
    [self.textField setReturnKeyType:UIReturnKeyDone];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(self.textField.mas_bottom).with.offset(COMMON_MARGIN_OFFSET_Y);
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
    UIButton* delButt = [UIView defaultTextButton:@"删除标签" superView:fv];
    [delButt addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];
    [delButt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fv.mas_top).with.offset(COMMON_MARGIN_OFFSET_Y);
    }];
    
    self.avatarsView = [[AvatarCollectionView alloc]initWithFrame:frame
                                             collectionViewLayout:layout
                                                 presentationMode:EditMode
                                                       headerView:hv
                                                       footerView:fv];
    self.avatarsView.actionDelegate = self;
    [self.view addSubview:self.avatarsView];
}


- (void)updateCollectionView
{
    NSString* str = [NSString stringWithFormat:@"成员 (%lu)",(unsigned long)[self.currentUserList count]];
    self.label.text = str;
    
    [self.avatarsView loadPbUserList:self.currentUserList];
    
    [self.avatarsView setEaseInWithDuration:0.5];

    //根据collectionview的内容自动调整整个collectionview高度，若高度超出屏幕则frame为屏幕大小
    CGFloat num = ([self.currentUserList count]+2)*1.0/(MAX_ITEM_COUNT_IN_ROW);
    num = ceil(num);
    NSUInteger row = num;
    
    CGFloat visibleHeight;
    //hide delete tag button if type is creating
    if(self.type == IsCreating){
        self.avatarsView.footer.hidden = YES;
        visibleHeight = (CELL_AVATAR_HEIGHT+CELL_NAME_HEIGHT+COMMON_MARGIN_OFFSET_Y)*row+COMMON_MARGIN_OFFSET_Y*2+COMMON_TEXTFIELD_HEIGHT*2;
    }
    else{
        self.avatarsView.footer.hidden = NO;
        visibleHeight = (CELL_AVATAR_HEIGHT+CELL_NAME_HEIGHT+COMMON_MARGIN_OFFSET_Y)*row+COMMON_MARGIN_OFFSET_Y*4+COMMON_TEXTFIELD_HEIGHT*2+COMMON_BUTTON_HEIGHT*1;
    }
    
    if(visibleHeight<self.view.frame.size.height){
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, visibleHeight);
        [self.avatarsView setFrame:rect];
    }
    else{
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kStatusBarHeight-kToolBarHeight-kTabBarHeight);
        [self.avatarsView setFrame:rect];
    }
}

#pragma mark --- delegate of avatar collection, including add,delete and click in
- (void)didClickAddIcon
{
    //回归到编辑模式
    [self.avatarsView backToEditMode];
    
    PickFriendListViewController *pickFriendCont = [[PickFriendListViewController alloc]init];
    pickFriendCont.originPickedArray = self.currentUserList;
    pickFriendCont.pickFriendCallback = ^(NSArray* pickFriends){
        NSArray *oldArray = self.currentUserList;
        NSArray *newArray = pickFriends;
        NSArray *result = [FriendManager addUserList:newArray toOldUserList:oldArray];
        self.currentUserList = [NSMutableArray arrayWithArray:result];
        
        [self updateCollectionView];
    };
    [self.navigationController pushViewController:pickFriendCont animated:YES];
}

- (void)didDeleteAvatarOfUser:(PBUser *)pbUser
{
    PPDebug(@"delete user in tag detail");
    if([self.currentUserList containsObject:pbUser]){
        [self.currentUserList removeObject:pbUser];
    }
    [self updateCollectionView];
}

- (void)didClickOnOneUserAvatar:(PBUser *)pbUser
{
    FriendDetailController* friendDetailCont = [[FriendDetailController alloc]initWithUser:pbUser];
    [self.navigationController pushViewController:friendDetailCont animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView==self.delAlert && buttonIndex == 1)
    {
        PBUserTag *targetTag = [[TagManager sharedInstance] getTagWithTID:self.currentTag.tid];
        
        [[FriendService sharedInstance]deleteTag:targetTag callback:^(PBUserTag *retTag, NSError *error) {
            if(error == nil)
            {
                PPDebug(@"delete tag");
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
    if(alertView==self.backAlert && buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self checkTagName])
    {
        [self.textField resignFirstResponder];
        return YES;
    }
    
    return NO;
}

@end
