//
//  ChatService.h
//  Magic
//
//  Created by Teemo on 15/4/18.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"


typedef void (^SendCommonChatMessageCallBackBlock)(NSError *error);
typedef void (^SendTextChatMessageCallBackBlock)(NSError *error);
typedef void (^SendImageChatMessageCallBackBlock)(NSError *error);
typedef void (^GetChatListCallBackBlock)(NSArray *chatArray,NSError *error);

@interface ChatService : CommonService
DEF_SINGLETON_FOR_CLASS(UserService);


-(void)sendTextChatMessage:(NSString*)text
                  toUserId:(NSString*)toUserId
                  callback:(SendTextChatMessageCallBackBlock)callback;
-(void)sendImageChatMessage:(UIImage*)image
                   toUserId:(NSString*)toUserId
                   callback:(SendImageChatMessageCallBackBlock)callback;

-(void)getChatList:(GetChatListCallBackBlock)callback;
@end
