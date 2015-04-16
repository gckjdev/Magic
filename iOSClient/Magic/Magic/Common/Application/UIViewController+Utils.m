//
//  UIViewController+Utils.m
//  BarrageClient
//
//  Created by pipi on 15/1/24.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "UIImageUtil.h"
#import "ColorInfo.h"
#import "ViewInfo.h"

@implementation UIViewController (Utils)

//left arrow in navigation bar
- (void)setDefaultBackButton:(SEL)backAction
{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backarrow"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:backAction];
    
    
    backButton.imageInsets = UIEdgeInsetsMake(0, NAVBARLEFT_BUTTON_INSET_LEFT, 0, 0);
 
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)setDefaultLeftButton:(SEL)leftAction
{
    UIBarButtonItem *leftButt = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:leftAction];
    
    
    self.navigationItem.leftBarButtonItem = leftButt;
}

//text button in left button in navigation bar
-(void)setLeftButton:(NSString*)title backAction:(SEL)backAction
{
    UIBarButtonItem *leftButt = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:backAction];
    
    self.navigationItem.leftBarButtonItem = leftButt;
}
- (void)addLeftButton:(NSString*)imageName
               target:(id)target
               action:(SEL)action
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:target
                                                                   action:action];
    [leftButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftButton;

}
- (void)addRightButton:(NSString*)imageName
                target:(id)target
                action:(SEL)action
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:target
                                                                   action:action];
    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButton;
}
- (void)addRightButtonWithTitle:(NSString*)title
                target:(id)target
                action:(SEL)action
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:target
                                                                   action:action];
    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)addRightButton:(NSString*)imageName
                action:(SEL)action
{
    [self addRightButton:imageName target:self action:action];
}

- (void)hideTabBar
{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    // hide center tab bar button
    UIButton * centerBtn =  (UIButton *)[self.rdv_tabBarController.view viewWithTag:CENTER_TAB_BAR_BUTTON_TAG];
    [centerBtn setHidden:YES];

}

- (void)showTabBar
{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    // show center tab bar button
    UIView* centerBtn =  [self.rdv_tabBarController.view viewWithTag:
                          CENTER_TAB_BAR_BUTTON_TAG];
    [centerBtn setHidden:NO];
}

-(void)setRedNavigationBar{
    UIImage* backgroundImage = [UIImage imageNamed:@"barbg64.png"];
    
    NSDictionary *textAttributes = nil;
    textAttributes = @{
                       NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                       NSForegroundColorAttributeName: [UIColor whiteColor],
                       };
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // set status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}
-(void)setBlackNavigationBar{
    NSDictionary *textAttributes = nil;
    textAttributes = @{
                       NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                       NSForegroundColorAttributeName: [UIColor whiteColor],
                       };
    
    [self.navigationController.navigationBar setTitleTextAttributes: textAttributes];
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NAVIGATIONBAR_BLACK]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    // set status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}



@end
