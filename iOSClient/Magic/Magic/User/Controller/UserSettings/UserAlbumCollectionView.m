//
//  UserAlbumCollectionView.m
//  BarrageClient
//
//  Created by Teemo on 15/3/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//


#define ROW_CELL_COUNT      3.0f
#define CELL_PADDING        2.0f
#define SECTIONINSET        3.0f
#define CELL_WIDTH          ((kScreenWidth/ROW_CELL_COUNT)-(ROW_CELL_COUNT*CELL_INSET) - CELL_INSET)

#define REUSEIENTIFIER @"AlbumCollectionViewCell"

#import "UserAlbumCollectionView.h"
#import "UIViewUtils.h"
#import "AlbumCollectionViewCell.h"


@interface UserAlbumCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property (nonatomic,strong) NSArray   *feeds;

@end
@implementation UserAlbumCollectionView
+(instancetype)initWithFeeds:(NSArray*)feeds
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGFloat width = (kScreenWidth - SECTIONINSET *(ROW_CELL_COUNT+ 1))/ROW_CELL_COUNT;
    //    PPDebug(@"neng cell width %f screenwidth %f",width,kScreenWidth);
    flowLayout.itemSize = CGSizeMake(width,width);
    flowLayout.sectionInset = UIEdgeInsetsMake(SECTIONINSET, SECTIONINSET, SECTIONINSET, SECTIONINSET);
    
    
    UserAlbumCollectionView *collectionView = [[UserAlbumCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    collectionView.feeds = feeds;
    return collectionView;
}

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
- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
{
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initView];
    }
    
    return self;
}
-(void)initView{
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.dataSource=self;
    self.delegate=self;
    
//    self.alwaysBounceVertical = YES;
    //注册Cell，必须要有
    [self registerClass:[AlbumCollectionViewCell class] forCellWithReuseIdentifier:REUSEIENTIFIER];
}

-(void)updateViewWithData:(NSArray*)feeds
{
    
    _feeds = feeds;
    [self reloadData];
}
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return [_feeds count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(AlbumCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AlbumCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSEIENTIFIER forIndexPath:indexPath];
    [cell updateViewWithData:_feeds[indexPath.row]];
    
    
    return cell;
}


#pragma mark --UICollectionViewDelegateFlowLayout


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return SECTIONINSET;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return SECTIONINSET;
}
#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.actionDelegate didClickFeed:_feeds[indexPath.row]];
    [self reloadData];
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
