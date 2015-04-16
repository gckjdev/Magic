//
//  ShareToWhichFriendViewController.m
//  BarrageClient
//
//  Created by HuangCharlie on 1/25/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "ShareToWhichFriendViewController.h"
#import "HYCScrollView.h"
#import "HYCTagView.h"
#import "AvatarCollectionView.h"
#import "UIViewUtils.h"
#import "PPDebug.h"
#import <Masonry.h>
#import "TagManager.h"
#import "FriendService.h"
#import "FriendManager.h"
#import "PickFriendListViewController.h"
#import "UIViewController+Utils.h"
#import "UserManager.h"
#import "FeedManager.h"
#import "UserTimelineFeedController.h"


#define ONEROW_SCROLL_VIEW_HEIGHT 78
#define TWOROW_SCROLL_VIEW_HEIGHT 128
#define MAX_SCROLL_VIEW_HEIGHT 178

@interface ShareToWhichFriendViewController ()<HYCTagViewDelegate,AvatarCollectionViewDelegate>
{
    
}

@property (nonatomic,strong) HYCScrollView *tagScrollView;
@property (nonatomic,strong) UILabel* label;
@property (nonatomic,strong) AvatarCollectionView *avatarCollectionView;

@end

@implementation ShareToWhichFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    
    [self setTitle:@"分享给谁"];
    [self.view setBackgroundColor:BARRAGE_BG_COLOR];
    [self addRightButtonWithTitle:@"确定" target:self action:@selector(clickSure:)];
    
    if(self.shareToList == nil)
        self.shareToList = [[NSMutableArray alloc]init];
    
    if([[FeedManager sharedInstance]hadShareToFriendsCache])
    {   //若有缓存，则读取leveldb中的缓存。注意从缓存读取的pbuser不是friendlist的pbuser,应该利用userID重新导入。
        NSArray* array = [[FeedManager sharedInstance]getShareToFriendsCache];
        for(PBUser* chachedUser in array)
        {
            PBUser* user = [[FriendManager sharedInstance] getUserWithID:chachedUser.userId];
            if (user){
                [self.shareToList addObject:user];
            }
        }
    }
    
    //add views
    [self addTagScrollView];
    [self addAvatarCollectionView];

    //update views with data
    [self updateTagScrollView];
    [self updateAvatarCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickSure:(id)sender
{
    //把分享给谁的列表穿回去
    EXECUTE_BLOCK(self.callBack,[self getFinalShareToList]);
  
}

#pragma mark --- getter and setter of tag and count
- (PBUserTag*)getTag:(NSUInteger)count
{
    PBUserTag *userTag = [[[TagManager sharedInstance] allTags] tagsAtIndex:count];
    
    return userTag;
}

- (NSInteger)getTagCount
{
    NSInteger tagCount = [[[[TagManager sharedInstance] allTags] tags] count];
    return tagCount;
}

- (NSMutableArray*)getFinalShareToList
{
    NSMutableArray *finalShareToList = [NSMutableArray arrayWithObject:[[UserManager sharedInstance]pbUser]];
    
    for(PBUser* user in self.shareToList){
        [finalShareToList addObject:user];
    }
    
    [[FeedManager sharedInstance]setShareToFriendsCache:self.shareToList];
    
    return finalShareToList;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark --- add views
- (void)addTagScrollView
{
    CGRect visibleRect = CGRectMake(0, 0, self.view.frame.size.width, MAX_SCROLL_VIEW_HEIGHT);
    
    self.tagScrollView = [[HYCScrollView alloc]initWithFrame:visibleRect];
    [self.view addSubview:self.tagScrollView];
}

- (void)addAvatarCollectionView
{
    CGSize hSize = CGSizeMake(self.view.frame.size.width, 50);
    CGSize fSize = CGSizeMake(self.view.frame.size.width, 1);
    UICollectionViewFlowLayout *layout = [AvatarCollectionView flowLayoutWithHeaderSize:hSize footerSize:fSize];
    
    //make customized header view
    UIView* hv = [AvatarCollectionView setHeaderView];
    NSString* str = [NSString stringWithFormat:@"已选用户 (%lu)",(unsigned long)self.shareToList.count];
    self.label = [[UILabel alloc]init];
    self.label.backgroundColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.text = str;
    self.label.textColor = BARRAGE_LABEL_GRAY_COLOR;
    self.label.font = BARRAGE_LABEL_FONT;
    self.label.numberOfLines = 0;
    UIView* holder = [[UIView alloc]init];
    holder.backgroundColor = [UIColor whiteColor];
    [hv addSubview:holder];
    [holder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(hv.mas_centerX);
        make.centerY.equalTo(hv.mas_centerY);
        make.width.equalTo(hv.mas_width);
        make.height.equalTo(hv.mas_height);
    }];
    [holder addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(holder.mas_centerX);
        make.centerY.equalTo(holder.mas_centerY);
        make.width.equalTo(holder.mas_width).offset(-2*COMMON_MARGIN_OFFSET_X);
        make.height.equalTo(holder.mas_height);
    }];
    
    UIView* fv = [AvatarCollectionView setFooterView];
    fv.hidden = YES;
    
    CGRect frame = CGRectMake(0, self.tagScrollView.frame.size.height, self.view.frame.size.width,self.view.frame.size.height-self.tagScrollView.frame.size.height);
    
    self.avatarCollectionView = [[AvatarCollectionView alloc]initWithFrame:frame collectionViewLayout:layout presentationMode:EditMode headerView:hv footerView:fv];
    
    //和事件有关的delegate委托给super controller；和数据有关的datasource不依赖super controller，内部封装；
    self.avatarCollectionView.actionDelegate = self;
    
    [self.view addSubview:self.avatarCollectionView];
}

- (void)updateTagScrollView
{
    CGRect visibleRect = CGRectMake(0, 0, self.view.frame.size.width, 0);
    //change scroll view frame with data
    NSArray* pbtagList = [[[TagManager sharedInstance]allTags]tags];
    NSUInteger rowCount = [HYCTagView getArrangedRowCountWithFrame:visibleRect andTags:pbtagList];
    if([pbtagList count]==0)
        visibleRect.size.height = 0;
    else if([pbtagList count]!=0 && rowCount==0)
        visibleRect.size.height = ONEROW_SCROLL_VIEW_HEIGHT;
    else if([pbtagList count]!=0 && rowCount == 1)
        visibleRect.size.height = TWOROW_SCROLL_VIEW_HEIGHT;
    else
        visibleRect.size.height = MAX_SCROLL_VIEW_HEIGHT;
    
    [self.tagScrollView setFrame:visibleRect];
    
    NSArray *viewArray = [HYCTagView createTagViewsWithFrame:visibleRect
                                                allPbTagList:pbtagList
                                               selectedUsers:self.shareToList
                                                    delegate:self];
    
    [self.tagScrollView updateScrollViewWithViewArray:viewArray];
}

- (void)updateAvatarCollectionView
{
    [self.avatarCollectionView setFrame:CGRectMake(0, self.tagScrollView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.tagScrollView.frame.size.height)];
    
    NSString* str = [NSString stringWithFormat:@"已选用户 (%lu)",(unsigned long)[[self getFinalShareToList]count]];
    self.label.text = str;
    
    [self.avatarCollectionView loadPbUserList:[self getFinalShareToList]];
    
    [self.avatarCollectionView setEaseInWithDuration:0.5];
}

#pragma mark --- scroll view delegate
-(void)didTapTag:(PBUserTag*)pbTag inStatus:(BOOL)isSelected
{
    PPDebug(@"press a tag in shareto");
    NSArray *tempArray = [[TagManager sharedInstance]userListByTag:pbTag];

    if(isSelected)
    {//若已经是选中状态，就把该tag的好友从sharetolist删除
        self.shareToList = [FriendManager removeUserList:tempArray
                                         fromOldUserList:self.shareToList];
    }
    else
    {//若是非选中状态，就把该tag的好友(无重复地)添加到sharetolist
        self.shareToList = [FriendManager addUserList:tempArray
                                        toOldUserList:self.shareToList];
    }
    
    [self updateTagScrollView];
    [self updateAvatarCollectionView];
}

-(void)didLongPressTag:(PBUserTag*)pbTag
{
    PPDebug(@"long press a tag in shareto");
    
}

#pragma mark --- collection view delegate
-(void)didClickAddIcon
{
    PPDebug(@"<sharetofriendcontroller> click add avatar");
    PickFriendListViewController *pickFriendCont = [[PickFriendListViewController alloc]init];
    pickFriendCont.originPickedArray = self.shareToList;
    pickFriendCont.pickFriendCallback = ^(NSArray* pickFriends){
        //过滤
        self.shareToList = [FriendManager addUserList:pickFriends
                                        toOldUserList:self.shareToList];
        
        //更新view
        [self updateTagScrollView];
        [self updateAvatarCollectionView];
    };
    [self.navigationController pushViewController:pickFriendCont animated:YES];
}

-(void)didDeleteAvatarOfUser:(PBUser *)pbUser
{
    PPDebug(@"<sharetofriendcontroller> delete avatar");
    if(pbUser!=nil)
        [self.shareToList removeObject:pbUser];
    
    //更新view
    [self updateTagScrollView];
    [self updateAvatarCollectionView];
}

-(void)didClickOnOneUserAvatar:(PBUser *)pbUser
{
    
}



@end
