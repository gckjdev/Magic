//
//  AutoTagManager.m
//  BarrageClient
//
//  Created by HuangCharlie on 3/3/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "AutoTagManager.h"
#import "User.pb.h"
#import "FriendManager.h"
#import "UserGroupManager.h"
#import "TagManager.h"
#import "TagInfoViewController.h"
#import "AppDelegate.h"
#import "FriendListController.h"

#define KEY_CACHE_RECENT_CLOSE_FRIEND           @"KEY_CACHE_RECENT_CLOSE_FRIEND"

@interface AutoTagManager ()<UIAlertViewDelegate>
{
    
}

@property (nonatomic,strong) PBUserGroup* currentGroup;

@end

@implementation AutoTagManager

IMPL_SINGLETON_FOR_CLASS(AutoTagManager)

//crucial function, check ererytime new feed send...
- (void)checkNeedAutoMakeTagWithUsers:(NSArray*)users
{
    //check if belong to tag
    NSArray* newUsers = [[FriendManager sharedInstance]filterUnknownUserFromUsers:users];
    // add by Benson, fix crash issue
    if([users count] == 0 || [newUsers count] == 0)
        return;
    
    //add by charlie 2015 4 1
    // if less than two known user exist
    // do not autotag
    if([[[FriendManager sharedInstance]filterUnknownUserFromUsers:users]count]<2)
        return;
    
    PBUserTag* tag = [[TagManager sharedInstance]checkOverTagsForArray:newUsers];
    if(tag != nil)
        return;
    
    //if no cache, new a group and store
    if(![[UserGroupManager sharedInstance]hadGroupsCache])
    {
        NSMutableArray* gArr = [NSMutableArray array];

        PBUserGroup* g = [[UserGroupManager sharedInstance]updateGroup:nil
                                                             withUsers:newUsers
                                                             occurence:YES
                                                             rejection:NO
                                                           currentDate:[self getDateStr]];
        [gArr addObject:g];
        [[UserGroupManager sharedInstance]setGroupsCache:gArr];
        return;
    }
    //each object is a pbgroup
    NSArray* cacheGroups = [[UserGroupManager sharedInstance] getGroupsCache];
    
    BOOL isGrouped = NO;
    PBUserGroup* selectedGroup = nil;
    NSArray* selectedUsers = nil;
    for(PBUserGroup* group in cacheGroups)//iterate every group
    {
        NSArray* groupUsers = [[FriendManager sharedInstance]filterUnknownUserFromUsers:[group users]];
        NSArray* currentUsers = [[FriendManager sharedInstance]filterUnknownUserFromUsers:users];

        if([FriendManager compareUserArray:currentUsers withUserArray:groupUsers])
        {
            isGrouped = YES;
            selectedGroup = group;
            selectedUsers = currentUsers;
        }
    }
    
    if(isGrouped){
        //if users are already a group, update the group
        self.currentGroup = [[UserGroupManager sharedInstance]updateGroup:selectedGroup withUsers:selectedUsers occurence:YES rejection:NO currentDate:[self getDateStr]];
    }
    else{
        //new a group
        self.currentGroup = [[UserGroupManager sharedInstance]updateGroup:nil withUsers:newUsers occurence:YES rejection:NO currentDate:[self getDateStr]];
    }

    //update grouplist data of local storage
    [[UserGroupManager sharedInstance]updateGroupListWithGroup:self.currentGroup];
    
    [self showAlert];
}

-(NSString*)getDateStr
{
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd%hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    PPDebug(@"Current Date: %@",date);
    return date;
}

-(void)showAlert
{
    NSString* message;
    NSArray* users = [self.currentGroup users];
    if([users count] == 1){
        PBUser* user = [users objectAtIndex:0];
        message = [NSString stringWithFormat:@"推荐你为 %@ 创建一个标签",[user nick]];
    }
    else if([users count] == 2){
        PBUser* user0 = [users objectAtIndex:0];
        PBUser* user1 = [users objectAtIndex:1];
        message = [NSString stringWithFormat:@"推荐你为 %@,%@ 创建一个标签",[user0 nick],[user1 nick]];
    }
    else if([users count] == 3){
        PBUser* user0 = [users objectAtIndex:0];
        PBUser* user1 = [users objectAtIndex:1];
        PBUser* user2 = [users objectAtIndex:2];
        message = [NSString stringWithFormat:@"推荐你为 %@,%@,%@ 创建一个标签",[user0 nick],[user1 nick],[user2 nick]];
    }
    else{
        PBUser* user0 = [users objectAtIndex:0];
        PBUser* user1 = [users objectAtIndex:1];
        PBUser* user2 = [users objectAtIndex:2];
        message = [NSString stringWithFormat:@"推荐你为 %@,%@,%@ 等好友创建一个标签",[user0 nick],[user1 nick],[user2 nick]];
    }
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:message
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //click 确定 and enter tag info view controller
    if(buttonIndex==1)
    {
        PPDebug(@"need to make tag");
        
        TagInfoViewController* cont = [[TagInfoViewController alloc]initWithType:IsCreating andPBTag:nil orPBUsers:[self.currentGroup users]];
        
        AppDelegate *delegate = [[UIApplication  sharedApplication]delegate];
        UIViewController* currentController = delegate.currentViewController;
        
        [currentController.navigationController pushViewController:cont animated:YES];
    }
    //click 取消 and add one count on rejection
    else if(buttonIndex == 0)
    {
        self.currentGroup = [[UserGroupManager sharedInstance]updateGroup:self.currentGroup withUsers:self.currentGroup.users occurence:NO rejection:YES currentDate:[self getDateStr]];
        [[UserGroupManager sharedInstance]updateGroupListWithGroup:self.currentGroup];
    }
}

@end
