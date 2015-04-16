//
//  PhotoPickerViewController.m
//  BarrageClient
//
//  Created by HuangCharlie on 1/15/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import <UzysAppearanceConfig.h>

@interface PhotoPickerViewController ()

@end

@implementation PhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyBasicConfiguration
{
    //set some configaration for certain usage
    
    self.maximumNumberOfSelectionPhoto = 1;
    self.maximumNumberOfSelectionVideo = 0;
    
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc]init];
    appearanceConfig.finishSelectionButtonColor = [UIColor blueColor];
    appearanceConfig.assetsGroupSelectedImageName = @"checker";
//    appearanceConfig.assetSelectedImageName = @"selected";
//    appearanceConfig.assetDeselectedImageName = @"deselected";
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
}

- (void)finishPicking
{
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
