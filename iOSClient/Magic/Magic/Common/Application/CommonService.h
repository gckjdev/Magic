//
//  CommonService.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "BarrageNetworkRequest.h"
#import "Message.pb.h"
#import "LogUtil.h"
#import "UIUtils.h"
#import "PPDebug.h"
#import "UIViewUtils.h"
#import "BarrageConfigManager.h"
#import "Error.pb.h"

typedef void (^UploadImageCallbackBlock)(NSString *imageURL,NSError* error);
typedef void (^UploadAudioCallbackBlock)(NSString *audioURL,NSError* error);

@protocol CommonManagerProtocol <NSObject>

+ (id)defaultManager;

@end


@interface CommonService : NSObject {
    dispatch_queue_t  workingQueue;
    
    NSMutableDictionary*     workingQueueDict;    
    NSMutableDictionary*     workingQueueOperationDict;
}

- (dispatch_queue_t)getQueue:(NSString*)key;
- (dispatch_queue_t)defaultQueue;
- (dispatch_queue_t)systemQueue;
- (dispatch_queue_t)backgroundQueue;
- (NSOperationQueue*)getOperationQueue:(NSString*)key;

- (void)sendRequest:(int)type
     requestBuilder:(PBDataRequestBuilder*)requestBuilder
           callback:(PBResponseResultBlock)callback
        isPostError:(BOOL)isPostError;


-(void)uploadImage:(UIImage*)image
            prefix:(NSString*)prefix
          callback:(UploadImageCallbackBlock)callback;

-(void)uploadAudio:(NSData*)audio
            prefix:(NSString*)prefix
          callback:(UploadAudioCallbackBlock)callback;

- (NSError*)errorInput;

@end
