//
//  CHAudioPlayer.m
//  BarrageClient
//
//  Created by HuangCharlie on 3/26/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "CHAudioPlayer.h"
#import "PPDebug.h"


@interface CHAudioPlayer ()

@property (nonatomic,assign) SystemSoundID soundID;

@end

@implementation CHAudioPlayer

IMPL_SINGLETON_FOR_CLASS(CHAudioPlayer);

//vibration
-(void)updateWithVibration
{
    self.soundID = kSystemSoundID_Vibrate;
}

-(void)updateWithSoundID:(SystemSoundID)soundId
{
    self.soundID = soundId;
}

//sound of imported resouces, like wav
-(void)updateWithResource:(NSString*)resourceName ofType:(NSString*)type
{
    [self dispose];
    NSString *path = [[NSBundle mainBundle] pathForResource:resourceName ofType:type];
    if (path) {
        //注册声音到系统
        NSURL* url = [NSURL fileURLWithPath:path];
        CFURLRef inFileURL = (__bridge CFURLRef)url;
        
        SystemSoundID tempSoundId;
        OSStatus error = AudioServicesCreateSystemSoundID(inFileURL, &tempSoundId);
        if(error == kAudioServicesNoError)
            self.soundID = tempSoundId;
        
    }
}


-(void)play
{
    AudioServicesPlaySystemSound(self.soundID);
}

-(void)dispose
{
    AudioServicesDisposeSystemSoundID(self.soundID);
}

@end
