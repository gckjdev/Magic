//
//  BCUIViewController.m
//  BarrageClient
//
//  Created by Teemo on 15/3/16.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "BCUIViewController.h"
#import "UIViewController+Utils.h"
#import "ViewInfo.h"

@interface BCUIViewController ()
@property (nonatomic,strong) NSString*   navBackButtonText;
@end

@implementation BCUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupNavBackButton];
}

-(void)loadView
{
    [super loadView];
    [self setupNavBackButton];
}
-(void)setupNavBackButton
{
    
    int count = 1; //默认首页放在navigationController不pop
    if (self.navigationController.viewControllers.count > count) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backarrow"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(backClick)];
        
        
        backButton.imageInsets = UIEdgeInsetsMake(0, NAVBARLEFT_BUTTON_INSET_LEFT, 0, 0);
        backButton.title = _navBackButtonText;
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    
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
