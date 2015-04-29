//
//  ChatMessage.m
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import "ChatMessage.h"
#import "UserManager.h"

@implementation ChatMessage

+(instancetype)messageWithPBChat:(PBChat*)chat
{
    return [[self alloc]initWithPBChat:chat];
}
-(instancetype)initWithPBChat:(PBChat*)chat{
    
    if (self = [super init]) {
        _pbChat = chat;
        _content = _pbChat.text;
        _image = _pbChat.image;
        _voice = _pbChat.voice;
        _time = [NSDate dateWithTimeIntervalSince1970:_pbChat.createDate];
        _voiceDuration = _pbChat.duration;
        
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
        NSString *tmpStr = [[UserManager sharedInstance]userId];
        if ([_pbChat.fromUserId isEqualToString:tmpStr]) {
            _fromType = MESSAGEFROMTYPE_ME;
        }else{
            _fromType = MESSAGEFROMTYPE_OTHER;
        }
    }
    return self;
}
-(void)setPbChat:(PBChat *)pbChat{
    _pbChat = pbChat;
    _time = [NSDate dateWithTimeIntervalSince1970:_pbChat.createDate];
    _content = _pbChat.text;
    _image = _pbChat.image;
    _voice = _pbChat.voice;
    _voiceDuration = _pbChat.duration;
    
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
    NSString *tmpStr = [[UserManager sharedInstance]userId];
    if ([_pbChat.fromUserId isEqualToString:tmpStr]) {
        _fromType = MESSAGEFROMTYPE_ME;
    }else{
        _fromType = MESSAGEFROMTYPE_OTHER;
    }
}
@end
