//
//  AudioManager.m
//  Magic
//
//  Created by Teemo on 15/4/17.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "AudioManager.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "PPDebug.h"
#import "FileUtil.h"

@interface AudioManager()<AVAudioPlayerDelegate>

@property (nonatomic,strong) NSDictionary *recorderSettingsDict;
@property (nonatomic,copy) NSString *playName;
@property (nonatomic,copy) PlayFinishCallBackBlock playFinishCallBackBlock;
@end

@implementation AudioManager

+ (instancetype) sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[AudioManager alloc] init];
    });
    return _sharedObject;
}

+ (void)setPermission
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            PPDebug(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - recorder
-(void)recorderInitWithPath:(NSURL*)PathURL{
    _recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                            [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                            [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                            [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                            nil];
    //按下录音
    if ([self canRecord]) {
        
        NSError *error = nil;
        _recorder = nil;
        _recorder = [[AVAudioRecorder alloc] initWithURL:PathURL settings:_recorderSettingsDict error:&error];
        
        if (_recorder) {
            _recorder.meteringEnabled = YES;
            [_recorder prepareToRecord];
            
//            [_recorder record];
            
            
        } else
        {
            //            int errorCode = CFSwapInt32HostToBig ([error code]);
            PPDebug(@"Error: %@ " , [error description]);
            
        }
    }

}

-(void)recorderStart
{
   [_recorder record];
}

-(void)recorderEnd{
    
    [_recorder stop];
}

-(void)recorderCancel{
    [_recorder stop];
    [_recorder deleteRecording];
}


#pragma  mark - player

-(void)playInitWithFile:(NSURL*)fileURL{
    

    NSError *playerError;
    if(_player != nil){
        [self playerStop];
        _player = nil;
    }

    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&playerError];
    
    _player.delegate = self;
    
    if (_player == nil)
    {
        PPDebug(@"ERror creating player: %@", [playerError description]);
    }else
    {
        PPDebug(@"creating player success");
    }
}

-(void)playerStart{
    
    [_player play];
    
}

-(void)playerStart:(PlayFinishCallBackBlock)callback
{
    [_player play];
    _playFinishCallBackBlock = callback;
}

-(void)playerStop
{
//    if(_player.isPlaying){
//        EXECUTE_BLOCK(_playFinishCallBackBlock,NO);
//    }
    [_player stop];
    
}
-(void)playerPause
{
    [_player pause];
}
-(void)playerResume{
   //Not use temporarily
}


//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    
    return bCanRecord;
}

#pragma mark - player delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    EXECUTE_BLOCK(_playFinishCallBackBlock,flag);
}
@end
