//
//  Feed.h
//  BarrageClient
//
//  Created by pipi on 14/12/9.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Barrage.pb.h"

// to support webp
#define SD_WEBP         1

@interface Feed : NSObject<NSCoding>

@property (nonatomic, retain) PBFeedBuilder         *feedBuilder;


- (NSString*)feedId;
+ (Feed*)feedWithPBFeed:(PBFeed*)pbFeed;

@end
