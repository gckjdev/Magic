//
//  ChatMessage.h
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.pb.h"
typedef enum{
    MESSAGEFROMTYPE_ME = 0,
    MESSAGEFROMTYPE_OTHER
}MessageFromType;

typedef enum{
    MESSAGETYPE_TEXT = 0,
    MESSAGETYPE_IMAGE ,
    MESSAGETYPE_VOICE
}MessageType;
@interface ChatMessage : NSObject

//+(instancetype)messageWithDict:(NSDictionary *)dict;
+(instancetype)messageWithPBChat:(PBChat*)chat;
@property(nonatomic,copy)       NSString        *content;
@property(nonatomic,strong)     NSDate            *time;
@property (nonatomic,copy)      NSString        *image;
@property (nonatomic,copy)      NSString        *voice;

@property (nonatomic,copy)      NSString        *fromUserId;
@property (nonatomic,copy)      NSString        *fromUser_Ava;

@property(nonatomic,assign)     MessageType      type;
@property (nonatomic, assign)   MessageFromType  fromType;
@property(nonatomic,assign)     BOOL             hideTime;



@property (nonatomic,strong) PBChat*   pbChat;

@property (nonatomic,strong) UIImage   *myImage;
@end
