//
//  FriendService.h
//  BarrageClient
//
//  Created by pipi on 14/12/5.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.pb.h"
#import "FriendManager.h"
#import "CommonService.h"
#import "Message.pb.h"

typedef void (^FriendListCallback) (PBUserFriendList* friendList, NSError* error);
typedef void (^TagListCallback) (PBUserTagList* tagList, NSError* error);
typedef void (^AddTagCallback) (PBUserTag* retTag, NSError* error);
typedef void (^DeleteTagCallback) (NSError* error);
typedef void (^AddFriendCallback) (NSError* error);
typedef void (^DeleteFriendCallbackBlock) (NSError* error);

@interface FriendService : CommonService

DEF_SINGLETON_FOR_CLASS(FriendService)

- (void)addTag:(PBUserTag*)tag callback:(AddTagCallback)callback;

// 添加用户到某个tag
- (void)addUsersToTag:(PBUserTag*)origTag
           addUserIds:(NSArray*)addUserIds
             callback:(AddTagCallback)callback;


// 从标签删除某个用户
- (void)removeUserFromTag:(PBUserTag*)origTag
             removeUserId:(NSString*)removeUserId
                 callback:(AddTagCallback)callback;

//在已有标签情况下，把新的userList更新到tag
- (void)updateUserTag:(PBUserTag*)originTag
       currentUserIds:(NSArray*)currentUserIds
             callback:(AddTagCallback)callback;

// 直接请求更新某个已有标签，也许不应该开放出来public。。。
//- (void)updateUserTag:(PBUserTag*)tag
//             callback:(AddTagCallback)callback;

- (void)deleteTag:(PBUserTag*)tag callback:(AddTagCallback)callback;
- (PBUserTagList*)getAllTags:(TagListCallback)callback;

- (PBUserFriendList*)getFriendList:(PBGetUserFriendListType)type callback:(FriendListCallback)callback;
- (void)addUserFriend:(PBAddUserFriendRequest*)pbRequest callback:(AddFriendCallback)callback;

//- (void)deleteUserFriend:(PBUser*)pbFriend callback:(DeleteFriendCallback)callback;
- (void)processUserFriendRequest:(PBProcessUserFriendRequest*)pbRequest callback:(AddFriendCallback)callback;

- (void)syncFriend:(FriendListCallback)callback;
- (PBUserFriendList*)getRequestFriendList:(FriendListCallback)callback;

- (void)testTags;
- (void)testFriends;

#pragma mark - Delete Friend
- (void)deleteFriend:(NSString*)userId addStatus:(int)addStatus
            callback:(DeleteFriendCallbackBlock)callback;


@end
