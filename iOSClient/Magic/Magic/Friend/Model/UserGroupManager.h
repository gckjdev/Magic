//
//  UserGroupManager.h
//  BarrageClient
//
//  Created by HuangCharlie on 3/17/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "CommonManager.h"
#import "APLevelDB.h"
#import "User.pb.h"

@interface UserGroupManager : CommonManager
{
    APLevelDB* _db;
}

DEF_SINGLETON_FOR_CLASS(UserGroupManager)

@property (nonatomic,strong) NSArray* groups;

//group list getter and setter
- (BOOL)hadGroupsCache;
- (NSArray*)getGroupsCache;
- (void)clearGroupsCache;
- (void)setGroupsCache:(NSArray*)groups;

//group getter and setter
- (void)updateGroupListWithGroup:(PBUserGroup*)group;
- (PBUserGroup*)updateGroup:(PBUserGroup*)group
                  withUsers:(NSArray*)users
                  occurence:(BOOL)occur
                  rejection:(BOOL)rejec
                currentDate:(NSString*)date;


@end
