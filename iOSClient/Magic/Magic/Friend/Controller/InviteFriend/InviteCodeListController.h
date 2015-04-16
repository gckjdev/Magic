//
//  InviteCodeListController.h
//  BarrageClient
//
//  Created by pipi on 15/1/10.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "BCTableViewController.h"

// 显示用户邀请码列表
@interface InviteCodeListController : BCTableViewController<ABPeoplePickerNavigationControllerDelegate,MFMessageComposeViewControllerDelegate>

@end
