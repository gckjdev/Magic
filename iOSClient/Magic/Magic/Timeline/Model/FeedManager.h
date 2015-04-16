//
//  FeedManager.h
//  BarrageClient
//
//  Created by pipi on 14/12/8.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "CommonManager.h"
#import "Barrage.pb.h"
#import "APLevelDB.h"
#import "Feed.h"

@interface FeedManager : CommonManager
{
    APLevelDB* _db;
}

DEF_SINGLETON_FOR_CLASS(FeedManager);


- (NSArray*)userTimelineFeedList;
- (void)storeUserTimelineFeedList:(NSArray*)pbFeedList;
- (void)addFeed:(PBFeed*)feed;
- (void)updateFeedAction:(Feed*)feed action:(PBFeedAction*)action;
- (void)deleteFeed:(NSString*)feedId;
- (void)deleteFeedAction:(NSString*)feedId action:(NSString*)actionId;
- (NSUInteger)totalTimelineCount;


- (BOOL)hadShareToFriendsCache;
- (NSArray*)getShareToFriendsCache;
- (void)clearShareToFriendsCache;
- (void)setShareToFriendsCache:(NSArray*)friends;


- (void)updateFeedPlayIndex:(NSString*)feedId playIndex:(NSUInteger)playIndex;
- (NSUInteger)getFeedCurrentPlayIndex:(NSString*)feedId;


@end
