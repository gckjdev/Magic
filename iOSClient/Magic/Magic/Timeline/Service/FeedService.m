//
//  FeedService.m
//  BarrageClient
//
//  Created by pipi on 14/12/5.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "FeedService.h"
#import "QNUploadOption.h"
#import "QNUploadManager.h"
#import "UIImage+WebP.h"
#import "StringUtil.h"
#import "QNResponseInfo.h"
#import "Message.pb.h"
#import "User.pb.h"
#import "UserManager.h"
#import "FeedManager.h"
#import "AutoTagManager.h"
#import "PPDebug.h"
#import "TimeUtils.h"
#import "Message.pb.h"
#import "CdnManager.h"
#import "CreateJpegImageInfo.h"
#import "CreateImageInfoProtocol.h"
#import "EditImageController.h"
#import "ShareToWhichFriendViewController.h"
#import "UserTimelineFeedController.h"
#import "PBUser+Extend.h"
#import "UserManager.h"
#import "Common.pb.h"
#import "MobClick.h"
#import "Constants.pb.h"

#import "AppDelegate.h"
#import "UIViewUtils.h"
#import "PPDebug.h"

@interface FeedService()

@property (nonatomic, strong) UIPopoverController* popVC;

@end

@implementation FeedService

IMPL_SINGLETON_FOR_CLASS(FeedService);

- (void)createFeedWithKey:(NSString*)cdnKey
                     text:(NSString*)text
                  toUsers:(NSArray*)toUsers
                 callback:(CreateFeedCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    // TODO build device
    
    // just set imple user info is OK
    PBUser* user = [[UserManager sharedInstance] miniPbUser];
    
    NSString* imageURL = [[CdnManager sharedInstance] getFeedDataUrl:cdnKey];
    
    PBFeedBuilder* feedBuilder = [PBFeed builder];
    [feedBuilder setFeedId:@""];
    [feedBuilder setType:0];
    [feedBuilder setText:text];
    [feedBuilder setCdnKey:cdnKey];
    [feedBuilder setImage:imageURL];
    [feedBuilder setDate:(int)time(0)];
    [feedBuilder setToUsersArray:toUsers];
    [feedBuilder setCreateUser:user];
    
    // TODO set location info
    
    PBFeed* feed = [feedBuilder build];
    
    // build regisetr request
    PBCreateFeedRequestBuilder* reqBuilder = [PBCreateFeedRequest builder];
    [reqBuilder setFeed:feed];
    
    // set request
    PBCreateFeedRequest* req = [reqBuilder build];
    [builder setCreateFeedRequest:req];
    
    [self sendRequest:PBMessageTypeMessageCreateFeed
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 NSString* feedId = response.createFeedResponse.feedId;
                 if (error == nil && feedId != nil){
                     PPDebug(@"create feed successfully, feedId is %@", feedId);
                     
                     // update feed locally
                     PBFeedBuilder* updateFeedBuilder = [PBFeed builderWithPrototype:feed];
                     [updateFeedBuilder setFeedId:feedId];
                     [[FeedManager sharedInstance] addFeed:[updateFeedBuilder build]];
                 }
                 else{
                     // no feedId, error here
                 }

                 EXECUTE_BLOCK(callback, feedId, error);
                 
             } isPostError:YES];

}

//#define MIME_JPEG                       @"image/jpeg"
//#define MIME_WEBP                       @"image/webp"
//#define PATH_EXT_WEBP                   @"webp"
//#define PATH_EXT_JPEG                   @"jpg"
//
//typedef enum
//{
//    UPLOAD_JPEG              = 1,
//    UPLOAD_WEBP              = 2,
//    
//} UploadImageType;
//
//#define UPLOAD_FEED_IMAGE_TYPE         UPLOAD_JPEG
//
//- (NSData*)createImageData:(UIImage*)image type:(UploadImageType)type quality:(CGFloat)quality
//{
//    NSData* data = nil;
//    if (type == UPLOAD_WEBP){
//        data = [UIImage imageToWebP:image quality:quality*100.0f];
//    }
//    else{
//        data = UIImageJPEGRepresentation(image, quality);
//    }
//
//#ifdef DEBUG
//    NSData* origData = UIImageJPEGRepresentation(image, quality);
//#endif
//
//    PPDebug(@"create image, jpg data (%d), webp data (%d)", [origData length], [data length]);
//    return data;
//}
//
//- (NSString*)mimeType:(UploadImageType)type
//{
//    if (type == UPLOAD_WEBP){
//        return MIME_WEBP;
//    }
//    else{
//        return MIME_JPEG;
//    }
//}
//
//- (NSString*)imagePathExtension:(UploadImageType)type
//{
//    if (type == UPLOAD_WEBP){
//        return PATH_EXT_WEBP;
//    }
//    else{
//        return PATH_EXT_JPEG;
//    }
//}
//
//- (NSString*)createKey:(UploadImageType)type
//{
//    NSString* pathExt = [self imagePathExtension:type];
//    NSString* uuid = [NSString GetUUID];
//    NSString* date = dateToStringByFormat([NSDate date], @"yyyyMMdd");
//    NSString* key = [NSString stringWithFormat:@"data/img/%@/%@.%@", date, uuid, pathExt];
//    PPDebug(@"<createKey> key = %@", key);
//    return key;
//}

- (id<CreateImageInfoProtocol>)getImageInfo
{
    return [[CreateJpegImageInfo alloc] init];
}

#define UPLOAD_IMAGE_QUALITY            0.9f

- (void)createFeedWithImage:(UIImage*)image
                       text:(NSString*)text
                    toUsers:(NSArray*)origToUsers
                   callback:(CreateFeedCallBackBlock)callback
{
    // create compact user
    NSMutableArray* toUsers = [NSMutableArray array];
    for (PBUser* user in origToUsers){
        PBUser* miniUser = [user miniInfo];
        if (miniUser){
            [toUsers addObject:miniUser];
        }
    }
    
    // upload image to QiNiu Yun and get return URL
    id<CreateImageInfoProtocol> imageInfo = [self getImageInfo];
    NSString* token = [[CdnManager sharedInstance] getFeedDataToken];
    NSString* prefix = [[CdnManager sharedInstance] getFeedDataKeyPrefix];
    NSString* key = [imageInfo createKey:prefix];
    
    NSData* data = [imageInfo getImageData:image quality:UPLOAD_IMAGE_QUALITY];
    if (data == nil){
        NSError* error = nil;
        error = [NSError errorWithDomain:@"Error Create Image Data" code:PBErrorErrorCreateImage userInfo:nil];
        EXECUTE_BLOCK(callback, nil, error);
        return;
    }
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:[imageInfo getMimeType]
                                               progressHandler:^(NSString *key, float percent) {
                                                   // TODO post image upload notification
                                                   PPDebug(@"<createFeedWithImage> upload image key(%@) percent(%.2f)", key, percent);
                                               }
                                                        params:nil
                                                      checkCrc:YES
                                            cancellationSignal:nil];
    
    [upManager putData:data key:key token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {

                  PPDebug(@"upload image info = %@, resp=%@", info, resp);
                  if (info.error == nil && info.statusCode == 200){

                      // success
                      NSString* cdnKey = [resp objectForKey:@"key"];
                      
                      // now can send request to server
                      [self createFeedWithKey:cdnKey text:text toUsers:toUsers callback:callback];
                  }
                  else{
                      // failure
                      NSError* error = [NSError errorWithDomain:@"Error Upload Image to Server" code:PBErrorErrorUploadImage userInfo:nil];
                      EXECUTE_BLOCK(callback, nil, error);
                  }
              } option:opt];
    
    
}

- (void)replyFeed:(Feed*)feed feedAction:(PBFeedAction*)feedAction callback:(ReplyFeedCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    // build request
    PBReplyFeedRequestBuilder* reqBuilder = [PBReplyFeedRequest builder];
    [reqBuilder setAction:feedAction];
    
    // set request
    PBReplyFeedRequest* req = [reqBuilder build];
    [builder setReplyFeedRequest:req];
    
    [self sendRequest:PBMessageTypeMessageReplyFeed
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBFeedAction* action = response.replyFeedResponse.action;
                 if (error == nil && action != nil){
                     PPDebug(@"reply feed successfully, actionId is %@", action.actionId);

                     
                     // update feed locally
                     [[FeedManager sharedInstance] updateFeedAction:feed action:action];
                 }
                 else{
                     // no feedId, error here
                 }
                 
                 EXECUTE_BLOCK(callback, action.actionId, error);
                 
                 
             } isPostError:YES];
}

- (void)deleteFeedAction:(NSString*)feedActionId feedId:(NSString*)feedId
                callback:(DeleteFeedActionCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    // build request
    PBDeleteFeedActionRequestBuilder* reqBuilder = [PBDeleteFeedActionRequest builder];
    [reqBuilder setActionId:feedActionId];
    [reqBuilder setFeedId:feedId];
    
    // set request
    PBDeleteFeedActionRequest* req = [reqBuilder build];
    [builder setDeleteFeedActionRequest:req];
    
    [self sendRequest:PBMessageTypeMessageDeleteFeedAction
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 if (error == nil){
                     PPDebug(@"delete feedAction successfully");
                     
                     // update feed locally
                     [[FeedManager sharedInstance] deleteFeedAction:feedId action:feedActionId];
                 }
                 
                 EXECUTE_BLOCK(callback, feedActionId, error);
                 
                 
             } isPostError:YES];
}

- (void)deleteFeed:(NSString*)feedId
          callback:(DeleteFeedCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    PBDeleteFeedRequestBuilder* reqBuilder = [PBDeleteFeedRequest builder];
    [reqBuilder setFeedId:feedId];
    
    PBDeleteFeedRequest* req = [reqBuilder build];
    [builder setDeleteFeedRequest:req];
    
    [self sendRequest:PBMessageTypeMessageDeleteFeed
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 if (error == nil){
                     PPDebug(@"delete feed successfully");
                     
                     // update feed locally
                     [[FeedManager sharedInstance] deleteFeed:feedId];
                 }
                 
                 EXECUTE_BLOCK(callback, feedId, error);
                 
                 
             } isPostError:YES];
    
}
- (void)getUserFeed:(int)offset
           callback:(GetUserFeedCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    PBGetUserFeedRequestBuilder *reqBuilder = [PBGetUserFeedRequest builder];
    [reqBuilder setOffset:offset];
    
    PBGetUserFeedRequest *req = [reqBuilder build];
    [builder setGetUserFeedRequest:req];
    
    [self sendRequest:PBMessageTypeMessageGetUserFeed requestBuilder:builder callback:^(PBDataResponse *response, NSError *error) {
        NSArray *feeds = response.getUserFeedResponse.feeds;
        if (error == nil) {
            PPDebug(@"get user feed successfully, count is %d", [feeds count]);
            EXECUTE_BLOCK(callback,feeds,error);
        }
        else
        {
            PPDebug(@"get user feed fail");
            EXECUTE_BLOCK(callback,nil,error);
        }
    } isPostError:YES];
    
}
- (void)getTimelineFeed:(NSString*)offsetFeedId callback:(FeedListCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    int limit = 10;
    
    // build request
    PBGetUserTimelineFeedRequestBuilder* reqBuilder = [PBGetUserTimelineFeedRequest builder];
    [reqBuilder setOffsetFeedId:offsetFeedId];
    [reqBuilder setLimit:limit];
    
    // set request
    PBGetUserTimelineFeedRequest* req = [reqBuilder build];
    [builder setGetUserTimelineFeedRequest:req];
    
    [self sendRequest:PBMessageTypeMessageGetUserTimelineFeed
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 NSArray* feeds = response.getUserTimelineFeedResponse.feeds;
                 if (error == nil){
                     PPDebug(@"get user Timeline feed successfully, count is %d", [feeds count]);
                     [[FeedManager sharedInstance] storeUserTimelineFeedList:feeds];
                     EXECUTE_BLOCK(callback, feeds, nil);
                 }
                 else{
                     // error here
                     EXECUTE_BLOCK(callback, feeds, error);
                 }
                 
                 
             } isPostError:YES];
}
#pragma mark MyNewFeed
-(void) getMyNewFeedList:(GetMyNewFeedListCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    PBGetMyNewFeedListRequestBuilder* reqBuild = [PBGetMyNewFeedListRequest builder];
    
    //set request
    
    if([[UserManager sharedInstance]pbUser]!=nil){
        [reqBuild setUser:[[UserManager sharedInstance]pbUser]];
    }
    

    [reqBuild setDevice:[[UserManager sharedInstance]getCurrentDevice]];
    
    
    PBGetMyNewFeedListRequest* req = [reqBuild build];
    [builder setGetMyNewFeedListRequest:req];
    
    [self sendRequest:PBMessageTypeMessageGetMyNewFeedList requestBuilder:builder callback:^(PBDataResponse *response, NSError *error) {
        PBMyNewFeedList *feeds = response.getMyNewFeedListResponse.myNewFeedList;
        if (error == nil) {
            PPDebug(@"get my new feed successfully");
            EXECUTE_BLOCK(callback, feeds, nil);
        }
        else{
            // error here
            PPDebug(@"get my new feed fail");
            EXECUTE_BLOCK(callback, feeds, error);
        }
        
    } isPostError:YES];
    
}
-(void)getFeedById:(NSString*)feedId
          callback:(GetFeedByIdCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    PBGetFeedByIdRequestBuilder* reqBuilder = [PBGetFeedByIdRequest builder];
    [reqBuilder setFeedId:feedId];
    
    PBGetFeedByIdRequest* req = [reqBuilder build];
    [builder setGetFeedByIdRequest:req];
    
    [self sendRequest:PBMessageTypeMessageGetFeedById requestBuilder:builder callback:^(PBDataResponse *response, NSError *error) {
        if (error == nil) {
            PPDebug(@"get getFeedById successfully");
            EXECUTE_BLOCK(callback, response.getFeedByIdResponse.feed, error);
        }
        else{
            PPDebug(@"get getFeedById fail");
             EXECUTE_BLOCK(callback, nil, error);
        }
    }isPostError:YES];
    
}
-(void)readMyNewFeed:(NSString*)feedId
            callback:(ReadMyNewFeedCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    PBReadMyNewFeedRequestBuilder* reqBuilder = [PBReadMyNewFeedRequest builder];
    [reqBuilder setFeedId:feedId];
    PBReadMyNewFeedRequest* req = [reqBuilder build];
    [builder setReadMyNewFeedRequest:req];
    
    [self sendRequest:PBMessageTypeMessageReadMyNewFeed requestBuilder:builder callback:^(PBDataResponse *response, NSError *error) {
        if (error == nil) {
            PPDebug(@"get readMyNewFeed successfully");
           
        }
        else{
            PPDebug(@"get readMyNewFeed fail");
        }
        EXECUTE_BLOCK(callback, error);
    }isPostError:YES];
}
- (void)testReplyFeed
{
    srand((int)time(0));
    
    PBFeedActionBuilder* builder = [PBFeedAction builder];
    [builder setFeedId:@"548669e874f896540bae3cd8"];
    [builder setActionId:@""];
    [builder setUser:[[UserManager sharedInstance] pbUser]];
    [builder setText:[NSString stringWithFormat:@"this is a reply %d", rand()%100]];
    [builder setAvatar:@"http://test.com/avatar.jpg"];
    [builder setPosX:18];
    [builder setPosY:25.5];
    [builder setDate:(int)time(0)];
    
//    [self replyFeed:[builder build] callback:^(NSString *feedActionId, NSError *error) {
//        PPDebug(@"<replyFeed> error=%@", error);
//    }];
}

#pragma mark  - Photo Selection

- (void)selectPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] &&
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = NO;
        picker.delegate = self;
        
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIViewController* rootController = [appDelegate.window rootViewController];
        
        if (ISIOS8){
            
            picker.modalPresentationStyle = UIModalPresentationPopover;
            UIPopoverPresentationController* popVC = picker.popoverPresentationController;
            popVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
            popVC.sourceView = rootController.view;
            float screenWidth = [UIScreen mainScreen].bounds.size.width;
            float width = 400;
            popVC.sourceRect = ISIPAD ? CGRectMake((screenWidth-width)/2, -140, width, width) : rootController.view.bounds;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [rootController presentViewController:picker
                                             animated:NO
                                           completion:nil];
                
            });
            
        }
        else{
            if ([DeviceDetection isIPAD]){
                UIPopoverController *controller = [[UIPopoverController alloc] initWithContentViewController:picker];
                self.popVC = controller;
                CGRect popoverRect = CGRectMake((768-400)/2, -140, 400, 400);
                [controller presentPopoverFromRect:popoverRect
                                            inView:rootController.view
                          permittedArrowDirections:UIPopoverArrowDirectionUp
                                          animated:YES];
            }else {
                
                [rootController presentViewController:picker
                                             animated:YES
                                           completion:nil];
                
            }
        }
    }
}

- (void)selectCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = NO;
        picker.delegate = self;
        
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIViewController* rootController = [appDelegate.window rootViewController];
        
        if (ISIOS8){
            
            picker.modalPresentationStyle = UIModalPresentationPopover;
            UIPopoverPresentationController* popVC = picker.popoverPresentationController;
            popVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
            popVC.sourceView = rootController.view;
            float screenWidth = [UIScreen mainScreen].bounds.size.width;
            float width = 400;
            popVC.sourceRect = ISIPAD ? CGRectMake((screenWidth-width)/2, -140, width, width) : rootController.view.bounds;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [rootController presentViewController:picker
                                             animated:NO
                                           completion:nil];
                
            });
            
        }
        else{
            if ([DeviceDetection isIPAD]){
                UIPopoverController *controller = [[UIPopoverController alloc] initWithContentViewController:picker];
                self.popVC = controller;
                CGRect popoverRect = CGRectMake((768-400)/2, -140, 400, 400);
                [controller presentPopoverFromRect:popoverRect
                                            inView:rootController.view
                          permittedArrowDirections:UIPopoverArrowDirectionUp
                                          animated:YES];
            }else {
                
                [rootController presentViewController:picker
                                             animated:YES
                                           completion:nil];
            }
        }
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL userOriginalImage = YES;
    
    __block UIImage *image = [info objectForKey:userOriginalImage?UIImagePickerControllerOriginalImage:UIImagePickerControllerEditedImage];
    __block NSArray *userList = [[NSArray alloc]init];
    
    PPDebug(@"select original image size = %@", NSStringFromCGSize(image.size));
    if (image != nil){
        if (self){
    
            picker.navigationBarHidden = NO;
            // “编辑图片” 界面
            EditImageController* editImageCont = [[EditImageController alloc]init];
            editImageCont.originImage = image;
            editImageCont.cropSize = CGSizeMake(picker.view.frame.size.width, picker.view.frame.size.width);
            editImageCont.callBack = ^(UIImage *croppedImage){

                //获取已经切好的图片
                image = croppedImage;
                
                // "分享给谁" 界面
                ShareToWhichFriendViewController *shareToCont = [[ShareToWhichFriendViewController alloc]init];
                shareToCont.callBack = ^(NSArray *shareToWhoList){
                
                    //获取分享给谁的列表
                    userList = shareToWhoList;
                    
                    //创建新的feed
                    [self createFeedWithImage:image text:nil toUsers:userList callback:^(NSString *feedId, NSError *error) {
                        if(error == nil)
                        {
                            PPDebug(@"add feed success");
                            POST_SUCCESS_MSG(@"图片已分享");
                            [[FeedManager sharedInstance] clearShareToFriendsCache];
                            
                            // refresh timeline UI
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIMELINE_RELOAD_FROM_NETWORK object:nil];
                        }
                    }];
                    
                    //发出feed就检测
                    [[AutoTagManager sharedInstance] checkNeedAutoMakeTagWithUsers:userList];
                    
                    //界面返回
                    [picker dismissViewControllerAnimated:YES completion:^{
                        PPDebug(@"view controller go back success!");
                        
                        //若有需要跳转到首页则需要在appdelegate加入代码
                        AppDelegate *delegate = [[UIApplication  sharedApplication]delegate];
                        UIViewController* currentController = delegate.currentViewController;
                        
                        [currentController.navigationController popToRootViewControllerAnimated:YES];

                    }];
                };
                [picker pushViewController:shareToCont animated:YES];
            };
            [picker pushViewController:editImageCont animated:YES];
        }
    }

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePicker:picker];
}

- (void)dismissImagePicker:(UIImagePickerController *)picker
{
    if (self.popVC != nil) {
        [self.popVC dismissPopoverAnimated:YES];
        self.popVC = nil;
    }else{
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
    //当回退到home的时候，清除缓存的shareToList
    [[FeedManager sharedInstance]clearShareToFriendsCache];
    
    // set status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
