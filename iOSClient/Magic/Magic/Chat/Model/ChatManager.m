//
//  ChatManager.m
//  Magic
//
//  Created by pipi on 15/4/26.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "ChatManager.h"
#import "LevelDBManager.h"
#import "UserManager.h"
#import "User.pb.h"
#import "ShareUserDBManager.h"

#define KEY_USER_CHAT_LIST         @"KEY_USER_CHAT_LIST"
#define DB_USER_CHAT               @"db_user_chat"

@interface ChatManager()

@property (strong, nonatomic) NSArray* chatList;

@end

@implementation ChatManager

IMPL_SINGLETON_FOR_CLASS(ChatManager);

- (id)init
{
    self = [super init];
    
    // TODO
    NSString* userId = [[UserManager sharedInstance] userId];
    NSString* dbName = [NSString stringWithFormat:@"%@_%@.db", DB_USER_CHAT, userId];
    _db = [[LevelDBManager defaultManager] db:dbName];
    return self;
}

- (NSArray*)chatList
{
    if (_chatList == nil){
        self.chatList = [self readChatListFromCache];
    }
    
    return _chatList;
}

- (NSArray*)readChatListFromCache
{
    NSArray* list = [_db reversedAllObjects];
    PPDebug(@"total %d chat message load from cache", [list count]);
    return list;
}

- (void)storeChatList:(NSArray*)pbChatList
{
    int count = 0;
    for (PBChat* pbChat in pbChatList){
        [_db setObject:[pbChat data] forKey:pbChat.chatId];
    }
    
    PPDebug(@"<storeChatList> total %d chat stored", count);
    
    NSArray* list = [self readChatListFromCache];
    self.chatList = list;
}

// 从本地数据库读取并且更新到内存list
- (void)reloadLocalList
{
    NSArray* list = [self readChatListFromCache];
    self.chatList = list;
}

- (void)addChat:(PBChat*)pbChat
{
    if ([pbChat.chatId length] == 0){
        return;
    }
    
    [_db setObject:[pbChat data] forKey:pbChat.chatId];
    [self reloadLocalList];
}


- (NSUInteger)totalChatCount
{
    NSUInteger count = [self.chatList count];
    return count;
}


@end
