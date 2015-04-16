//
//  CreateFeedController.h
//  BarrageClient
//
//  Created by pipi on 14/11/28.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateFeedController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectAlbumButton;
@property (weak, nonatomic) IBOutlet UIButton *selectCameraButton;
@property (weak, nonatomic) IBOutlet UIView *actionHolderView;

@property (nonatomic, retain) UIPopoverController* popVC;

- (IBAction)clickAlbumButton:(id)sender;
@end
