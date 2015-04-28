//
//  ChatService.h
//  Magic
//
//  Created by Teemo on 15/4/18.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"


typedef void (^SendChatCommonCallBackBlock)(NSError *error);
typedef void (^SendChatWithTextCallBackBlock)(NSError *error);
typedef void (^SendChatWithImageCallBackBlock)(NSError *error);
typedef void (^SendChatWithAudioCallBackBlock)(NSError *error);
typedef void (^GetChatListCallBackBlock)(NSArray *chatArray,NSError *error);
typedef void (^DownloadDataFileCallBackBlock)(NSString *filePath,NSError *error);

@interface ChatService : CommonService
DEF_SINGLETON_FOR_CLASS(UserService);


-(void)sendChatWithText:(NSString*)text
                  toUserId:(NSString*)toUserId
                  callback:(SendChatWithTextCallBackBlock)callback;
-(void)sendChatWithImage:(UIImage*)image
                   toUserId:(NSString*)toUserId
                   callback:(SendChatWithImageCallBackBlock)callback;

-(void)sendChatWithAudio:(NSString*)audioURL
                   toUserId:(NSString*)toUserId
                   callback:(SendChatWithAudioCallBackBlock)callback;

-(void)getChatList:(GetChatListCallBackBlock)callback;

-(void)reloadLatest;

- (void)downloadDataFile:(NSString*)dataURL
            saveFilePath:(NSString*)saveFilePath                // 下载完成后保存路径
            tempFilePath:(NSString*)tempFilePath                // 下载临时保存路径（用于断点续传）
            callback:(DownloadDataFileCallBackBlock)callback;


@end
