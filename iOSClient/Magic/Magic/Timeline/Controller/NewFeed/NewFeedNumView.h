//
//  NewFeedNumView.h
//  BarrageClient
//
//  Created by Teemo on 15/3/25.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Barrage.pb.h"

@interface NewFeedNumView : UIView
+(instancetype)initWithMyNewFeed:(PBMyNewFeed*)newFeed;
-(void)updateView:(PBMyNewFeed*)newFeed;
@end
