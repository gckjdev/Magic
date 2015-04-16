//
//  BCTableViewController.m
//  BarrageClient
//
//  Created by Teemo on 15/3/16.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "BCTableViewController.h"
#import "ViewInfo.h"

@interface BCTableViewController ()
@property (nonatomic,strong) NSString*   navBackButtonText;
@end

@implementation BCTableViewController

-(void)loadView
{
    [super loadView];
    [self setupNavBackButton];
}
-(void)setupNavBackButton
{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backarrow"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backClick)];
    
    backButton.imageInsets = UIEdgeInsetsMake(0, NAVBARLEFT_BUTTON_INSET_LEFT, 0, 0);
    
    backButton.title = _navBackButtonText;
    self.navigationItem.leftBarButtonItem = backButton;
    
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setNavBackButtonText:(NSString*)text
{
    _navBackButtonText = [text copy];
}
@end
