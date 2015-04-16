//
//  AlbumCollectionViewCell.h
//  BarrageClient
//
//  Created by Teemo on 15/3/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Barrage.pb.h"

@interface AlbumCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) PBFeed   *myFeed;
-(void)updateViewWithData:(PBMyNewFeed*)feed;
@end
