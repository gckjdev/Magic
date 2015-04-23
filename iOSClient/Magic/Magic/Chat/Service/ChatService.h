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

@interface ChatService : CommonService
DEF_SINGLETON_FOR_CLASS(UserService);


-(void)sendChatWithText:(NSString*)text
                  toUserId:(NSString*)toUserId
                  callback:(SendChatWithTextCallBackBlock)callback;
-(void)sendChatWithImage:(UIImage*)image
                   toUserId:(NSString*)toUserId
                   callback:(SendChatWithImageCallBackBlock)callback;

-(void)sendChatWithAudio:(NSString*)audio
                   toUserId:(NSString*)toUserId
                   callback:(SendChatWithAudioCallBackBlock)callback;

-(void)getChatList:(GetChatListCallBackBlock)callback;
@end
