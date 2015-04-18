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
            _type = MESSAGETYPE_OTHER;
        }else{
            _type = MESSAGETYPE_ME;
        }
        _hasText = true;
    }
    return self;
}
@end
