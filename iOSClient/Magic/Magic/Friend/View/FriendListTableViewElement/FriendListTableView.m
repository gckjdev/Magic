//
//  FriendListTableView.m
//  BarrageClient
//
//  Created by HuangCharlie on 2/6/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "FriendListTableView.h"
#import "FriendListTableViewCell.h"
#import "PPDebug.h"
#import "UIViewUtils.h"
#import "User.pb.h"
#import "Message.pb.h"
#import "FriendService.h"
#import "PBUser+Extend.h"
#import "MKBlockActionSheet.h"
#import "MKBlockAlertView.h"

@interface FriendListTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@end

@implementation FriendListTableView

- (id)init
{
    self = [super init];
    
    //keep table view pure, data should be send in an saved
    self.dataSource = self;
    self.delegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return self;
}

-(void)updateTableView
{
    [self reloadData];
}

- (NSUInteger)getCount
{
    return [self.pbFriendList count];
}

- (PBUser*)getUser:(NSUInteger)row
{
    PBUser* user = [self.pbFriendList objectAtIndex:row];
    return user;
}


#pragma mark --- table view delegate
//for the number of rows that displays
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"FriendCell";
    FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[FriendListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:CellWithIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    PBUser* pbUser = [self getUser:row];
    [cell updateWithUser:pbUser indexPath:indexPath];
    [UIView addBottomLineWithColor:BARRAGE_BG_COLOR
                       borderWidth:1
                         superView:cell];

    cell.clickAddActionBlock = ^(NSIndexPath* indexPath){
        PBProcessUserFriendRequestBuilder* builder = [PBProcessUserFriendRequest builder];
        [builder setMemo:@""];
        [builder setFriendId:pbUser.userId];
        [builder setProcessResult:PBProcessFriendResultTypeAcceptFriend];
        
        [[FriendService sharedInstance] processUserFriendRequest:[builder build] callback:^(NSError *error) {
            if(error)
            {
                PPDebug(@"<clickToAcceptFriend> error in accept user");
                return;
            }
            else{
                PPDebug(@"<clickToAcceptFriend> success");
                POST_SUCCESS_MSG(@"已同意添加好友");
            }
        }];
    };
    
    
    return cell;
}

/*
 the followings are optional in tableview delegate
 */
//(optional)每一行的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//对每一行进行不同的操作，通过行的index进行区分
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
//选中某一行的时候，进行的一些action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBUser* pbUser = [self getUser:indexPath.row];
    [self.actionDelegate clickOnItem:pbUser];
}
//对某一行进行删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"neng : 执行删除操作");
    NSUInteger row = [indexPath row];
    PBUser* pbUser = [self getUser:row];
    [self deleteFriend:pbUser];
}

-(void)deleteFriend:(PBUser*)pbUser
{
    NSString *makeSure = @"删除";
    
    MKBlockAlertView *alertView = [[MKBlockAlertView alloc]initWithTitle:@"选项" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:makeSure, nil];
    
     __weak typeof (alertView) tmpAler = alertView;
    [alertView setActionBlock:^(NSInteger buttonIndex){
        NSString *title = [tmpAler buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:makeSure]) {
            [[FriendService sharedInstance]deleteFriend:pbUser.userId addStatus:pbUser.addStatus callback:^(NSError *error) {
                if(error ==nil)
                {
                    POSTMSG(@"删除好友成功");
                    //TODO
//
                   
                        [self.actionDelegate clickDeteleButton];
                    
                }
                else
                {
                    POSTMSG(@"删除好友失败");
                }
            }];

        }
    }];
    [alertView show];
//    MKBlockActionSheet *actionSheet = [[MKBlockActionSheet alloc]
//                                       initWithTitle:@"选项"delegate:nil
//                                       cancelButtonTitle:@"取消"
//                                       destructiveButtonTitle:nil
//                                       otherButtonTitles:makeSure, nil];
//    
//    __weak typeof (actionSheet) as = actionSheet;
//    [actionSheet setActionBlock:^(NSInteger buttonIndex){
//        NSString *title = [as buttonTitleAtIndex:buttonIndex];
//        if ([title isEqualToString:makeSure]) {
//            [[FriendService sharedInstance]deleteFriend:pbUser.userId addStatus:pbUser.addStatus callback:^(NSError *error) {
//                if(error ==nil)
//                {
//                    POSTMSG(@"删除好友成功");
//                    //TODO
//                    [self reloadData];
//                }
//                else
//                {
//                    POSTMSG(@"删除好友失败");
//                }
//            }];
//        }
//    }];
//    [actionSheet showInView:self];
}



@end
