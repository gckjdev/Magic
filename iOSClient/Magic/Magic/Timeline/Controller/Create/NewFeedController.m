//
//  NewFeedController.m
//  BarrageClient
//
//  Created by pipi on 14/12/11.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "NewFeedController.h"
#import "DeviceDetection.h"
#import "PPDebug.h"
#import "Masonry.h"
#import "FeedService.h"

#import "FeedBarrageView.h"

//for testing editimageview
//TODO: to be deleted
#import "EditImageController.h"
#import "PhotoPickerViewController.h"
#import "ShareViewController.h"
#import "FriendListController.h"
#import "SearchUserController.h"
#import "SearchUserResultController.h"
#import "ShareToWhichFriendViewController.h"
//#import "TagDetailViewController.h"

#import "FriendService.h"
#import "UserService.h"

@interface NewFeedController ()

@end

@implementation NewFeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.actionHolderView = [[UIView alloc] init];
    
    self.view.userInteractionEnabled = YES;
    
    [self.view addSubview:self.actionHolderView];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    // Do any additional setup after loading the view.
    self.actionHolderView.backgroundColor = [UIColor yellowColor];
    [self.actionHolderView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(@100);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    self.actionHolderView.userInteractionEnabled = YES;
    
    self.selectAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectAlbumButton setTitle:@"Album" forState:UIControlStateNormal];
    [self.selectAlbumButton setBackgroundColor:[UIColor redColor]];
    [self.actionHolderView addSubview:self.selectAlbumButton];
    [self.selectAlbumButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(self.actionHolderView.mas_width).with.dividedBy(2.2);
        make.height.equalTo(@50);
        make.centerY.equalTo(self.actionHolderView.mas_centerY);
        make.centerX.equalTo(self.actionHolderView.mas_centerX).with.dividedBy(2);
    }];
    [self.selectAlbumButton addTarget:self action:@selector(clickAlbumButton:) forControlEvents:UIControlEventTouchUpInside];
    self.selectAlbumButton.userInteractionEnabled = YES;
    
    self.selectCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectCameraButton setTitle:@"Camera" forState:UIControlStateNormal];
    [self.selectCameraButton setBackgroundColor:[UIColor redColor]];
    [self.actionHolderView addSubview:self.selectCameraButton];
    [self.selectCameraButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(self.actionHolderView.mas_width).with.dividedBy(2.2);
        make.height.equalTo(@50);
        make.centerY.equalTo(self.actionHolderView.mas_centerY);
        make.centerX.equalTo(self.actionHolderView.mas_centerX).with.dividedBy(2.0f/3.0f);
    }];
    [self.selectCameraButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    self.selectCameraButton.userInteractionEnabled = YES;
}


- (NSArray*)feedActionsList
{
    NSMutableArray* list = [NSMutableArray array];
    for (int i=0; i<5; i++){
        PBFeedActionBuilder* feedAction = [PBFeedAction builder];
        [feedAction setAvatar:@"http://c.hiphotos.baidu.com/image/h%3D360/sign=a5a5d1218982b90122adc535438ca97e/4e4a20a4462309f7fa0b5714710e0cf3d7cad654.jpg"];

        [feedAction setPosX: rand() % 720];
        [feedAction setPosY: rand() % 720];
//        [feedAction setPosX: 0];
//        [feedAction setPosY: 0];
        
        NSString* text = [NSString stringWithFormat:@"[%d] (%.0f, %.0f)哈哈哈哈哈，这个很搞笑！！！", i, feedAction.posX, feedAction.posY];
        [feedAction setText:text];
        
        [list addObject:[feedAction build]];
    }
    
    return list;
}

//TODO
//for testing editimageview
// to be deleted
-(void)clickCameraButton:(id)sender
{
    [[UserService sharedInstance] searchUser:@"S" offset:0 limit:20 callback:^(NSArray *pbUserList, NSError *error) {
        
    }];
    
    //charlie use this button for testing, what a mess!
    
    //----------------------cutoff------------------------------
    /*TODO!should be deleted! just for testing*/
    //    FeedBarrageView *feedBarrageView = [FeedBarrageView barrageViewInView:self.view frame:CGRectMake(0, 0, 800, 800)];
    //    UIImage *image = [UIImage imageNamed:@"bg.png"];
    //    [feedBarrageView setBgImage:image];
    //    [feedBarrageView setBarrageActions:[self feedActionsList]];
    //    [feedBarrageView play];
    //    //for testing, to be deleted
    //    [feedBarrageView performSelector:@selector(pause) withObject:self afterDelay:3.0];
    //    [feedBarrageView performSelector:@selector(resume) withObject:self afterDelay:7.0];
    //    [feedBarrageView performSelector:@selector(stop) withObject:self afterDelay:10.0];
    
    //    [[FriendService sharedInstance] testTags];
    //    [[FriendService sharedInstance] testFriends];
    
    //--------------cutoff-----------------
//    EditImageController* editImageCont = [[EditImageController alloc]init];
//    editImageCont.originImage = [UIImage imageNamed:@"bg.png"];
////    [self presentViewController:editImageCont animated:YES completion:^(void){}];
//    [self.navigationController pushViewController:editImageCont animated:YES];
    
    //-------------------------------
//    //TODO testing
//    PhotoPickerViewController* picker = [[PhotoPickerViewController alloc]init];
//    [picker applyBasicConfiguration];
//    [self presentViewController:picker animated:YES completion:nil];

    
    //---------------cutoff----------------
//    ShareViewController* shareViewCont = [[ShareViewController alloc]init];
//    shareViewCont.oringinImageURL = [NSURL URLWithString:@"http://news.xinhuanet.com/local/2015-01/19/127397207_14216216826271n.jpg"];
//    shareViewCont.barrageList = [self feedActionsList];
//    [self.navigationController pushViewController:shareViewCont animated:YES];
    
    //----------------cutoff-----------------------
//    FriendListController* fListCont = [[FriendListController alloc]init];
//    [self.navigationController pushViewController:fListCont animated:YES];
    
    //-----------------cutoff----------------------
//    SearchUserController* suCont = [[SearchUserController alloc]init];
//    [self.navigationController pushViewController:suCont animated:YES];
    
    //---------------------------------------
//    ShareToFriendViewController *stfCont = [[ShareToFriendViewController alloc]init];
//    [self.navigationController pushViewController:stfCont animated:YES];
    
    //---------------------------------------
//    TagDetailViewController *tagDetailCont = [[TagDetailViewController alloc]init];
//    [self.navigationController pushViewController:tagDetailCont animated:YES];
    
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
    
    PPDebug(@"select original image size = %@", NSStringFromCGSize(image.size));
    if (image != nil){
        if (self){
//            CGSize size = image.size;
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
            
            [[FeedService sharedInstance] createFeedWithImage:image text:@"人生就是这样子的吧" toUsers:nil callback:^(NSString *feedId, NSError *error) {
                PPDebug(@"<createFeedWithImage> error=%@", error);
            }];
            
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
