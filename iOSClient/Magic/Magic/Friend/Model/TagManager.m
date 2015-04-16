//
//  TagManager.m
//  BarrageClient
//
//  Created by pipi on 15/1/15.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "TagManager.h"
#import "ShareUserDBManager.h"
#import "StringUtil.h"
#import "FriendManager.h"

#define KEY_USER_TAG_LIST       @"KEY_USER_TAG_LIST"

@interface TagManager()

@property (nonatomic, retain) PBUserTagList* tagList;

@end

@implementation TagManager

IMPL_SINGLETON_FOR_CLASS(TagManager)

- (PBUserTagList*)loadTagListFromStroage
{
    NSData* data = [[[ShareUserDBManager sharedInstance] db] objectForKey:KEY_USER_TAG_LIST];
    if (data == nil){
        return nil;
    }
    
    PBUserTagList* list = [PBUserTagList parseFromData:data];
    self.tagList = list;
    return list;
}

- (void)storeTags:(PBUserTagList*)newTagList
{
    if (newTagList == nil){
        return;
    }
    
    NSData* data = [newTagList data];
    if (data == nil){
        return;
    }
    
    [[[ShareUserDBManager sharedInstance] db] setObject:data forKey:KEY_USER_TAG_LIST];
    
    self.tagList = newTagList;
}

- (PBUserTagList*)allTags
{
    if (self.tagList == nil){
        [self loadTagListFromStroage];
    }
    
    return self.tagList;
}

- (void)printTags
{
    PBUserTagList* list = [self allTags];
    PPDebug(@"<print tags> total %d tags", [list.tags count]);
    int i=0;
    for (PBUserTag* tag in list.tags){
        PPDebug(@"[%d] tag_id=%@, tag_name=%@", i, tag.tid, tag.name);
        i++;
    }
}

- (PBUserTag*)buildNewTag:(NSString*)name
{
    PBUserTagBuilder* builder = [PBUserTag builder];
    [builder setTid:[NSString GetUUID]];
    [builder setName:name];
    return [builder build];
}

- (PBUserTag*)updateTag:(PBUserTag*)originTag
            withNewName:(NSString*)name
{
    if ([name length] == 0){
        PPDebug(@"<updateTag> but name is empty or nil");
        return originTag;
    }
    
    if (originTag == nil){
        PPDebug(@"<updateTag> but origTag is nil");
        return nil;
    }
    
    PBUserTagBuilder* builder = [PBUserTag builder];
    [builder mergeFrom:originTag];
    [builder setName:name];    
    return [builder build];
}

- (BOOL)isTagNameExist:(NSString*)name
{
    PBUserTagList* list = [self allTags];
    if (list == nil){
        return NO;
    }
    
    for (PBUserTag* tag in list.tags){
        if ([tag.name isEqualToString:name ignoreCapital:YES]){
            return YES;
        }
    }
    
    return NO;
}

- (NSArray*)userListByTag:(PBUserTag*)inputTag
{
    NSMutableArray* userList = [NSMutableArray array];
    
    NSArray* userIdList = inputTag.userIds;
    NSArray* allFriends = [[FriendManager sharedInstance]friendList];
    for (NSString* userId in userIdList)
    {
        for(PBUser *userFriend in allFriends)
        {
            if([userFriend.userId isEqualToString:userId])
               [userList addObject:userFriend];
        }
    }
    
    return userList;
}

- (PBUserTag*)getTagWithTID:(NSString*)tid
{
    PBUserTagList *list = [self allTags];
    for(PBUserTag *tag in list.tags)
    {
        if([[tag tid] isEqualToString:tid])
            return tag;
    }
    PPDebug(@"No tag match tid: %@",tid);
    return nil;
}



- (BOOL)checkArray:(NSArray*)array belongToTag:(PBUserTag*)tag
{
    NSMutableArray* newArray = [NSMutableArray array];
    for(PBUser* user in array)
    {
        PBUser* newUser = [[FriendManager sharedInstance]getUserWithID:user.userId];
        [newArray addObject:newUser];
    }
    
    BOOL isBelongToTag = YES;
    NSArray* tagArray = [[TagManager sharedInstance]userListByTag:tag];
    for(PBUser* user in newArray)
    {
        if(![tagArray containsObject:user])
            isBelongToTag = NO;
    }
    for(PBUser* user in tagArray)
    {
        if(![newArray containsObject:user])
            isBelongToTag = NO;
    }
    
    return isBelongToTag;
}

//用于检查一个user array是否属于某个标签
- (PBUserTag*)checkOverTagsForArray:(NSArray*)array
{
    NSArray* tags = [[self allTags]tags];
    for(PBUserTag* tag in tags)
    {
        if([self checkArray:array belongToTag:tag])
            return tag;
    }
    
    return nil;
}

- (NSArray*)getTagWithUser:(PBUser*)user
{
    PBUserTagList *list = [self allTags];
    NSMutableArray *userTagList = [[NSMutableArray alloc]init];
    for(PBUserTag *tag in list.tags)
    {
//        if([[tag user] isEqualToString:tid])
        for (NSString *tempUserId in [tag userIds]) {
            if ([tempUserId isEqualToString:user.userId]) {
                [userTagList addObject:tag];
            }
        }

    }
    
    if (userTagList != nil && userTagList.count != 0) {
        return userTagList;
    }else{
        PPDebug(@"No tag match user: %@",user);
        return nil;
    }
}


@end
