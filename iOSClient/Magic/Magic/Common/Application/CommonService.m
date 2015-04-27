//
//  CommonService.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonService.h"
#import "UserManager.h"
#import "CreateImageInfoProtocol.h"
#import "CreateJpegImageInfo.h"
#import "CdnManager.h"

#import "CreateFileInfo.h"


@implementation CommonService

- (id)init
{    
    self = [super init];    
    workingQueueDict = [[NSMutableDictionary alloc] init];
    workingQueueOperationDict = [[NSMutableDictionary alloc] init];
    return self;
}

- (NSOperationQueue*)getOperationQueue:(NSString*)key
{
    if (key == nil){
        NSLog(@"ERROR : Try to get operation queue but key is nil");
        return NULL;
    }
    
    NSOperationQueue *queue = [workingQueueOperationDict objectForKey:key];
    if (queue == nil){
        queue = [[NSOperationQueue alloc] init];
        [workingQueueOperationDict setObject:queue forKey:key];
    }
    
    return queue;            
}

- (dispatch_queue_t)getQueue:(NSString*)key
{
    if (key == nil){
        NSLog(@"ERROR : Try to get working queue but key is nil");
        return NULL;
    }
    
    dispatch_queue_t queue = NULL;
    id value = [workingQueueDict objectForKey:key];
    if (value == nil){
        queue = dispatch_queue_create([key UTF8String], NULL);
        [workingQueueDict setObject:queue forKey:key];
    }
    
    return queue;        
}

- (dispatch_queue_t)systemQueue
{
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

- (dispatch_queue_t)backgroundQueue
{
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
}

- (dispatch_queue_t)defaultQueue
{
    if (workingQueue == NULL){
        workingQueue = dispatch_queue_create("service queue", NULL);
    }
    
    return workingQueue;
}

- (void)sendRequest:(int)type
     requestBuilder:(PBDataRequestBuilder*)requestBuilder
           callback:(PBResponseResultBlock)callback
        isPostError:(BOOL)isPostError

{
    NSString* userId = [[UserManager sharedInstance] userId];

    if (userId){
        [requestBuilder setUserId:userId];
    }
    
    [requestBuilder setType:type];
    [requestBuilder setRequestId:(int)time(0)];
    
    PBDataRequest* request = [requestBuilder build];
    [BarrageNetworkRequest post:METHOD_BARRAGE
                            url:DEFAULT_SERVER_URL
                          queue:NULL
                        request:request
                       callback:callback
                    isPostError:isPostError];
    
}





- (id<CreateImageInfoProtocol>)getImageInfo
{
    return [[CreateJpegImageInfo alloc] init];
}
-(void)uploadImage:(UIImage*)image
            prefix:(NSString*)prefix
          callback:(UploadImageCallbackBlock)callback
{
    id<CreateImageInfoProtocol> imageInfo = [self getImageInfo];
    NSString* token = [[CdnManager sharedInstance] getUserDataToken];

    NSString* key = [imageInfo createKey:prefix];
    
    NSData* data = [imageInfo getImageData:image quality:1.0];
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
                                                   PPDebug(@"<uploadUserAvatar> upload image key(%@) percent(%.2f)", key, percent);
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
                      
                      // avatar url
                      NSString* url = [[CdnManager sharedInstance] getUserDataUrl:cdnKey];
                      
                      // now can send request to server
                      //                      [self updateUserAvatar:url callback:callback];
                      EXECUTE_BLOCK(callback,url ,nil);
                  }
                  else{
                      // failure
                      NSError* error = [NSError errorWithDomain:@"Error Upload Image to Server" code:PBErrorErrorUploadImage userInfo:nil];
                      EXECUTE_BLOCK(callback,nil ,error);
                  }
              } option:opt];
    
}
-(void)uploadAudio:(NSData*)audio
            prefix:(NSString*)prefix
          callback:(UploadAudioCallbackBlock)callback
{
    NSString* token = [[CdnManager sharedInstance] getUserDataToken];
    
    NSString* key = [CreateFileInfo audioCreateKey:prefix];
    NSData *data = audio;
  
    if (data == nil){
        NSError* error = nil;
        error = [NSError errorWithDomain:@"Error Create audio Data" code:PBErrorErrorCreateImage userInfo:nil];
        EXECUTE_BLOCK(callback, nil, error);
        return;
    }
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                                               progressHandler:^(NSString *key, float percent) {
                                                 
                                                   PPDebug(@"<uploadUserAvatar> upload image key(%@) percent(%.2f)", key, percent);
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
                      
                      NSString* url = [[CdnManager sharedInstance] getUserDataUrl:cdnKey];
                      
                      EXECUTE_BLOCK(callback,url ,nil);
                  }
                  else{
                      // failure
                      NSError* error = [NSError errorWithDomain:@"Error Upload Image to Server" code:PBErrorErrorUploadImage userInfo:nil];
                      EXECUTE_BLOCK(callback,nil ,error);
                  }
              } option:opt];
}
- (NSError*)errorInput
{
    NSError* error = [NSError errorWithDomain:@"Error Input Data!!!! Data Is Nil or Empty"
                                         code:PBErrorErrorIncorrectInputData
                                     userInfo:nil];
    return error;
}



@end
