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
@interface AudioManager()
@property (nonatomic,strong) AVAudioRecorder   *recorder;
@property (nonatomic,strong) AVAudioPlayer   *player;
@property (nonatomic,strong) NSDictionary *recorderSettingsDict;
@property (nonatomic,copy) NSString *playName;
@end
@implementation AudioManager
+ (id) sharedInstance {
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
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
    }
}


#pragma recorder
-(void)recorderStart
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _playName = [NSString stringWithFormat:@"%@/play.aac",docDir];
    
    _recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,
                           [NSNumber numberWithInt:1000.0],AVSampleRateKey,
                           [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                           [NSNumber numberWithInt:8],AVLinearPCMBitDepthKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                           nil];
    
    PPDebug(@"neng : %@",_playName);
    //按下录音
    if ([self canRecord]) {
        
        NSError *error = nil;
        //必须真机上测试,模拟器上可能会崩溃
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_playName] settings:_recorderSettingsDict error:&error];
        
        if (_recorder) {
            _recorder.meteringEnabled = YES;
            [_recorder prepareToRecord];
            [_recorder record];
            
          
            
        } else
        {
//            int errorCode = CFSwapInt32HostToBig ([error code]);
//            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
    }
}
-(void)recorderEnd{
    [_recorder stop];
    _recorder = nil;
}
-(void)recorderCancel{
   
}


#pragma player
-(void)playerStart{
     NSError *playerError;
    _player = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_playName] error:&playerError];
    
    if (_player == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }else
    {
        
    }
}
-(void)playerStop
{
    [_player stop];
    
}
-(void)playerPause
{
    [_player pause];
}
-(void)playerResume{
   
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
@end
