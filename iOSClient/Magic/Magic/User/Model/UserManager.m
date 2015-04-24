//
//  UserManager.m
//  BarrageClient
//
//  Created by pipi on 14/12/8.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "UserManager.h"
#import "SnsService.h"
#import "PBUser+Extend.h"
#import "StringUtil.h"
#import "Constants.pb.h" 
#import "BarrageConfigManager.h"
#import "MiPushSDK.h"

#define KEY_USER_DATA           @"KEY_USER_DATA_1"
#define KEY_USER_NAME_FIRST     @"KEY_USER_NAME_FIRST"
#define KEY_USER_AVATAR         @"KEY_USER_AVATAR"
#define KEY_DEVICE_TOKEN        @"KEY_DEVICE_TOKEN"

@implementation UserManager

IMPL_SINGLETON_FOR_CLASS(UserManager)

- (void)storeUser:(PBUser*)pbUser
{
    if (pbUser == nil){
        return;
    }
    
    // save user data
    UD_SET(KEY_USER_DATA, [pbUser data]);

    // save ShareSDK info
    [[SnsService sharedInstance] saveSNSInfoIntoShareSDK:pbUser.snsUsers];
    
    [self setupMiPushAlias];
    
    [self reloadUserIntoMemory];
}

- (PBUser*)readUserFromStorage
{
    NSData* data = UD_GET(KEY_USER_DATA);
    if (data == nil){
        return nil;
    }
    
    @try {
        PBUser* newUser = [PBUser parseFromData:data];
        
        return newUser;
    }
    @catch (NSException *exception) {
        PPDebug(@"catch exception while parse user data, exception=%@", [exception description]);
        return nil;
    }
}

- (void)reloadUserIntoMemory
{
    // reload user data
    PBUser* loadUser = [self readUserFromStorage];
    if (loadUser != nil){
        _pbUser = loadUser;
        [self printUser];
    }
}

- (PBUser*)miniPbUser
{
    PBUser* user = [self pbUser];
    return [user miniInfo];
}

- (PBUser*)pbUser
{
    if (_pbUser == nil){
        _pbUser = [self readUserFromStorage];
    }
    
//#ifdef DEBUG
//#warning create dummy user data here, JUST for TEST!!!!!
//    if (_pbUser == nil){
//        
//        PBUserBuilder* builder = [PBUser builder];
//        [builder setUserId:@"1234"];
//        [builder setNick:@"Haha Hei"];
//        [builder setSignature:@"要的就是个性"];
//        [builder setAvatarBg:@"background01.png"];
//        [builder setLocation:@"广东 广州"];
//        [builder setGender:YES];
//        
//        _pbUser = [builder build];
//    }
//#endif
    
    return _pbUser;
}

- (NSString*)userId
{
    return [[self pbUser] userId];
}

- (BOOL)hasUser
{
    return ([self pbUser] != nil);
}

- (void)printUser
{
    PPDebug(@"userId(%@) email(%@) password(%@)", [_pbUser userId], [_pbUser email], [_pbUser password]);
}

- (BOOL)hasSetNameAndAvatar
{
//    BOOL hasSetName = [UD_GET(KEY_USER_NAME_FIRST) boolValue];
    NSString *userName =  _pbUser.nick;
    NSString *userimage = _pbUser.avatar;
    
    if ([userName isEqualToString:APP_DEFAULT_NICK]&&[userimage isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
- (NSString*)getSinaWeiboNick
{
    PBUser* user = [self pbUser];
    if (user == nil){
        return nil;
    }
    
    NSArray* users = user.snsUsers;
    for (PBSNSUser* snsUser in users){
        if (snsUser.type == ShareTypeSinaWeibo){
            return snsUser.nick;
        }
    }
    
    return nil;
}

- (NSString*)getQQNick
{
    PBUser* user = [self pbUser];
    if (user == nil){
        return nil;
    }
    
    NSArray* users = user.snsUsers;
    for (PBSNSUser* snsUser in users){
        if (snsUser.type == ShareTypeQQ || snsUser.type == ShareTypeQQSpace){
            return snsUser.nick;
        }
    }
    
    return nil;
}

- (NSString*)getWeChatNick
{
    PBUser* user = [self pbUser];
    if (user == nil){
        return nil;
    }
    
    NSArray* users = user.snsUsers;
    for (PBSNSUser* snsUser in users){
        if (snsUser.type == ShareTypeWeixiSession || snsUser.type == ShareTypeWeixiTimeline){
            return snsUser.nick;
        }
    }
    
    return nil;
}

- (PBBarrageSpeed)barrageSpeed
{
//#warning Test Barrage Style
//    return PBBarrageSpeedNormal;

    PBUser* pbUser = [self pbUser];
    return pbUser.bSpeed;
}

- (PBBarrageStyle)barrageStyle
{
//#warning Test Barrage Style
//    return PBBarrageStylePopSpring;
    
    PBUser* pbUser = [self pbUser];
    return pbUser.bStyle;
}

#define PASSWORD_KEY        @"PASSWORD_KEY_DRAW_DSAQC"

+ (NSString*)encryptPassword:(NSString*)rawPassword
{
    if ([rawPassword length] == 0){
        PPDebug(@"WARNING!!!!! <encryptPassword> but raw password is empty or nil");
        return nil;
    }
    
    NSString* password = [rawPassword encodeMD5Base64:PASSWORD_KEY];
    PPDebug(@"encrypt password is %@", password);
    PPDebug(@"user name: %@ password: %@", [[[UserManager sharedInstance] pbUser]mobile], [[[UserManager sharedInstance]pbUser]password]);
    return password;
}

-(PBDevice*)getCurrentDevice{
    PBDeviceBuilder *devBuilder = [PBDevice builder];
    [devBuilder setType:PBDeviceTypeDeviceTypeIphone];
    [devBuilder setModel:[[UIDevice currentDevice] model]];
    [devBuilder setOs:[DeviceDetection deviceOS]];
    [devBuilder setIsJailBroken:[MobClick isJailbroken]];
    [devBuilder setDeviceToken:[self getDeviceToken]];
    PBDevice *device = [devBuilder build];
    return device;
}

- (void)updateCurrentDevice
{
    PBDevice* device = [self getCurrentDevice];
    
    PBUserBuilder *userBuilder = [PBUser builder];
    
    [userBuilder setCurrentDevice:device];
    [userBuilder mergeFrom:_pbUser];
    _pbUser = [userBuilder build];
}

-(void)setUserBSpeed:(int)bSpeed
{
    PBUserBuilder *userBuilder = [PBUser builder];
    
    [userBuilder setBSpeed:bSpeed];
    [userBuilder mergeFrom:_pbUser];
    _pbUser = [userBuilder build];
}

-(void)setUserBtyle:(int)bStyle
{
    PBUserBuilder *userBuilder = [PBUser builder];
    
    [userBuilder setBStyle:bStyle];
    [userBuilder mergeFrom:_pbUser];
    _pbUser = [userBuilder build];
}
- (void)storeUser
{
    [self storeUser:_pbUser];
}


-(void)setupMiPushAlias
{
    if ([self hasUser]){
        PPDebug(@"set push alias to %@", [self userId]);
        [MiPushSDK setAlias:[self userId]];
    }
}

- (void)saveDeviceToken:(NSData*)deviceToken
{
    
    NSString *_deviceToken = [deviceToken description];
    _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString: @"<" withString: @""];
    _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString: @">" withString: @""];
    _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[NSUserDefaults standardUserDefaults] setObject:_deviceToken forKey:KEY_DEVICE_TOKEN];
    
    PPDebug(@"<saveDeviceToken> %@", _deviceToken);
}

- (NSString*)getDeviceToken
{
    return UD_GET(KEY_DEVICE_TOKEN);
}

@end
