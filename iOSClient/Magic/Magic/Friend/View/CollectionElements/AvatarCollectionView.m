//
//  AvatarCollectionView.m
//  BarrageClient
//
//  Created by HuangCharlie on 2/5/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "AvatarCollectionView.h"
#import "UIViewUtils.h"
#import "UserAvatarView.h"
#import <Masonry.h>
#import "TagManager.h"
#import "UserManager.h"
#import "FriendService.h"
#import "FriendManager.h"
#import "FriendAvatarCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "FooterCollectionReusableView.h"
#import "AvatarsCollectionViewLayout.h"

@interface AvatarCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AvatarViewDelegate>
{
    
}

@property (nonatomic,assign) AvatarCollectionViewMode mode;

@end


@implementation AvatarCollectionView

+ (AvatarsCollectionViewLayout*)flowLayoutWithHeaderSize:(CGSize)headerViewSize
                                             footerSize:(CGSize)footerSize
{
    AvatarsCollectionViewLayout *flowLayout = [[AvatarsCollectionViewLayout alloc]init];
    flowLayout.headerReferenceSize = headerViewSize;
    flowLayout.footerReferenceSize = footerSize;
    
    flowLayout.itemSize = CGSizeMake(CELL_AVATAR_HEIGHT,CELL_AVATAR_HEIGHT+CELL_NAME_HEIGHT+CELL_PADDING);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, COMMON_MARGIN_OFFSET_X, COMMON_MARGIN_OFFSET_Y, COMMON_MARGIN_OFFSET_X);
    
    return flowLayout;
}

+ (UIView*)setHeaderView
{
    UIView* headerView = [[UIView alloc]init];
    
    headerView.backgroundColor = BARRAGE_BG_COLOR;
    
    return headerView;
}

+ (UIView*)setFooterView
{
    UIView* footerView = [[UIView alloc]init];
    
    footerView.backgroundColor = BARRAGE_BG_COLOR;
    
    return footerView;
}


- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
             presentationMode:(AvatarCollectionViewMode)mode
                   headerView:(UIView*)headerView
                   footerView:(UIView*)footerView
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    self.mode = mode;
    self.header = headerView;
    self.footer = footerView;
    
    //register cell class for reuse
    [self setBackgroundColor:[UIColor whiteColor]];
    [self registerClass:[FriendAvatarCollectionViewCell class]
             forCellWithReuseIdentifier:@"CollectionAddCell"];
    [self registerClass:[FriendAvatarCollectionViewCell class]
             forCellWithReuseIdentifier:@"CollectionDelCell"];
    [self registerClass:[FriendAvatarCollectionViewCell class]
             forCellWithReuseIdentifier:@"CollectionCell"];
    [self registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeader"];
    [self registerClass:[FooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionFooter"];
    
    self.dataSource = self;
    self.delegate = self;
    
    return self;
}

- (void)loadPbUserList:(NSArray*)pbuserList
{
    //change data
    self.pbUserList = pbuserList;
    [self reloadData];
}

- (void)backToEditMode
{
    if(self.mode == DeleteMode)
        self.mode = EditMode;
    [self loadPbUserList:self.pbUserList];
}

#pragma mark --- getter of count and pb user
- (NSUInteger)getFriendByTagCount
{
    return [self.pbUserList count];
}

- (PBUser*)getUser:(NSUInteger)row
{
    NSUInteger friendByTagCount = [self.pbUserList count];
    if (row >= friendByTagCount)
        return nil;
    else
        return [self.pbUserList objectAtIndex:row];
}


#pragma mark --- delegates
//(data source required) section的数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//(data source required) 每个section中item的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section != 0)
        return 0;
    
    if(self.mode == EditMode || self.mode == DeleteMode){
        //+2 是为了添加两个button，加号和减号
        return [self getFriendByTagCount]+2;
    }
    else{
        return [self getFriendByTagCount];
    }
}

//(data source required) 每个item显示的内容
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendAvatarCollectionViewCell *cell;
    
    if(indexPath.row<[self getFriendByTagCount])
    {    //头像
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
        
        PBUser *pbUser = [self getUser:indexPath.row];
        [cell updateWithUser:pbUser superViewController:self];
        if(self.mode == DeleteMode)
        {
            //不允许删除自己
            if([pbUser userId] == [[[UserManager sharedInstance]pbUser]userId])                [cell hideDeleteImg];
            else
                [cell showDeleteImg];
            
            [cell setShaking];
        }
        else
        {
            [cell hideDeleteImg];
        }
    }
    //加号
    else if(indexPath.row == [self getFriendByTagCount])
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionAddCell" forIndexPath:indexPath];
        if([cell.contentView.subviews count] == 0)
            [cell updateWithAddButt];
    }
    //减号
    else if(indexPath.row == [self getFriendByTagCount]+1)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionDelCell" forIndexPath:indexPath];
        if([cell.contentView.subviews count] == 0)
            [cell updateWithDelButt];
    }
    else
        cell = nil;
    
    return cell;

}

//(data source optional) 补充视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"CollectionHeader" forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor whiteColor];
    
    FooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:@"CollectionFooter" forIndexPath:indexPath];
    footerView.backgroundColor = [UIColor whiteColor];
    
    if (kind == UICollectionElementKindSectionHeader){
        [headerView addSubview:self.header];
        [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left);
            make.right.equalTo(headerView.mas_right);
            make.top.equalTo(headerView.mas_top);
            make.bottom.equalTo(headerView.mas_bottom);
        }];
        return headerView;
    }
    else{
        [footerView addSubview:self.footer];
        [self.footer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView.mas_left);
            make.right.equalTo(footerView.mas_right);
            make.top.equalTo(footerView.mas_top);
            make.bottom.equalTo(footerView.mas_bottom);
        }];
        return footerView;
    }
}

//（delegate optional）选中某一个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //adding
    if(indexPath.row == [self getFriendByTagCount])
    {
        PPDebug(@"press add button in avatar collection view!");
        [self.actionDelegate didClickAddIcon];
    }
    //deleting
    else if(indexPath.row == [self getFriendByTagCount]+1)
    {
        PPDebug(@"press delete button in avatar collection view!");
        if(self.mode == EditMode)
            self.mode = DeleteMode;
        else
            self.mode = EditMode;
        
        [self loadPbUserList:self.pbUserList];
    }
    //click while deleting
    else if(indexPath.row < [self getFriendByTagCount])
    {
        PPDebug(@"press avatar in avatar collection view!");
        if(self.mode == DeleteMode)
        {
            PBUser* user = [self getUser:indexPath.row];
            [self.actionDelegate didDeleteAvatarOfUser:user];
        }
        else
        {
            PBUser* user = [self getUser:indexPath.row];
            [self.actionDelegate didClickOnOneUserAvatar:user];
        }
    }
}

- (void)didClickOnAvatarView:(UserAvatarView *)avatarView
{
    if(self.mode == DeleteMode)
    {
        NSString *userID = avatarView.user.userId;
        PBUser *user = [[FriendManager sharedInstance]getUserWithID:userID];
        [self.actionDelegate didDeleteAvatarOfUser:user];
    }
    else
    {
        [UserAvatarView clickAvatarAction:avatarView.user];
    }
}



@end
