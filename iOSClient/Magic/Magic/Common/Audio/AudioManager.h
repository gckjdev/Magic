//
//  AudioManager.h
//  Magic
//
//  Created by Teemo on 15/4/17.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^PlayFinishCallBackBlock) (BOOL flag);



@interface AudioManager : NSObject


@property (nonatomic,strong) AVAudioRecorder   *recorder;
@property (nonatomic,strong) AVAudioPlayer   *player;


+ (instancetype) sharedInstance;
+ (void)setPermission;


-(void)recorderInitWithPath:(NSURL*)PathURL;
-(void)recorderStart;
-(void)recorderEnd;
-(void)recorderCancel;

-(void)playInitWithFile:(NSURL*)fileURL;
-(void)playerStart;
-(void)playerStart:(PlayFinishCallBackBlock)callback;
-(void)playerStop;
-(void)playerPause;
-(void)playerResume;
@end
