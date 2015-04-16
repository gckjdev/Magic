//
//  NewFeedCollectionViewCell.h
//  BarrageClient
//
//  Created by Teemo on 15/3/20.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Barrage.pb.h"

@interface NewFeedCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) PBMyNewFeed   *myNewFeed;
-(void)updateView:(PBMyNewFeed*)myNewFeed;
@end
