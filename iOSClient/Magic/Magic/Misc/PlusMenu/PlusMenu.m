//
//  PlusMenu.m
//  BarrageClient
//
//  Created by pipi on 15/1/30.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "PlusMenu.h"
#import "MKBlockActionSheet.h"
#import "SearchUserController.h"
#import "UserHomeController.h"
#import "UMFeedback.h"
#import "RDVTabBarController.h"
#import "UIViewController+Utils.h"
#import "Masonry.h"
#import "PlusMenuTableViewController.h"
#import "SettingsController.h"
#import "AppDelegate.h"

@implementation PlusMenu

#define TITLE_ACTION_FEEDBACK @"意见反馈"
#define TITLE_ADD_FRIEND      @"添加好友"
#define TITLE_MY_PROFILE      @"个人中心"

static CMPopTipView* homePopTipView;
static PlusMenuTableViewController* homePopController;

static CMPopTipView* friendPopTipView;
static PlusMenuTableViewController* friendPopController;

#pragma mark - Private methods
+ (void)showOptionActionSheet:(UIViewController*)superController view:(UIView*)view
{
    MKBlockActionSheet* actionSheet = [[MKBlockActionSheet alloc] initWithTitle:@""
                                                                       delegate:nil
                                                              cancelButtonTitle:@"返回"
                                                         destructiveButtonTitle:TITLE_ADD_FRIEND
                                                              otherButtonTitles:TITLE_MY_PROFILE, TITLE_ACTION_FEEDBACK, nil];
    
    __weak typeof(actionSheet) as = actionSheet;
    [actionSheet setActionBlock:^(NSInteger buttonIndex){
        NSString* title = [as buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:TITLE_ACTION_FEEDBACK]){
            [superController.navigationController pushViewController:[UMFeedback feedbackViewController]
                                                 animated:YES];
        }
        else if ([title isEqualToString:TITLE_ADD_FRIEND]){
            SearchUserController* vc = [[SearchUserController alloc] init];
            [superController.navigationController pushViewController:vc animated:YES];
        }
        else if ([title isEqualToString:TITLE_MY_PROFILE]){
            UserHomeController* vc = [[UserHomeController alloc] init];
            [superController.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    
    if (superController.rdv_tabBarController.tabBar != nil){
        [actionSheet showInView:superController.rdv_tabBarController.tabBar];
    }
    else{
        [actionSheet showInView:view];
    }
}

+ (void)showOptionPopTipView:(UIViewController *)superController popTipView:(CMPopTipView*)popTipView
{
    popTipView.backgroundColor = [UIColor blackColor];
    popTipView.cornerRadius = 4;
    
    AppDelegate *delegate = [[UIApplication  sharedApplication]delegate];
    UIViewController *currentController = delegate.currentNavigationController;
    
    UIView *targetView = (UIView *)[superController.navigationItem.rightBarButtonItem  performSelector:@selector(view)];
    [popTipView presentPointingAtView:targetView inView:currentController.view animated:YES];
}

//  显示
+ (void)showPopTipView:(CMPopTipView*)popTipView
       superController:(UIViewController*)superController
                  view:(UIView*)view
{
    [self showOptionPopTipView:superController popTipView:popTipView];
}

#pragma mark - Public methods

+ (CMPopTipView*)homePopTipView
{
    if (homePopTipView == nil){
        PlusMenuTableViewController* vc = [self homePopController];
        homePopTipView = [[CMPopTipView alloc] initWithCustomView:vc.view];
        vc.popTipView = homePopTipView;
    }
    return homePopTipView;
}

+ (PlusMenuTableViewController*)homePopController
{
    if (homePopController == nil){
        homePopController = [PlusMenuTableViewController menuForHome];
    }
    return homePopController;
}

+ (CMPopTipView*)friendPopTipView
{
    if (friendPopTipView == nil){
        PlusMenuTableViewController* vc = [self friendPopController];
        friendPopTipView = [[CMPopTipView alloc] initWithCustomView:vc.view];
        vc.popTipView = friendPopTipView;
    }
    return friendPopTipView;
}

+ (PlusMenuTableViewController*)friendPopController
{
    if (friendPopController == nil){
        friendPopController = [PlusMenuTableViewController menuForFriend];
    }
    return friendPopController;
}
@end

@implementation UIViewController (AddPlusMenu)

#pragma mark - Public Methods

- (void)addPlusMenuAtFriendNavigationBar
{
    [self addRightButton:@"plus.png" action:@selector(clickFriendPlusMenuButton:)];
}

- (void)addPlusMenuAtHomeNavigationBar
{
    [self addRightButton:@"plus.png" action:@selector(clickHomePlusMenuButton:)];
}
//  Home
- (void)clickHomePlusMenuButton:(id)sender
{
    CMPopTipView* popTipView = [PlusMenu homePopTipView];
    [self handleClickPlusButton:popTipView];
}

//  Friend
- (void)clickFriendPlusMenuButton:(id)sender
{
    CMPopTipView* popTipView = [PlusMenu friendPopTipView];
    [self handleClickPlusButton:popTipView];
}

- (void)hiddenPlusMenuAtHomeNavigationBar
{
    if (homePopTipView && homePopTipView.isPopup) {
        [homePopTipView dismissAnimated:YES];
    }
}
- (void)hiddenPlusMenuAtFriendNavigationBar
{
    if (friendPopTipView && friendPopTipView.isPopup) {
        [friendPopTipView dismissAnimated:YES];
}}
#pragma mark - Utils
- (void)handleClickPlusButton:(CMPopTipView*)popTipView
{
    //  实现点击之后再点击可以去掉plusMenu
    if (popTipView.isPopup) {
        [popTipView dismissAnimated:YES];
    }else{
        [PlusMenu showPopTipView:popTipView superController:self view:nil];
    }
}

@end
