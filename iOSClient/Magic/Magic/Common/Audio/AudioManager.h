//
//  AudioManager.h
//  Magic
//
//  Created by Teemo on 15/4/17.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


#define DEFAULT_SAVE_VOICE @"Voice"

@protocol AuidoManagerDelegate <NSObject>

@optional
-(void)recordingUpdateImage:(NSInteger) volumeNum;

@end
typedef void(^PlayFinishCallBackBlock) (BOOL flag);



@interface AudioManager : NSObject


@property (nonatomic,strong) AVAudioRecorder   *recorder;
@property (nonatomic,strong) AVAudioPlayer   *player;
@property (nonatomic, assign) float      recordDuration;
@property (nonatomic, assign) id<AuidoManagerDelegate>      delegate;

+ (instancetype) sharedInstance;
+ (void)setPermission;


-(void)recorderInitWithPath:(NSURL*)PathURL;
-(void)recorderStart;
-(void)recorderStop;
-(void)recorderCancel;

-(void)playInitWithFile:(NSURL*)fileURL;
-(void)playerStart;
-(void)playerStart:(PlayFinishCallBackBlock)callback;
-(void)playerStop;
-(void)playerPause;
-(void)playerResume;

//play，record销毁计时器等资源
-(void)cancel;
@end
