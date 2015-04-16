//
//  UserGroupManager.m
//  BarrageClient
//
//  Created by HuangCharlie on 3/17/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "UserGroupManager.h"
#import "ShareUserDBManager.h"
#import "StringUtil.h"
#import "UserManager.h"

#define KEY_CACHE_USER_GROUPS                   @"KEY_CACHE_USER_GROUPS"

@implementation UserGroupManager

IMPL_SINGLETON_FOR_CLASS(UserGroupManager)

- (BOOL)hadGroupsCache
{
    NSArray* array = [self getGroupsCache];
    if([array count]!=0)
        return YES;
    else
        return NO;
}
- (NSArray*)getGroupsCache
{
    NSData* data = [[[ShareUserDBManager sharedInstance] db] objectForKey:KEY_CACHE_USER_GROUPS];
    if (data == nil){
        return nil;
    }
    
    PBUserGroupList* list = [PBUserGroupList parseFromData:data];
    
    //every object is a pbuser class
    NSArray* groupArray = [list groups];
    
    return groupArray;
}
- (void)clearGroupsCache
{
    [[[ShareUserDBManager sharedInstance]db] removeKey:KEY_CACHE_USER_GROUPS];
}
- (void)setGroupsCache:(NSArray*)groups
{
    if([groups count] == 0)
        return;
    
    PBUserGroupListBuilder* builder = [[PBUserGroupListBuilder alloc]init];
    [builder setGroupsArray:groups];
    PBUserGroupList* groupList = [builder build];
    
    NSData* data = [groupList data];
    if(data == nil)
        return;
    
    [[[ShareUserDBManager sharedInstance] db] setObject:data
                                                 forKey:KEY_CACHE_USER_GROUPS];
}


- (void)updateGroupListWithGroup:(PBUserGroup*)group
{
    if(group == nil) return;
    //通过groupID，要不替换，要不新增
    NSInteger replaceIndex = -1;
    for(NSInteger index = 0; index < [[self getGroupsCache]count]; index++)
    {
        PBUserGroup* g = [[self getGroupsCache]objectAtIndex:index];
        if(g.groupId == group.groupId)
        {
            replaceIndex = index;
        }
    }

    NSMutableArray* groupArr = [NSMutableArray arrayWithArray:[self getGroupsCache]];
    if(replaceIndex == -1){
        [groupArr addObject:group];
    }
    else{
        [groupArr replaceObjectAtIndex:replaceIndex withObject:group];
    }
    
    [self clearGroupsCache];
    [self setGroupsCache:groupArr];
}

//TODO:
//need more testing, maybe should be divided into certain sub methods
- (PBUserGroup*)updateGroup:(PBUserGroup*)group
                  withUsers:(NSArray*)users
                  occurence:(BOOL)occur
                  rejection:(BOOL)rejec
                currentDate:(NSString*)date;
{
    PBUserGroupBuilder* builder = [[PBUserGroupBuilder alloc]init];;
    if(group == nil){
        [builder setGroupId:[NSString GetUUID]];
        [builder setOccurence:0];
        [builder setRejection:0];
    }
    else{
        builder = [builder mergeFrom:group];
    }
    
    if(users!=nil && [users count]!=0)
        [builder setUsersArray:users];
    
    SInt32 date_int32 = [date intValue];
    if(occur){
        [builder setOccurence:(group.occurence+1)];
        [builder setLastOccurenceDate:date_int32];
    }
    if(rejec){
        [builder setRejection:(group.rejection+1)];
        [builder setLastRejectionDate:date_int32];
    }
    
    PBUserGroup* g = [builder build];
    return g;
}

@end
