//
//  NewFeedCollectionView.h
//  BarrageClient
//
//  Created by Teemo on 15/3/20.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "BCUIViewController.h"
#import "Barrage.pb.h"
@protocol NewFeedCollectionViewDelegate <NSObject>

@optional
-(void)didClickOnOneNewFeed:(PBMyNewFeed*)pbNewFeed;
@end

@interface NewFeedCollectionView : UICollectionView <NewFeedCollectionViewDelegate>

@property (nonatomic,strong) PBMyNewFeedList   *myNewFeedList;
+(instancetype)initWithNewFeed:(PBMyNewFeedList*)myNewFeedList;
- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout;
-(void)updateData:(PBMyNewFeedList*)myNewFeedList;


@property (nonatomic,assign) id<NewFeedCollectionViewDelegate> actionDelegate;
@end
