//
//  UserAlbumCollectionView.h
//  BarrageClient
//
//  Created by Teemo on 15/3/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Barrage.pb.h"



@protocol UserAlbumCollectionViewDelegate <NSObject>

@optional
-(void)didClickFeed:(PBFeed*)feed;
@end


@interface UserAlbumCollectionView : UICollectionView


+(instancetype)initWithFeeds:(NSArray*)feeds;
@property (nonatomic,assign) id<UserAlbumCollectionViewDelegate> actionDelegate;


-(void)updateViewWithData:(NSArray*)feeds;
@end
