//
//  NewFeedCollectionView.m
//  BarrageClient
//
//  Created by Teemo on 15/3/20.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "NewFeedCollectionView.h"
#import "UIViewUtils.h"
#import "NewFeedCollectionViewCell.h"
#import "NewFeedNumView.h"
#import "NewFeedSelectController.h"

#define REUSEIENTIFIER @"NewFeedCollectionViewCell"


#define ROW_CELL_COUNT      3.0f
#define CELL_PADDING        2.0f
#define SECTIONINSET        3.0f
#define CELL_WIDTH          ((kScreenWidth/ROW_CELL_COUNT)-(ROW_CELL_COUNT*CELL_INSET) - CELL_INSET)

@interface NewFeedCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>


@end

@implementation NewFeedCollectionView

+(instancetype)initWithNewFeed:(PBMyNewFeedList*)myNewFeedList
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    CGFloat width = (kScreenWidth - SECTIONINSET *(ROW_CELL_COUNT+ 1))/ROW_CELL_COUNT;
//    PPDebug(@"neng cell width %f screenwidth %f",width,kScreenWidth);
    flowLayout.itemSize = CGSizeMake(width,width);
    flowLayout.sectionInset = UIEdgeInsetsMake(SECTIONINSET, SECTIONINSET, SECTIONINSET, SECTIONINSET);
    
    NewFeedCollectionView* newFeedCollectionView = [[NewFeedCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    newFeedCollectionView.myNewFeedList = myNewFeedList;
    
    
    return newFeedCollectionView;
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

    self.backgroundColor = [UIColor whiteColor];
    
    self.dataSource=self;
    self.delegate=self;
 
    
    self.alwaysBounceVertical = YES;
    //注册Cell，必须要有
    [self registerClass:[NewFeedCollectionViewCell class] forCellWithReuseIdentifier:REUSEIENTIFIER];
    

}
-(void)updateData:(PBMyNewFeedList*)myNewFeedList
{
    _myNewFeedList = myNewFeedList;
    [self reloadData];
}
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return [_myNewFeedList.myFeeds count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(NewFeedCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    NewFeedCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSEIENTIFIER forIndexPath:indexPath];
    [cell updateView:_myNewFeedList.myFeeds[indexPath.row]];
    
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

    [self.actionDelegate didClickOnOneNewFeed:_myNewFeedList.myFeeds[indexPath.row]];
    [self reloadData];

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
