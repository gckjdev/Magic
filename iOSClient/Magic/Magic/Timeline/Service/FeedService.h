//
//  FeedService.h
//  BarrageClient
//
//  Created by pipi on 14/12/5.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "Barrage.pb.h"


@class Feed;

typedef void (^FeedListCallBackBlock) (NSArray *feedList, NSError* error);
typedef void (^FeedServiceCallBackBlock) (NSError* error);
typedef void (^CreateFeedCallBackBlock) (NSString* feedId, NSError* error);
typedef void (^ReplyFeedCallBackBlock) (NSString* feedActionId, NSError* error);
typedef void (^DeleteFeedActionCallBackBlock) (NSString* feedActionId, NSError* error);
typedef void (^DeleteFeedCallBackBlock) (NSString* feedId, NSError* error);
typedef void (^GetMyNewFeedListCallBackBlock)(PBMyNewFeedList* newFeed,NSError* error);
typedef void (^GetFeedByIdCallBackBlock)(PBFeed* feed,NSError* error);
typedef void (^ReadMyNewFeedCallBackBlock)(NSError* error);
typedef void (^GetUserFeedCallBackBlock)(NSArray *feedList, NSError *error);

@interface FeedService : CommonService<UIImagePickerControllerDelegate>

DEF_SINGLETON_FOR_CLASS(FeedService);


- (void)createFeedWithImage:(UIImage*)image
                       text:(NSString*)text
                    toUsers:(NSArray*)toUsers
                   callback:(CreateFeedCallBackBlock)callback;

- (void)replyFeed:(Feed*)feed
       feedAction:(PBFeedAction*)feedAction
         callback:(ReplyFeedCallBackBlock)callback;

- (void)getTimelineFeed:(NSString*)offsetFeedId callback:(FeedListCallBackBlock)callback;

- (void)deleteFeedAction:(NSString*)feedActionId feedId:(NSString*)feedId
                callback:(DeleteFeedActionCallBackBlock)callback;
- (void)deleteFeed:(NSString*)feedId
                callback:(DeleteFeedCallBackBlock)callback;

- (void)getUserFeed:(int)offset
           callback:(GetUserFeedCallBackBlock)callback;




- (void)testReplyFeed;

- (void)selectPhoto;
- (void)selectCamera;

#pragma mark MyNewFeed
-(void)getMyNewFeedList:(GetMyNewFeedListCallBackBlock)callback;
-(void)getFeedById:(NSString*)feedId
          callback:(GetFeedByIdCallBackBlock)callback;
-(void)readMyNewFeed:(NSString*)feedId
            callback:(ReadMyNewFeedCallBackBlock)callback;

@end
