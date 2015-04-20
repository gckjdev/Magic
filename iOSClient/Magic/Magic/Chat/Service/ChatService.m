//
//  ChatService.m
//  Magic
//
//  Created by Teemo on 15/4/18.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "ChatService.h"
#import "User.pb.h"
#import "UserManager.h"
#import "StringUtil.h"
#import "PPDebug.h"



@implementation ChatService
IMPL_SINGLETON_FOR_CLASS(UserService)

-(void)getChatList:(GetChatListCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBGetChatListRequestBuilder* reqBuilder = [PBGetChatListRequest builder];
    
    PBGetChatListRequest *req = [reqBuilder build];
    
    [builder setGetChatListRequest:req];
    
    
    [self sendRequest:PBMessageTypeMessageGetChatList
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 NSArray *array = [response.getChatListResponse.chat copy];
                 if (error == nil) {
                     PPDebug(@"getChatList  success");
                     EXECUTE_BLOCK(callback,array,error);
                 }else{
                     PPDebug(@"getChatList  fail %@",error.description);
                     EXECUTE_BLOCK(callback,nil,error);
                 }
                 
                 
             } isPostError:YES];
    
}
-(void)sendTextChatMessage:(NSString*)text
                  toUserId:(NSString*)toUserId
                  callback:(SendTextChatMessageCallBackBlock)callback
{
    PBChatBuilder *chatBuilder  = [PBChat builder];
    [chatBuilder setText:text];
    [chatBuilder setToUserId:toUserId];
    [chatBuilder setType:PBChatTypeTextChat];
    [self sendCommonChatMessage:chatBuilder callback:^(NSError *error) {
        if (error == nil) {
            PPDebug(@"sendTextChatMessage  success");
        }else{
            PPDebug(@"sendTextChatMessage  fail %@",error.description);
        }
        EXECUTE_BLOCK(callback,error);
    }];
    
}
-(void)sendImageChatMessage:(UIImage*)image
                   toUserId:(NSString*)toUserId
                   callback:(SendImageChatMessageCallBackBlock)callback
{
    PBChatBuilder *chatBuilder  = [PBChat builder];
    [chatBuilder setType:PBChatTypePictureChat];
    [chatBuilder setToUserId:toUserId];
    
    [self uploadImage:image prefix:@"" callback:^(NSString *imageURL, NSError *error) {
        if (error == nil) {
            [chatBuilder setImage:imageURL];
            [self sendCommonChatMessage:chatBuilder callback:^(NSError *error1) {
                
                if (error1 ==nil) {
                    PPDebug(@"sendImageChatMessage  success");
                }
                else
                {
                    PPDebug(@"sendImageChatMessage  fail %@",error1.debugDescription);
                }
                EXECUTE_BLOCK(callback,error1);
            }];
        }
        else{
             PPDebug(@"sendImageChatMessage  fail %@",error.debugDescription);
             EXECUTE_BLOCK(callback,error);
        }
       
    }];
}

-(void)sendCommonChatMessage:(PBChatBuilder*)pbChatBuilder
                    callback:(SendCommonChatMessageCallBackBlock)callback

{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBSendChatRequestBuilder* reqBuilder = [PBSendChatRequest builder];
    
    [pbChatBuilder setFromUser:nil];
    [pbChatBuilder setChatId:nil];
    [pbChatBuilder setSessionId:nil];
    
    [pbChatBuilder setFromUserId: [[UserManager sharedInstance] userId]];
    
    [pbChatBuilder setCreateDate:(int)time(0)];
    
    
    [reqBuilder setChat:[pbChatBuilder build]];
    
    
    // set request
    PBSendChatRequest* req = [reqBuilder build];
    [builder setSendChatRequest:req];
    
    
    [self sendRequest:PBMessageTypeMessageSendChat
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 EXECUTE_BLOCK(callback,error);
                
             } isPostError:YES];
}
@end
