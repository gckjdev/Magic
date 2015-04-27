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
#import "ChatManager.h"
#import "ASIHTTPRequest.h"
#import "FileUtil.h"

@implementation ChatService
IMPL_SINGLETON_FOR_CLASS(UserService)

-(void)getChatList:(GetChatListCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBGetChatListRequestBuilder* reqBuilder = [PBGetChatListRequest builder];
//    [reqBuilder setChatOffsetId:@""];
    [reqBuilder setLimit:30];
    PBGetChatListRequest *req = [reqBuilder build];
    
    [builder setGetChatListRequest:req];
    
    
    [self sendRequest:PBMessageTypeMessageGetChatList
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 NSArray *array = response.getChatListResponse.chat ;
                 if (error == nil) {
                     PPDebug(@"getChatList success");
                     
                     // store chat list locally
                     [[ChatManager sharedInstance] storeChatList:array];
                     
                     EXECUTE_BLOCK(callback,array,error);
                 }else{
                     PPDebug(@"getChatList  fail %@",error.description);
                     EXECUTE_BLOCK(callback,nil,error);
                 }
                 
                 
             } isPostError:YES];
    
}

-(void)sendChatWithAudio:(NSString*)audio
                toUserId:(NSString*)toUserId
                callback:(SendChatWithAudioCallBackBlock)callback
{
    PBChatBuilder *chatBuilder  = [PBChat builder];
    [chatBuilder setType:PBChatTypeVoiceChat];
    [chatBuilder setToUserId:toUserId];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:audio]];
    CommonService  *service =[[CommonService alloc]init];
    [service uploadAudio:data prefix:@"chat/voice" callback:^(NSString *audioURL, NSError *error) {
        if (error == nil) {
            PPDebug(@"upload : audioNUL  %@",audioURL);
            [chatBuilder setVoice:audioURL];
            [self sendChatCommonMessage:chatBuilder callback:^(NSError *error1) {
                
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
        else
        {
            PPDebug(@"sendImageChatMessage  fail %@",error.debugDescription);
            EXECUTE_BLOCK(callback,error);
        }
    }];
}

-(void)sendChatWithText:(NSString*)text
               toUserId:(NSString*)toUserId
               callback:(SendChatWithTextCallBackBlock)callback
{
    PBChatBuilder *chatBuilder  = [PBChat builder];
    [chatBuilder setText:text];
    [chatBuilder setToUserId:toUserId];
    [chatBuilder setType:PBChatTypeTextChat];
    [self sendChatCommonMessage:chatBuilder callback:^(NSError *error) {
        if (error == nil) {
            PPDebug(@"sendTextChatMessage  success");
        }else{
            PPDebug(@"sendTextChatMessage  fail %@",error.description);
        }
        EXECUTE_BLOCK(callback,error);
    }];
    
}
-(void)sendChatWithImage:(UIImage*)image
                toUserId:(NSString*)toUserId
                callback:(SendChatWithImageCallBackBlock)callback
{
    PBChatBuilder *chatBuilder  = [PBChat builder];
    [chatBuilder setType:PBChatTypePictureChat];
    [chatBuilder setToUserId:toUserId];
    
#warning prefix is nil
    [self uploadImage:image prefix:@"" callback:^(NSString *imageURL, NSError *error) {
        if (error == nil) {
            [chatBuilder setImage:imageURL];
            [self sendChatCommonMessage:chatBuilder callback:^(NSError *error1) {
                
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

-(void)sendChatCommonMessage:(PBChatBuilder*)pbChatBuilder
                    callback:(SendChatCommonCallBackBlock)callback

{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBSendChatRequestBuilder* reqBuilder = [PBSendChatRequest builder];
    
    [pbChatBuilder setChatId:@""];
    
    [pbChatBuilder setFromUserId: [[UserManager sharedInstance] userId]];
    [pbChatBuilder setFromUser:[[UserManager sharedInstance] pbUser]];
    
    [pbChatBuilder setCreateDate:(int)time(0)];
    [pbChatBuilder setSource:PBChatSourceFromAppIos];
    
    [reqBuilder setChat:[pbChatBuilder build]];
    
    // set request
    PBSendChatRequest* req = [reqBuilder build];
    [builder setSendChatRequest:req];
    
    
    [self sendRequest:PBMessageTypeMessageSendChat
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBChat* retChat = response.sendChatResponse.chat;
                 if (retChat != nil){
                     [[ChatManager sharedInstance] insertChat:retChat];
                 }
                 
                 EXECUTE_BLOCK(callback,error);
                
             } isPostError:YES];
}

-(void)reloadLatest
{
    // TODO reload chat list and post notification to UI to reload
}

// call this method to download data
- (void)downloadDataFile:(NSString*)dataURL
            saveFilePath:(NSString*)saveFilePath             // 下载完成后保存路径
            tempFilePath:(NSString*)tempFilePath             // 下载临时保存路径（用于断点续传）
        progressDelegate:(id)progressDelegate                // 下载进度回调
{
    if (dataURL == nil)
        return;
    
    NSURL* url = [NSURL URLWithString:dataURL];
    if (url == nil)
        return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ASIHTTPRequest* downloadHttpRequest = [ASIHTTPRequest requestWithURL:url];
        
        downloadHttpRequest.delegate = self;
        [downloadHttpRequest setAllowCompressedResponse:YES];
        //    [downloadHttpRequest setUsername:DEFAULT_HTTP_USER_NAME];
        //    [downloadHttpRequest setPassword:DEFAULT_HTTP_PASSWORD];
        
        [downloadHttpRequest setDownloadDestinationPath:saveFilePath];
        [downloadHttpRequest setTemporaryFileDownloadPath:tempFilePath];
        
        [downloadHttpRequest setDownloadProgressDelegate:progressDelegate];
        [downloadHttpRequest setAllowResumeForFileDownloads:YES];
        
        PPDebug(@"<downloadURL> URL=%@, Local Temp=%@, Store At=%@",
                url.absoluteString, tempFilePath, saveFilePath);
        [downloadHttpRequest startSynchronous];
        
        
    });
    
    
   
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:request.downloadDestinationPath] == NO){
        PPDebug(@"<downloadURL> %@ failure, file not downloaded", request.url);
        return;
    }
    
    PPDebug(@"<downloadURL> success, size=%lld", [FileUtil fileSizeAtPath:request.downloadDestinationPath]);
    return ;
}
@end
