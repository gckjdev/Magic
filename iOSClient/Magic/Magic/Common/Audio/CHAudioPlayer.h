//
//  CHAudioPlayer.h
//  BarrageClient
//
//  Created by HuangCharlie on 3/26/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SynthesizeSingleton.h"

@interface CHAudioPlayer : NSObject
{
    
}

DEF_SINGLETON_FOR_CLASS(CHAudioPlayer);


// play system vibration of device
-(void)updateWithVibration;


//play system sound with id, more detail in system sound list
// system sound list at:
// https://github.com/TUNER88/iOSSystemSoundsLibrary
// check for certain sound if needed
-(void)updateWithSoundID:(SystemSoundID)soundId;


// play resource sound, need to import resource into project
-(void)updateWithResource:(NSString*)resourceName ofType:(NSString*)type;


// action of play
-(void)play;

@end


