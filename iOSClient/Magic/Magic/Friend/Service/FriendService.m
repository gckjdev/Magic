//
//  FriendService.m
//  BarrageClient
//
//  Created by pipi on 14/12/5.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "FriendService.h"
#import "TagManager.h"
#import "FriendManager.h"


@implementation FriendService

IMPL_SINGLETON_FOR_CLASS(FriendService)

#pragma mark - Tag Methods

- (void)addTag:(PBUserTag*)tag callback:(AddTagCallback)callback
{
    if (tag == nil){
        EXECUTE_BLOCK(callback, nil, [self errorInput]);
        return;
    }
    
    if ([[TagManager sharedInstance] isTagNameExist:tag.name]){
        NSError* error = [NSError errorWithDomain:@"" code:PBErrorErrorUserTagNameDuplicate userInfo:nil];
        EXECUTE_BLOCK(callback, nil, error);
        return;
    }
    
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBAddUserTagRequestBuilder* reqBuilder = [PBAddUserTagRequest builder];
    [reqBuilder setTag:tag];
    
    // set request
    [builder setAddUserTagRequest:[reqBuilder build]];
    
    [self sendRequest:PBMessageTypeMessageAddUserTag
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBUserTagList* tagList = response.addUserTagResponse.tags;
                 if (error == nil && tagList != nil){
                     // success
                     [[TagManager sharedInstance] storeTags:tagList];
                 }
                 else{
                     // no user data, error here
                 }
                 
                 EXECUTE_BLOCK(callback, tag, error);
                 
             } isPostError:YES];
}

- (void)addUsersToTag:(PBUserTag*)origTag
           addUserIds:(NSArray*)addUserIds
             callback:(AddTagCallback)callback
{
    if (origTag == nil){
        EXECUTE_BLOCK(callback, nil, [self errorInput]);
        return;
    }
    
    PBUserTagBuilder* tagBuilder = [PBUserTag builderWithPrototype:origTag];
    for (NSString* userId in addUserIds){
        [tagBuilder addUserIds:userId];
    }
    
    PBUserTag* tag = [tagBuilder build];
    [self updateUserTag:tag
               callback:callback];
}

- (void)removeUserFromTag:(PBUserTag*)origTag
             removeUserId:(NSString*)removeUserId
                 callback:(AddTagCallback)callback
{
    if (origTag == nil){
        EXECUTE_BLOCK(callback, nil, [self errorInput]);
        return;
    }
    
    PBUserTagBuilder* tagBuilder = [PBUserTag builderWithPrototype:origTag];
    if ([tagBuilder.userIds containsObject:removeUserId] == NO){
        // remove user not found in TAG
        EXECUTE_BLOCK(callback, nil, [self errorInput]);
        return;
    }

    [tagBuilder.userIds removeObject:removeUserId];
    
    PBUserTag* tag = [tagBuilder build];
    [self updateUserTag:tag
               callback:callback];
}

- (void)updateUserTag:(PBUserTag*)originTag
       currentUserIds:(NSArray*)currentUserIds
             callback:(AddTagCallback)callback
{
    if (originTag == nil){
        EXECUTE_BLOCK(callback, nil, [self errorInput]);
        return;
    }
    
    PBUserTagBuilder* tagBuilder = [PBUserTag builderWithPrototype:originTag];
    
    //clear before adding new
    [tagBuilder clearUserIds];
    
    //add current ids
    for(NSString* Id in currentUserIds)
        [tagBuilder addUserIds:Id];
    
    PBUserTag* tag = [tagBuilder build];
    [self updateUserTag:tag
               callback:callback];
}


- (void)updateUserTag:(PBUserTag*)tag
             callback:(AddTagCallback)callback

{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBAddUserTagRequestBuilder* reqBuilder = [PBAddUserTagRequest builder];
    [reqBuilder setTag:tag];
    
    // set request
    [builder setAddUserTagRequest:[reqBuilder build]];
    
    [self sendRequest:PBMessageTypeMessageAddUserTag
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBUserTagList* tagList = response.addUserTagResponse.tags;
                 if (error == nil && tagList != nil){
                     // success
                     [[TagManager sharedInstance] storeTags:tagList];
                 }
                 else{
                     // no user data, error here
                 }
                 
                 EXECUTE_BLOCK(callback, tag, error);
                 
             } isPostError:YES];
    
}


- (void)deleteTag:(PBUserTag*)tag callback:(AddTagCallback)callback
{
    if (tag == nil){
        EXECUTE_BLOCK(callback, nil, [self errorInput]);
        return;
    }
    
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBDeleteUserTagRequestBuilder* reqBuilder = [PBDeleteUserTagRequest builder];
    [reqBuilder setTag:tag];
    
    // set request
    [builder setDeleteUserTagRequest:[reqBuilder build]];
    
    [self sendRequest:PBMessageTypeMessageDeleteUserTag
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBUserTagList* tagList = response.deleteUserTagResponse.tags;
                 if (error == nil && tagList != nil){
                     // success
                     [[TagManager sharedInstance] storeTags:tagList];
                 }
                 else{
                     // no user data, error here
                 }
                 
                 EXECUTE_BLOCK(callback, tag, error);
                 
             } isPostError:YES];
}

- (PBUserTagList*)getAllTags:(TagListCallback)callback
{
    PBUserTagList* tagList = [[TagManager sharedInstance] allTags];
    
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBGetUserTagListRequestBuilder* reqBuilder = [PBGetUserTagListRequest builder];
    
    // set request
    [builder setGetUserTagListRequest:[reqBuilder build]];
    
    [self sendRequest:PBMessageTypeMessageGetUserTagList
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBUserTagList* tagList = response.getUserTagListResponse.tags;
                 if (error == nil && tagList != nil){
                     // success
                     [[TagManager sharedInstance] storeTags:tagList];
                 }
                 else{
                     // no user data, error here
                 }
                 
                 EXECUTE_BLOCK(callback, tagList, error);
                 
             } isPostError:YES];

    // return local cache firstly
    return tagList;
}

#pragma mark - Friend Methods

- (void)syncFriend:(FriendListCallback)callback
{
    BOOL needSync = NO;
    
    if (IS_WIFI){
        PPDebug(@"<syncFriend> in WIFI mode, force SYNC");
        needSync = YES;
    }
    else{
        NSArray* current = [[FriendManager sharedInstance] friendList];
        if ([current count] == 0){
            PPDebug(@"<syncFriend> no friend yet, force SYNC");
            needSync = YES;
        }
    }
    
    if (needSync){
        [self getFriendList:PBGetUserFriendListTypeTypeAll
                   callback:callback];
    }
    else{
        PPDebug(@"<syncFriend> no need to SYNC, return current friend list directly");
        PBUserFriendList* allList = [[FriendManager sharedInstance] allList];
        EXECUTE_BLOCK(callback, allList, nil);
    }
}

- (PBUserFriendList*)getRequestFriendList:(FriendListCallback)callback
{
    return [self getFriendList:PBGetUserFriendListTypeTypeRequestFriendList
                      callback:callback];
}

- (PBUserFriendList*)getFriendList:(PBGetUserFriendListType)type callback:(FriendListCallback)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBGetUserFriendListRequestBuilder* reqBuilder = [PBGetUserFriendListRequest builder];
    [reqBuilder setType:type];
    
    // set request
    [builder setGetUserFriendListRequest:[reqBuilder build]];
    
    [self sendRequest:PBMessageTypeMessageGetUserFriendList
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBUserFriendList* friends = response.getUserFriendListResponse.friends;
                 if (error == nil && friends != nil){
                     // success, add user friend into local list
                     PPDebug(@"<getFriendList> total %d friends, %d request, request count %d",
                             [friends.friends count], [friends.requestFriends count], friends.requestNewCount);
                     
                     if (type == PBGetUserFriendListTypeTypeAll){
                         [[FriendManager sharedInstance] storeFriendList:friends];
                     }
                     else if (type == PBGetUserFriendListTypeTypeFriendList){
                         [[FriendManager sharedInstance] storeOnlyFriendList:friends.friends];
                     }
                     else if (type == PBGetUserFriendListTypeTypeRequestFriendList){
                         [[FriendManager sharedInstance] storeRequestFriendList:friends.requestFriends requestNewCount:friends.requestNewCount];
                     }
                 }
                 else{
                     // failure
                 }
                 
                 EXECUTE_BLOCK(callback, friends, error);
                 
             } isPostError:YES];
    
    return nil;
}

- (PBUserFriendList*)getFriendListWithTag:(PBUserTag*)tag callback:(FriendListCallback)callback
{
    return nil;
}

- (void)addUserFriend:(PBAddUserFriendRequest*)pbRequest callback:(AddFriendCallback)callback
{
    if (pbRequest == nil || pbRequest.friend == nil){
        EXECUTE_BLOCK(callback, [self errorInput]);
        return;
    }
    
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    // set request
    [builder setAddUserFriendRequest:pbRequest];
    
    [self sendRequest:PBMessageTypeMessageAddUserFriend
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 if (error == nil){
                     // success, TODO add user friend into local list
                 }
                 else{
                     // failure
                 }
                 
                 EXECUTE_BLOCK(callback, error);
                 
             } isPostError:YES];
}

#pragma mark - Delete Friend
- (void)deleteFriend:(NSString*)userId
           addStatus:(int)addStatus
            callback:(DeleteFriendCallbackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBDeleteFriendRequestBuilder* reqBuilder = [PBDeleteFriendRequest builder];
    [reqBuilder setUserId:userId];
    [reqBuilder setAddStatus:addStatus];
    
    // set request
    PBDeleteFriendRequest* req = [reqBuilder build];
    [builder setDeleteFriendRequest:req];
    
    [self sendRequest:PBMessageTypeMessageDeleteFriend
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
//                 PBUser* pbUser = response.deleteFriendResponse.user;
                 if (error == nil){
                     // success, remove friend from local list
                     [[FriendManager sharedInstance] deleteFriend:userId addStatus:addStatus];
                 }
                 else{
                     // failure
                 }
                 EXECUTE_BLOCK(callback, error);
                 
             } isPostError:YES];
}

- (void)processUserFriendRequest:(PBProcessUserFriendRequest*)pbRequest callback:(AddFriendCallback)callback
{
    if (pbRequest == nil || [pbRequest.friendId length] == 0){
        EXECUTE_BLOCK(callback, [self errorInput]);
        return;
    }
    
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    // set request
    [builder setProcessUserFriendRequest:pbRequest];
    
    [self sendRequest:PBMessageTypeMessageProcessUserFriend
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 if (error == nil){
                     // success, TODO add or delete user friend from local list
                 }
                 else{
                     // failure
                 }
                 
                 EXECUTE_BLOCK(callback, error);
                 
             } isPostError:YES];
}

#pragma mark - Test Methods

- (void)testTags
{
    [[TagManager sharedInstance] printTags];
    
    [self getAllTags:^(PBUserTagList *tagList, NSError *error) {
        [[TagManager sharedInstance] printTags];
    }];
    
    PBUserTag* newTag = [[TagManager sharedInstance] buildNewTag:@"同学"];
    [self addTag:newTag
        callback:^(PBUserTag *retTag, NSError *error) {
            [[TagManager sharedInstance] printTags];
        }];

    PBUserTag* newTag1 = [[TagManager sharedInstance] buildNewTag:@"二次元神经病"];
    [self addTag:newTag1
        callback:^(PBUserTag *retTag, NSError *error) {
            [[TagManager sharedInstance] printTags];
        }];

    __weak typeof(self) weakSelf = self;
    PBUserTag* newTag2 = [[TagManager sharedInstance] buildNewTag:@"无聊二货"];
    [self addTag:newTag2
        callback:^(PBUserTag *retTag, NSError *error) {
            [[TagManager sharedInstance] printTags];

            [weakSelf deleteTag:newTag1
                   callback:^(PBUserTag *retTag, NSError *error) {
                       [[TagManager sharedInstance] printTags];
                   }];
        }];

}

#define USER_ID_A       @"54acccf674f82ad2a174d6ac"
#define USER_ID_B       @"5490396874f8383d999eb282"

- (void)testFriends_A_Request_B
{
    PBUserBuilder* userBuilder = [PBUser builder];
    [userBuilder setUserId:USER_ID_B];
    [userBuilder setNick:@"user B"];
    
    PBAddUserFriendRequestBuilder* builder = [PBAddUserFriendRequest builder];
    [builder setFriend:[userBuilder build]];
    [builder setSourceType:FriendAddSourceTypeAddBySearch];
    [builder setMemo:@"add test"];
    
    [self addUserFriend:[builder build] callback:^(NSError *error) {
        
    }];
}

- (void)testFriends_B_Accept_A
{
    PBProcessUserFriendRequestBuilder* builder = [PBProcessUserFriendRequest builder];
    [builder setMemo:@"accept you!!!"];
    [builder setFriendId:USER_ID_A];
    [builder setProcessResult:PBProcessFriendResultTypeAcceptFriend];
    
    [self processUserFriendRequest:[builder build] callback:^(NSError *error) {
        
    }];
}

- (void)testFriends_B_Reject_A
{
    PBProcessUserFriendRequestBuilder* builder = [PBProcessUserFriendRequest builder];
    [builder setMemo:@"reject you!!!"];
    [builder setFriendId:USER_ID_A];
    [builder setProcessResult:PBProcessFriendResultTypeRejectFriend];
    
    [self processUserFriendRequest:[builder build] callback:^(NSError *error) {
        
    }];
    
}

- (void)testFriends_GetFriendList
{
    [self getFriendList:PBGetUserFriendListTypeTypeAll callback:^(PBUserFriendList *friendList, NSError *error) {
        [[FriendManager sharedInstance] printFriendList];
    }];
}

- (void)testFriends_A_Delete_B
{
    PBUserBuilder* builder = [PBUser builder];
    [builder setUserId:USER_ID_B];
    
//    [self deleteUserFriend:[builder build] callback:^(NSError *error) {
//        
//    }];
}

- (void)testFriends_B_Delete_A
{
    PBUserBuilder* builder = [PBUser builder];
    [builder setUserId:USER_ID_A];
    
//    [self deleteUserFriend:[builder build] callback:^(NSError *error) {
//        
//    }];
}

- (void)testFriends
{
    [self testFriends_GetFriendList];
    
//    [self testFriends_A_Request_B];
//    [self testFriends_B_Accept_A];
}

@end
