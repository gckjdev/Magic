//
//  FeedManager.m
//  BarrageClient
//
//  Created by pipi on 14/12/8.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "FeedManager.h"
#import "LevelDBManager.h"
#import "UserManager.h"
#import "User.pb.h"
#import "ShareUserDBManager.h"

#define KEY_USER_TIMELINE_FEED_LIST         @"KEY_USER_TIMELINE_FEED_LIST"
#define DB_USER_TIMELINE_FEED               @"DB_USER_TIMELINE_FEED"
#define KEY_CACHE_SHARE_TO_FRIEND           @"KEY_CACHE_SHARE_TO_FRIEND"

@interface FeedManager()

@property (strong, nonatomic) NSArray* userTimelineFeedList;

@end

@implementation FeedManager

IMPL_SINGLETON_FOR_CLASS(FeedManager);

- (id)init
{
    self = [super init];

    // TODO 未来多用户支持会有问题
    NSString* userId = [[UserManager sharedInstance] userId];
    NSString* dbName = [NSString stringWithFormat:@"%@_%@.db", DB_USER_TIMELINE_FEED, userId];
    _db = [[LevelDBManager defaultManager] db:dbName];
    return self;
}

- (NSArray*)userTimelineFeedList
{
    if (_userTimelineFeedList == nil){
        self.userTimelineFeedList = [self readUserTimelineFeedListFromCache];
    }
    
    return _userTimelineFeedList;
}

- (NSArray*)readUserTimelineFeedListFromCache
{
    NSArray* list = [_db reversedAllObjects];
    PPDebug(@"total %d feed load from cache", [list count]);
    return list;
}

- (void)storeUserTimelineFeedList:(NSArray*)pbFeedList
{
    int count = 0;
    for (PBFeed* pbFeed in pbFeedList){
        if (pbFeed.feedId){
            Feed* feed = [Feed feedWithPBFeed:pbFeed];
            [_db setObject:feed forKey:feed.feedId];
            count ++;
        }
    }
    
    PPDebug(@"<storeUserTimelineFeedList> total %d feed stored", count);
    
    NSArray* list = [self readUserTimelineFeedListFromCache];
    self.userTimelineFeedList = list;
}

// 从本地数据库读取并且更新到内存list
- (void)reloadLocalList
{
    NSArray* list = [self readUserTimelineFeedListFromCache];
    self.userTimelineFeedList = list;
}

- (void)addFeed:(PBFeed*)pbFeed
{
    if (pbFeed.feedId == nil){
        return;
    }
    
    Feed* feed = [Feed feedWithPBFeed:pbFeed];
    if (feed.feedId){
        [_db setObject:feed forKey:feed.feedId];
        [self reloadLocalList];
    }
}

- (void)updateFeedAction:(Feed*)feed action:(PBFeedAction*)action
{
    if (feed == nil || action == nil){
        PPDebug(@"<updateFeedAction> but feed is nil or action is nil");
        return;
    }
    
    [feed.feedBuilder addActions:action];
    [_db setObject:feed forKey:feed.feedId];
}

- (void)deleteFeed:(NSString*)feedId
{
    if (feedId){
        [_db removeKey:feedId];
        [self reloadLocalList];
    }
}

- (void)deleteFeedAction:(NSString*)feedId action:(NSString*)actionId
{
    Feed* feed = [_db objectForKey:feedId];
    if (feed == nil || [actionId length] == 0){
        PPDebug(@"<deleteFeedAction> but feed is nil or action is nil");
        return;
    }
    
    // find action
    NSMutableArray* feedActions = [feed.feedBuilder actions];
    PBFeedAction* actionFound = nil;
    for (PBFeedAction* action in feedActions){
        if ([action.actionId isEqualToString:actionId]){
            actionFound = action;
            break;
        }
    }
    if (actionFound){
        
        // remove action
        [[feed.feedBuilder actions] removeObject:actionFound];
        
        // update
        [_db setObject:feed forKey:feed.feedId];

        // TODO check if needed
        [self reloadLocalList];
    }
}


- (NSUInteger)totalTimelineCount
{
    NSUInteger count = [self.userTimelineFeedList count];
    return count;
}

#pragma mark --- Share To Friend Cache Methods

- (BOOL)hadShareToFriendsCache
{
    NSArray* array = [self getShareToFriendsCache];
    if([array count]!=0)
        return YES;
    else
        return NO;
}

- (NSArray*)getShareToFriendsCache
{
    NSData* data = [[[ShareUserDBManager sharedInstance] db] objectForKey:KEY_CACHE_SHARE_TO_FRIEND];
    if (data == nil){
        return nil;
    }
    
    PBUserFriendList* list = [PBUserFriendList parseFromData:data];
    
    //every object is a pbuser class
    NSArray* friendList = [list friends];
    
    return friendList;
}

- (void)clearShareToFriendsCache
{
    [[[ShareUserDBManager sharedInstance]db] removeKey:KEY_CACHE_SHARE_TO_FRIEND];
}

- (void)setShareToFriendsCache:(NSArray*)friends
{
    if([friends count] == 0)
        return;
    
    PBUserFriendListBuilder* builder = [[PBUserFriendListBuilder alloc]init];
    [builder setFriendsArray:friends];
    
    PBUserFriendList* friendList = [builder build];
    
    NSData* data = [friendList data];
    if(data == nil)
        return;

    [[[ShareUserDBManager sharedInstance] db] setObject:data forKey:KEY_CACHE_SHARE_TO_FRIEND];
}

#pragma mark - Feed Play Index Management

- (void)updateFeedPlayIndex:(NSString*)feedId playIndex:(NSUInteger)playIndex
{
    PPDebug(@"<updateFeedPlayIndex> feedId=%@ playIndex=%d", feedId, playIndex);
    [[[ShareUserDBManager sharedInstance] dbForFeedPlayIndex] setObject:@(playIndex) forKey:feedId];
}

- (NSUInteger)getFeedCurrentPlayIndex:(NSString*)feedId
{
    return [[[[ShareUserDBManager sharedInstance] dbForFeedPlayIndex] objectForKey:feedId] intValue];
}


@end
