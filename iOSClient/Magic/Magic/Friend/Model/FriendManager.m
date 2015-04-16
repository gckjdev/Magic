//
//  FriendManager.m
//  BarrageClient
//
//  Created by pipi on 15/1/15.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "FriendManager.h"
#import "ShareUserDBManager.h"
#import "UserManager.h"

#define KEY_USER_FRIEND_LIST            @"KEY_USER_FRIEND_LIST"

@interface FriendManager ()

@property (nonatomic, strong) PBUserFriendList* userFriendList;

@end

@implementation FriendManager

IMPL_SINGLETON_FOR_CLASS(FriendManager)

- (PBUserFriendList*)loadFriendListFromStroage
{
    NSData* data = [[[ShareUserDBManager sharedInstance] db] objectForKey:KEY_USER_FRIEND_LIST];
    if (data == nil){
        return nil;
    }
    
    PBUserFriendList* list = [PBUserFriendList parseFromData:data];
    self.userFriendList = list;
    return list;
}

- (void)storeFriendList:(PBUserFriendList*)newFriendList
{
    if (newFriendList == nil){
        return;
    }
    
    NSData* data = [newFriendList data];
    if (data == nil){
        return;
    }
    
    [[[ShareUserDBManager sharedInstance] db] setObject:data forKey:KEY_USER_FRIEND_LIST];
    
    self.userFriendList = newFriendList;
}

- (void)storeOnlyFriendList:(NSArray*)friendList
{
    PBUserFriendList* current = [self loadFriendListFromStroage];
    
    PBUserFriendListBuilder* builder = [PBUserFriendList builder];
    if (current){
        builder = [PBUserFriendList builderWithPrototype:current];
    }
    
    [builder setFriendsArray:friendList];
    
    [self storeFriendList:[builder build]];
}

- (void)storeRequestFriendList:(NSArray*)friendList requestNewCount:(int)requestNewCount
{
    PBUserFriendList* current = [self loadFriendListFromStroage];
    
    PBUserFriendListBuilder* builder = [PBUserFriendList builder];
    if (current){
        builder = [PBUserFriendList builderWithPrototype:current];
    }
    
    [builder setRequestNewCount:requestNewCount];
    [builder setRequestFriendsArray:friendList];
    
    [self storeFriendList:[builder build]];
}

- (void)deleteFriend:(NSString*)userId
           addStatus:(int)addStatus
{
    if ([userId length] == 0){
        return;
    }
    
    PBUserFriendList* list = [self allList];
    if (list == nil){
        return;
    }
    
    PBUserFriendListBuilder* builder = [PBUserFriendList builderWithPrototype:list];
    
    // choose the right friends list by addStatus
    NSMutableArray* friendList = nil;
    if (addStatus == FriendAddStatusTypeReqStatusNone ||
        addStatus == FriendAddStatusTypeReqAccepted ){
        friendList = [builder friends];
    }
    else{
        friendList = [builder requestFriends];
    }

    // delete friend from list
    PBUser* deletedFriend = nil;
    for (PBUser* friend in friendList){
        if ([friend.userId isEqualToString:userId]){
            deletedFriend = friend;
            break;
        }
    }
    [friendList removeObject:deletedFriend];
    
    // store data locally
    [self storeFriendList:[builder build]];
}

- (void)printFriendList
{
    PBUserFriendList* list = [self loadFriendListFromStroage];
    PPDebug(@"<print friend list> total %d friends", [list.friends count]);
    int i=0;
    for (PBUser* user in list.friends){
        PPDebug(@"[%d] userId=%@, nick=%@", i, user.userId, user.nick);
        i++;
    }
}

- (PBUserFriendList*)getUserFriendList
{
    if (self.userFriendList != nil){
        return self.userFriendList;
    }
    
    return [self loadFriendListFromStroage];
}

- (PBUserFriendList*)allList
{
    return [self getUserFriendList];
}

- (NSArray*)friendList
{
    return [[self getUserFriendList] friends];
}

- (NSArray*)requestFriendList
{
    return [[self getUserFriendList] requestFriends];
}

- (int)requestNewCount
{
    return [[self getUserFriendList] requestNewCount];
}

- (BOOL)isFriend:(NSString*)userId
{
    if ([userId length] == 0){
        return NO;
    }
    
    NSString* myUserId = [[UserManager sharedInstance] userId];
    if ([userId isEqualToString:myUserId]){
        return YES;
    }
    
    NSArray* friendList = [self friendList];
    for (PBUser* user in friendList){
        if ([user.userId isEqualToString:userId]){
            return YES;
        }
    }
    
    return NO;
}

-(PBUser*)getUserWithID:(NSString*)userID
{
    if ([userID length] == 0){
        return nil;
    }
    
    NSArray* friendList = [self friendList];
    for (PBUser* user in friendList){
        if ([user.userId isEqualToString:userID]){
            return user;
        }
    }
    return nil;
}

//过滤朋友列表里面没有的人，同时也可以过滤自身
-(NSArray*)filterUnknownUserFromUsers:(NSArray*)users
{
    NSMutableArray* outputArr = [NSMutableArray array];
    
    for(PBUser* user in users)
    {
        if(nil==[self getUserWithID:user.userId])
            continue;//查无此人。。。所以跳过。。
        else{
            [outputArr addObject:[self getUserWithID:user.userId]];
        }
    }
    return outputArr;
}


#pragma mark --- static methods
+(BOOL)compareUserArray:(NSArray*)arrayA withUserArray:(NSArray*)arrayB
{
    //compare two list
    BOOL isEqual = YES;
    for(PBUser* user in arrayA)
    {
        if(![arrayB containsObject:user])
            isEqual = NO;
    }
    for(PBUser* user in arrayB)
    {
        if(![arrayA containsObject:user])
            isEqual = NO;
    }
    
    return isEqual;
}

//输入一个userList，把每一个元素添加到现有的userList中（若已经有该user则跳过）
+(NSMutableArray*)addUserList:(NSArray*)addArray
                toOldUserList:(NSArray*)oldArray
{
    NSMutableArray* resultArray = [NSMutableArray arrayWithArray:oldArray];
    for(PBUser* user in addArray)
    {
        if(![oldArray containsObject:user])
            [resultArray addObject:user];
    }
    
    return resultArray;
}

//输入一个userList，把每一个元素从现有的userList中删除（若无该user则跳过）
+(NSMutableArray*)removeUserList:(NSArray*)delArray
                 fromOldUserList:(NSArray*)oldArray
{
    NSMutableArray* resultArray = [NSMutableArray arrayWithArray:oldArray];
    for(PBUser* user in delArray)
    {
        if([oldArray containsObject:user])
            [resultArray removeObject:user];
    }
    
    return resultArray;
}

//通过old array的所有userid，把新的array里面重复的过滤掉，返回剩余的新pbuser的数组
+(NSArray*)filterNewUserList:(NSArray*)newArray
             withOldUserList:(NSArray*)oldArray
{
    NSMutableArray *filteredUserList = [[NSMutableArray alloc]init];
    for(PBUser* newUser in newArray)
    {
        BOOL flag = YES;
        for(PBUser *oldUser in oldArray){
            if([newUser.userId isEqualToString:oldUser.userId])
                flag = NO;
        }
        if(flag == YES)
            [filteredUserList addObject:newUser];
    }
    
    return filteredUserList;
}



@end
