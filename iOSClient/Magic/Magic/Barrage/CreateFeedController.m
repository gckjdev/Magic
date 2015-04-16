//
//  CreateFeedController.m
//  BarrageClient
//
//  Created by pipi on 14/11/28.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "CreateFeedController.h"
#import "DeviceDetection.h"
#import "PPDebug.h"
#import "Masonry.h"

@interface CreateFeedController ()

@end

@implementation CreateFeedController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.actionHolderView.backgroundColor = [UIColor yellowColor];
    [self.actionHolderView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(@100);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickAlbumButton:(id)sender {
    
    [self selectPhoto];
    
}

- (void)selectPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] &&
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        
        if (ISIOS8){
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_0
            
            picker.modalPresentationStyle = UIModalPresentationPopover;
            UIPopoverPresentationController* popVC = picker.popoverPresentationController;
            popVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
            popVC.sourceView = self.view;
            float screenWidth = [UIScreen mainScreen].bounds.size.width;
            float width = 400;
            popVC.sourceRect = ISIPAD ? CGRectMake((screenWidth-width)/2, -140, width, width) : self.view.bounds;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self presentViewController:picker
                                                   animated:NO
                                                 completion:nil];
                
            });
#endif
            
        }
        else{
            if ([DeviceDetection isIPAD]){
                UIPopoverController *controller = [[UIPopoverController alloc] initWithContentViewController:picker];
                self.popVC = controller;
                CGRect popoverRect = CGRectMake((768-400)/2, -140, 400, 400);
                [controller presentPopoverFromRect:popoverRect
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionUp
                                          animated:YES];
            }else {
                
                [self presentViewController:picker
                                   animated:YES
                                 completion:nil];
            }
        }
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL userOriginalImage = YES;
    UIImage *image = [info objectForKey:userOriginalImage?UIImagePickerControllerOriginalImage:UIImagePickerControllerEditedImage];
    
    if (image != nil){
        if (self){
            CGSize size = image.size;
            PPDebug(@"select image size = %@", NSStringFromCGSize(size));
            
//            if (_imageSize.width > 0 && _imageSize.height > 0) {
//                size = _imageSize;
//            }
            
//            if (_autoRoundRect){
//                image = [UIImage createRoundedRectImage:image size:size];
//            }
//            else if (self.isCompressImage){
//                image = [image imageByScalingAndCroppingForSize:size];
//                PPDebug(@"compress image size = %@", NSStringFromCGSize(image.size));
//            }
        }
    }
    
    if (self.popVC != nil) {
        [self.popVC dismissPopoverAnimated:NO];
    }else{
        //        [picker dismissModalViewControllerAnimated:NO];
        [picker dismissViewControllerAnimated:NO completion:nil];
    }

    
//    id delegate = self.enableCrop ? (id)self : _delegate;
//    
//    if (image && delegate && [delegate respondsToSelector:@selector(didImageSelected:)]) {
//        [delegate didImageSelected:image];
//    }
//    
//    if (self.enableCrop == NO && _selectImageBlock != NULL) {
//        EXECUTE_BLOCK(_selectImageBlock, image);
//        self.selectImageBlock = nil;
//    }
}

@end
