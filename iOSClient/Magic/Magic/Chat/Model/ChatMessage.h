//
//  ChatMessage.h
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum{
    MESSAGETYPE_ME = 0,
    MESSAGETYPE_OTHER
}MessageType;
@interface ChatMessage : NSObject

+(instancetype)messageWithDict:(NSDictionary *)dict;
@property(nonatomic,copy)       NSString        *content;
@property(nonatomic,copy)       NSString        *time;
@property (nonatomic,copy)      NSString        *image;
@property (nonatomic,copy)      NSString        *voice;

@property(nonatomic,assign)     MessageType      type;
@property(nonatomic,assign)     BOOL             hideTime;
@property(nonatomic, assign)    BOOL             hasImage;
@property (nonatomic, assign)   BOOL             hasVoice;
@property (nonatomic, assign)   BOOL             hasText;


@property (nonatomic,strong) UIImage   *myImage;
@end
