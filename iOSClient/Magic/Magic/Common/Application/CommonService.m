//
//  CommonService.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonService.h"
#import "UserManager.h"

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

- (NSError*)errorInput
{
    NSError* error = [NSError errorWithDomain:@"Error Input Data!!!! Data Is Nil or Empty"
                                         code:PBErrorErrorIncorrectInputData
                                     userInfo:nil];
    return error;
}



@end
