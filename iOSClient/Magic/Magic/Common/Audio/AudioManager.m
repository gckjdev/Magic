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

@property (nonatomic,copy) NSString *recordPath;

@property (nonatomic, strong) NSTimer *timer;



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
        _recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                nil];
    }
    return self;
}

#pragma mark - recorder
-(void)recorderInitWithPath:(NSURL*)PathURL{
   
    //按下录音
    if ([self canRecord]) {
        
         NSError *error = nil;
        [self recorderStop];
        
        _recordPath = PathURL.absoluteString;

        
        [self createFilePath];
        _recorder = [[AVAudioRecorder alloc] initWithURL:PathURL settings:_recorderSettingsDict error:&error];
        
        if (_recorder) {
            _recorder.meteringEnabled = YES;
            [_recorder prepareToRecord];

            
        } else
        {
            //            int errorCode = CFSwapInt32HostToBig ([error code]);
            PPDebug(@"Error: %@ " , [error description]);
            
        }
    }

}

//创建存储路径
-(void)createFilePath
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *savedImagePath = [docsDir
                                stringByAppendingPathComponent:DEFAULT_SAVE_VOICE];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:savedImagePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:savedImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
-(void)recorderStart
{
   [_recorder record];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    self.timer = timer;
}

-(void)recorderStop{
    
    if (_recorder&&_recorder.isRecording) {
         [_recorder stop];
        _recorder = nil;
    }
    else{
        _recorder = nil;
    }
   
    [self.timer invalidate];
    

    

}

-(void)recorderCancel{
    if (_recorder&&_recorder.isRecording) {
        [_recorder stop];
         _recorder = nil;
    }
    [_recorder deleteRecording];
    [self.timer invalidate];
}
- (void)updateImage {
    
    [self.recorder updateMeters];
    double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    float result  = 1000 * (float)lowPassResults;
    NSLog(@"%f", result);
    int no = 0;
    if (result > 0 && result <= 5) {
        no = 1;
    } else if ( result <= 10) {
        no = 2;
    } else if (result <= 20) {
        no = 3;
    } else if (result <= 30) {
        no = 4;
    } else if ( result <= 40) {
        no = 5;
    } else if (result <= 50) {
        no = 6;
    }else if  (result <= 60){
        no = 7;
    }else if  (result <= 70){
        no = 8;
    }else {
        no = 9;
    }
    
    if ([self.delegate respondsToSelector:@selector(recordingUpdateImage:)]) {
        [self.delegate recordingUpdateImage :no];
    }
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

    if(_player&&_player.isPlaying){
        [self playerStop];
        _player = nil;
    }
    else{
        _player = nil;
    }
    
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
        NSError * sessionError;
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(audioSession == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [audioSession setActive:YES error:nil];
        
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

-(void)cancel
{
    [self playerStop];
    [self recorderStop];
}

#pragma mark - player delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    EXECUTE_BLOCK(_playFinishCallBackBlock,flag);
}
@end
