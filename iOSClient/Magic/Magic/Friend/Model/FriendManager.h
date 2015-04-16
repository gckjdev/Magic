//
//  FriendManager.h
//  BarrageClient
//
//  Created by pipi on 15/1/15.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CommonManager.h"
#import "User.pb.h"

@interface FriendManager : CommonManager

DEF_SINGLETON_FOR_CLASS(FriendManager)

- (void)storeFriendList:(PBUserFriendList*)newFriendList;
- (void)storeOnlyFriendList:(NSArray*)friendList;
- (void)storeRequestFriendList:(NSArray*)friendList requestNewCount:(int)requestNewCount;

- (void)printFriendList;

- (PBUserFriendList*)allList;
- (NSArray*)friendList;
- (NSArray*)requestFriendList;
- (int)requestNewCount;

- (void)deleteFriend:(NSString*)userId
           addStatus:(int)addStatus;

- (BOOL)isFriend:(NSString*)userId;
- (PBUser*)getUserWithID:(NSString*)userID;

- (NSArray*)filterUnknownUserFromUsers:(NSArray*)users;

#pragma mark --- static methods
//比较两个PBUser的数组是否相同
+(BOOL)compareUserArray:(NSArray*)arrayA withUserArray:(NSArray*)arrayB;

//输入一个userList，把每一个元素添加到现有的userList中（若已经有该user则跳过）
+(NSMutableArray*)addUserList:(NSArray*)addArray
                toOldUserList:(NSArray*)oldArray;

//输入一个userList，把每一个元素从现有的userList中删除（若无该user则跳过）
+(NSMutableArray*)removeUserList:(NSArray*)delArray
                 fromOldUserList:(NSArray*)oldArray;

//通过old array的所有userid，把新的array里面重复的过滤掉，返回剩余的新pbuser的数组
+(NSArray*)filterNewUserList:(NSArray*)newArray
             withOldUserList:(NSArray*)oldArray;

@end
