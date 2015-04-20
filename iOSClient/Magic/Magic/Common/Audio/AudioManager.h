//
//  AudioManager.h
//  Magic
//
//  Created by Teemo on 15/4/17.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioManager : NSObject

+ (id) sharedInstance;
+ (void)setPermission;


-(void)recorderStart;
-(void)recorderEnd;

-(void)playerStart;
-(void)playerStop;
-(void)playerPause;
-(void)playerResume;
@end