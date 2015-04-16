//
//  NewFeedController.h
//  BarrageClient
//
//  Created by pipi on 14/12/11.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface NewFeedController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//@property (weak, nonatomic) IBOutlet UIButton *selectAlbumButton;
//@property (weak, nonatomic) IBOutlet UIButton *selectCameraButton;
//@property (weak, nonatomic) IBOutlet UIView *actionHolderView;

@property (strong, nonatomic) IBOutlet UIButton *selectAlbumButton;
@property (strong, nonatomic) IBOutlet UIButton *selectCameraButton;
@property (strong, nonatomic) UIView *actionHolderView;


@property (nonatomic, retain) UIPopoverController* popVC;

- (IBAction)clickAlbumButton:(id)sender;
@end
