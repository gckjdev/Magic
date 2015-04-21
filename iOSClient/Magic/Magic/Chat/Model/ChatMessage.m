//
//  ChatMessage.m
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage
+(instancetype)messageWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        _content = dict[@"content"];
        _time = dict[@"time"];
        if ([dict[@"type"] integerValue] == 0) {
            _fromType = MESSAGEFROMTYPE_OTHER;
        }else{
            _fromType = MESSAGEFROMTYPE_ME;
        }
        
    }
    return self;
}
-(void)setPbChat:(PBChat *)pbChat{
    _pbChat = [pbChat copy];
//    _time = pbChat.createDate;
    _content = _pbChat.text;
    _image = _pbChat.image;
    _voice = _pbChat.voice;
    
    _fromUserId = _pbChat.fromUserId;
    _fromUser_Ava = _pbChat.fromUser.avatar;
    
    if (_pbChat.type == PBChatTypeTextChat) {
        _type = MESSAGETYPE_TEXT;
    }
    else if(_pbChat.type == PBChatTypePictureChat){
        _type = MESSAGETYPE_IMAGE;
    }
    else if(_pbChat.type == PBChatTypeVoiceChat){
        _type = MESSAGETYPE_VOICE;
    }
}
@end
