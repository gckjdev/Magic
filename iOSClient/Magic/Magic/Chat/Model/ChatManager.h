//
//  ChatManager.h
//  Magic
//
//  Created by pipi on 15/4/26.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CommonManager.h"
#import "User.pb.h"
#import "APLevelDB.h"

@interface ChatManager : CommonManager
{
    APLevelDB* _db;
}

DEF_SINGLETON_FOR_CLASS(ChatManager);

- (NSArray*)chatList;
- (void)storeChatList:(NSArray*)pbFeedList;
- (void)insertChat:(PBChat*)chat;
- (NSUInteger)totalChatCount;


@end
