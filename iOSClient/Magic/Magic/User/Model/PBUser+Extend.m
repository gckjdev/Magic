//
//  PBUser+Extend.m
//  BarrageClient
//
//  Created by pipi on 15/2/27.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "PBUser+Extend.h"

@implementation PBUser (Extend)

- (PBUser*)miniInfo
{
    PBUserBuilder* builder = [PBUser builder];
    [builder setUserId:[self userId]];
    if ([[self nick] length] > 0){
        [builder setNick:[self nick]];
    }
    
    [builder setGender:[self gender]];
    
    if ([[self signature] length] > 0){
        [builder setSignature:[self signature]];
    }
    
    if ([[self location] length] > 0){
        [builder setLocation:[self location]];
    }
    
    if ([[self avatar] length] > 0){
        [builder setAvatar:[self avatar]];
    }
    
    if ([[self avatarBg] length] > 0){
        [builder setAvatarBg:[self avatarBg]];
    }

    if ([[self pushRegId] length] > 0){
        [builder setPushRegId:[self pushRegId]];
    }

    [builder setDeviceType:[self deviceType]];
    
    return [builder build];
}

@end
