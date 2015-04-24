//
//  UserService.m
//  BarrageClient
//
//  Created by pipi on 14/12/5.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "UserService.h"
#import "UserManager.h"
#import "User.pb.h"
#import "GTMBase64.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "InviteCodeManager.h"
#import "BarrageConfigManager.h"

#import "CdnManager.h"
#import "CreateJpegImageInfo.h"
#import "CreateImageInfoProtocol.h"
#import "UserTimelineFeedController.h"
#import "BarrageConfigManager.h"



#import <SMS_SDK/SMS_SDK.h>

#define ERROR_SNS_DOMAIN        @"ErrorSNSDomain"

@implementation UserService

IMPL_SINGLETON_FOR_CLASS(UserService)

#pragma mark - Registeration User Methods

- (void)regiseterUserByEmail:(NSString*)email
                    password:(NSString*)password
                  inviteCode:(NSString*)inviteCode
                    callback:(UserServiceCallBackBlock)callback

{
    // build user
    PBUserBuilder* userBuilder = [PBUser builder];
    [userBuilder setEmail:email];
    [userBuilder setPassword:password];
    
    [self regiseterUser:PBRegisterTypeRegEmail
            userBuilder:userBuilder
             inviteCode:inviteCode
               callback:callback];
    
}

- (void)regiseterUserByMobile:(NSString*)mobile
                     password:(NSString*)password
                   inviteCode:(NSString*)inviteCode
                     callback:(UserServiceCallBackBlock)callback
{
    // build user
    PBUserBuilder* userBuilder = [PBUser builder];
    [userBuilder setMobile:mobile];
    [userBuilder setPassword:password];
    
    [self regiseterUser:PBRegisterTypeRegMobile
            userBuilder:userBuilder
             inviteCode:inviteCode
               callback:callback];
}

- (void)registerBySns:(ShareType)shareType
           inviteCode:(NSString*)inviteCode
             callback:(UserServiceCallBackBlock)callback
{
    if (shareType == ShareTypeAny){
        return;
    }
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];  // _appDelegate.viewDelegate]; TODO check
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:[BarrageConfigManager snsOfficialId:shareType]],
                                    SHARE_TYPE_NUMBER(shareType),
                                    nil]];
    
    [ShareSDK authWithType:shareType                                            //需要授权的平台类型
                   options:authOptions                                          //授权选项，包括视图定制，自动授权
                    result:^(SSAuthState state, id<ICMErrorInfo> error) {       //授权返回后的回调方法
                        if (state == SSAuthStateSuccess)
                        {
                            // TODO save user weibo bind info, get user infomation here and upload user information to server
//                            [self readUserInfoAndUpdateToServer:shareType];
                            
                            PPDebug(@"autheticate shareType(%d) success", shareType);

                            [self readUserInfoAndRegisterUser:shareType
                                                   inviteCode:inviteCode
                                                     callback:callback];
                            
                        }
                        else if (state == SSAuthStateFail)
                        {
                            PPDebug(@"autheticate shareType(%d) failure, error=%@", shareType, [error errorDescription]);
                            NSError* err = [NSError errorWithDomain:ERROR_SNS_DOMAIN code:PBErrorErrorSnsAuthFail userInfo:nil];
                            EXECUTE_BLOCK(callback, nil, err);
                        }
                        else if (state == SSAuthStateBegan){
                            PPDebug(@"autheticate shareType(%d) began", shareType);
                        }
                        else if (state == SSAuthStateCancel){
                            PPDebug(@"autheticate shareType(%d) cancel", shareType);
                            NSError* err = [NSError errorWithDomain:ERROR_SNS_DOMAIN code:PBErrorErrorSnsAuthCancel userInfo:nil];
                            EXECUTE_BLOCK(callback, nil, err);
                        }
                        else{
                            PPDebug(@"autheticate shareType(%d) unknown state(%d), error=%@", shareType, state, [error errorDescription]);
                            NSError* err = [NSError errorWithDomain:ERROR_SNS_DOMAIN code:PBErrorErrorSnsAuthErrorUnknown userInfo:nil];
                            EXECUTE_BLOCK(callback, nil, err);
                        }
                    }];

}

- (NSString*)createCredentialString:(id<ISSPlatformCredential>)credential
{
    // store creditial data locally and send to server
    NSData *credentialData = [ShareSDK dataWithCredential:credential];
    NSString* credentialString = [GTMBase64 stringByEncodingData:credentialData];
    return credentialString;
}


- (PBSNSUser*)createSNSUser:(id<ISSPlatformUser>)snsUser
                 credential:(id<ISSPlatformCredential>)credential
                  shareType:(ShareType)shareType
{
    PBSNSUserBuilder* builder = [PBSNSUser builder];
    [builder setType:shareType];
    [builder setUserId:snsUser.uid];
    [builder setNick:snsUser.nickname];
    [builder setAccessToken:credential.token];
    [builder setExpiredTime:[credential.expired timeIntervalSince1970]];
    [builder setCredential:[self createCredentialString:credential]];
    
    return [builder build];
}

- (void)setSnsId:(NSString*)snsId shareType:(ShareType)shareType userBuilder:(PBUserBuilder*)userBuilder
{
    switch (shareType){
        case ShareTypeSinaWeibo:
            [userBuilder setSinaId:snsId];
            break;
        case ShareTypeQQ:
        case ShareTypeQQSpace:
            [userBuilder setQqOpenId:snsId];
            break;
        case ShareTypeWeixiSession:
        case ShareTypeWeixiTimeline:
            [userBuilder setWeixinId:snsId];
            break;
        default:
            break;
    }
    
    return;
}

- (PBUserBuilder*)createPBUser:(id<ISSPlatformUser>)snsUser
                    credential:(id<ISSPlatformCredential>)credential
                     shareType:(ShareType)shareType
{
 
    PBUserBuilder* builder = [PBUser builder];

    [builder setNick:snsUser.nickname];
    [builder setGender:(snsUser.gender == 0) ? true : false];
    [builder setLocation:[snsUser.sourceData objectForKey:@"location"]];
    [builder setAvatar:snsUser.profileImage];
    
    [self setSnsId:snsUser.uid shareType:shareType userBuilder:builder];
    
    // add SNS
    PBSNSUser* pbSnsUser = [self createSNSUser:snsUser
                                  credential:credential
                                   shareType:shareType];
    
    if (pbSnsUser){
        [builder addSnsUsers:pbSnsUser];
    }
    
    // set dummy user ID
    [builder setUserId:@""];
    
    return builder;
}

- (void)readUserInfoAndRegisterUser:(ShareType)shareType
                         inviteCode:(NSString*)inviteCode
                           callback:(UserServiceCallBackBlock)callback
{
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:shareType];      //传入获取授权信息的类型
    if (credential == nil){
        return;
    }
    
    id<ISSPlatformCredential> cred = (id<ISSPlatformCredential>)credential;             //转换为OAuth2授权凭证
    
    PPDebug(@"<readUserInfoAndRegisterUser> user access token(%@), expire(%@)", [cred token], [cred expired]);
    PPDebug(@"<readUserInfoAndRegisterUser> credential(%@), oauth2(%@)", [credential description], [cred description]);
    
    // read user information and upload to server
    [ShareSDK getUserInfoWithType:shareType                                     //平台类型
                      authOptions:nil                                           //授权选项
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {             //返回回调
                               if (result){
                                   
                                   PPDebug(@"<readUserInfo> success, userInfo(%@)", [userInfo.sourceData description]);
                                   
                                   PBUserBuilder* pbUserBuilder = [self createPBUser:userInfo
                                                                          credential:cred
                                                                           shareType:shareType];
                                   
                                   [self regiseterUser:(PBRegisterType)shareType
                                           userBuilder:pbUserBuilder
                                            inviteCode:inviteCode
                                              callback:callback];
                                   
                               }
                               else{
                                   PPDebug(@"<getUserInfo> error(%d) desc(%@)", error.errorCode, ERROR_SNS_DOMAIN);
                                   NSError* err = [NSError errorWithDomain:ERROR_SNS_DOMAIN code:PBErrorErrorSnsGetUserInfo userInfo:nil];
                                   EXECUTE_BLOCK(callback, nil, err);
                               }
                           }];
    
    
}


- (void)regiseterUser:(PBRegisterType)type
          userBuilder:(PBUserBuilder*)userBuilder
           inviteCode:(NSString*)inviteCode
             callback:(UserServiceCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    // build user
    [userBuilder setRegDate:(int)time(0)];
    
//#ifdef DEBUG
//#warning 模拟用户昵称和头像
    if ([userBuilder.nick length] == 0){
        if ([BarrageConfigManager isInReviewVersion]){
            [userBuilder setNick:APP_DEFAULT_NICK];
        }
        else{
            [userBuilder setNick:[UIUtils getUserDeviceName]];
        }
    }
    
//    if ([userBuilder.avatar length] == 0){
//        [userBuilder setAvatar:@"http://pic1.zhimg.com/82d2a472b549c8aa2346d71b8e94534e_m.jpg"];
//    }
//#endif
    
    [userBuilder setUserId:@""];            // set dummy userId here
    PBUser* user = [userBuilder build];
    
    // build regisetr request
    PBRegisterUserRequestBuilder* reqBuilder = [PBRegisterUserRequest builder];
    [reqBuilder setUser:user];
    [reqBuilder setType:type];
    if (inviteCode){
        [reqBuilder setInviteCode:inviteCode];
    }
    
    // set request
    PBRegisterUserRequest* req = [reqBuilder build];
    [builder setRegisterUserRequest:req];
    
    [self sendRequest:PBMessageTypeMessageRegisterUser
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBUser* pbUser = response.registerUserResponse.user;
                 if (error == nil && pbUser != nil){
                     // TODO notify data change
                     // success, store user data here
//                     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HEADEREFRESHING
//                                                                         object:nil];
                     [[UserManager sharedInstance] storeUser:pbUser];
                     
                     // TODO post notification to reload UI
                 }
                 else{
                     // no user data, error here
                 }
                 
                 EXECUTE_BLOCK(callback, pbUser, error);
                 
             } isPostError:YES];
    
}

#pragma mark - Login User Methods

- (void)loginUserByEmail:(NSString*)email
                password:(NSString*)password
                callback:(UserServiceCallBackBlock)callback
{
    PBLoginUserRequestBuilder* builder = [PBLoginUserRequest builder];
    [builder setType:PBLoginTypeLoginEmail];
    [builder setEmail:email];
    [builder setPassword:password];
    
    [self loginUser:builder
           callback:callback];
}

- (void)loginUserByMobile:(NSString*)mobile
                 password:(NSString*)password
                 callback:(UserServiceCallBackBlock)callback
{
    PBLoginUserRequestBuilder* builder = [PBLoginUserRequest builder];
    [builder setType:PBLoginTypeLoginMobile];
    [builder setMobile:mobile];
    [builder setPassword:password];
    
    [self loginUser:builder
           callback:callback];
}

- (void)readUserInfoAndLoginUser:(ShareType)shareType
                        callback:(UserServiceCallBackBlock)callback
{
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:shareType];      //传入获取授权信息的类型
    if (credential == nil){
        return;
    }
    
    id<ISSPlatformCredential> cred = (id<ISSPlatformCredential>)credential;             //转换为OAuth2授权凭证
    
    PPDebug(@"<readUserInfoAndLoginUser> user access token(%@), expire(%@)", [cred token], [cred expired]);
    PPDebug(@"<readUserInfoAndLoginUser> credential(%@), oauth2(%@)", [credential description], [cred description]);
    
    // read user information and upload to server
    [ShareSDK getUserInfoWithType:shareType                                     //平台类型
                      authOptions:nil                                           //授权选项
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {             //返回回调
                               if (result){
                                   
                                   PPDebug(@"<readUserInfo> success, userInfo(%@)", [userInfo.sourceData description]);
                                   
                                   PBSNSUser* pbSnsUser = [self createSNSUser:userInfo
                                                                   credential:credential
                                                                    shareType:shareType];

                                   PBLoginUserRequestBuilder* builder = [PBLoginUserRequest builder];
                                   [builder setType:shareType];
                                   [builder setSnsId:userInfo.uid];
                                   [builder setSnsUser:pbSnsUser];
                                   
                                   [self loginUser:builder
                                          callback:callback];
                                   
                               }
                               else{
                                   PPDebug(@"<getUserInfo> error(%d) desc(%@)", error.errorCode, ERROR_SNS_DOMAIN);
                                   NSError* err = [NSError errorWithDomain:ERROR_SNS_DOMAIN code:PBErrorErrorSnsGetUserInfo userInfo:nil];
                                   EXECUTE_BLOCK(callback, nil, err);
                               }
                           }];
    
    
}


- (void)loginUserBySns:(ShareType)shareType
              callback:(UserServiceCallBackBlock)callback
{
    if (shareType == ShareTypeAny){
        return;
    }
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    if (shareType == ShareTypeSinaWeibo || shareType == ShareTypeQQSpace){
        //在授权页面中添加关注官方微博
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:[BarrageConfigManager snsOfficialId:shareType]],
                                        SHARE_TYPE_NUMBER(shareType),
                                        nil]];
    }
    
    [ShareSDK authWithType:shareType                                            //需要授权的平台类型
                   options:authOptions                                          //授权选项，包括视图定制，自动授权
                    result:^(SSAuthState state, id<ICMErrorInfo> error) {       //授权返回后的回调方法
                        if (state == SSAuthStateSuccess)
                        {
                            // TODO save user weibo bind info, get user infomation here and upload user information to server
                            //                            [self readUserInfoAndUpdateToServer:shareType];
                            
                            PPDebug(@"autheticate shareType(%d) success", shareType);
                            
                            [self readUserInfoAndLoginUser:shareType
                                                  callback:callback];
                            
                        }
                        else if (state == SSAuthStateFail)
                        {
                            PPDebug(@"autheticate shareType(%d) failure, error=%@", shareType, [error errorDescription]);
                            NSError* err = [NSError errorWithDomain:ERROR_SNS_DOMAIN code:PBErrorErrorSnsAuthFail userInfo:nil];
                            EXECUTE_BLOCK(callback, nil, err);
                        }
                        else if (state == SSAuthStateBegan){
                            PPDebug(@"autheticate shareType(%d) began", shareType);
                        }
                        else if (state == SSAuthStateCancel){
                            PPDebug(@"autheticate shareType(%d) cancel", shareType);
                            NSError* err = [NSError errorWithDomain:ERROR_SNS_DOMAIN code:PBErrorErrorSnsAuthCancel userInfo:nil];
                            EXECUTE_BLOCK(callback, nil, err);
                        }
                        else{
                            PPDebug(@"autheticate shareType(%d) unknown state(%d), error=%@", shareType, state, [error errorDescription]);
                            NSError* err = [NSError errorWithDomain:ERROR_SNS_DOMAIN code:PBErrorErrorSnsAuthErrorUnknown userInfo:nil];
                            EXECUTE_BLOCK(callback, nil, err);
                        }
                    }];

}

- (void)loginUser:(PBLoginUserRequestBuilder*)reqBuilder
         callback:(UserServiceCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    // build login request
    PBLoginUserRequest* req = [reqBuilder build];
    [builder setLoginUserRequest:req];
    
    [self sendRequest:PBMessageTypeMessageLoginUser
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBUser* pbUser = response.loginUserResponse.user;
                 if (error == nil && pbUser != nil){
                     // TODO change notification name
                     // success, store user data here
//                     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HEADEREFRESHING
//                                                                         object:nil];
                     [[UserManager sharedInstance] storeUser:pbUser];
                     
                     // TODO post notifcaiton
                 }
                 else{
                     // no user data, error here
                 }
                 
                 EXECUTE_BLOCK(callback, pbUser, error);
                 
             } isPostError:YES];
    
}


#pragma mark - Update User Methods

- (void)updateUser:(PBUser*)pbUser callback:(UserServiceCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];

    PBUpdateUserInfoRequestBuilder* reqBuilder = [PBUpdateUserInfoRequest builder];
    [reqBuilder setUser:pbUser];
    
    // set request
    PBUpdateUserInfoRequest* req = [reqBuilder build];
    [builder setUpdateUserInfoRequest:req];
    
    [self sendRequest:PBMessageTypeMessageUpdateUserInfo
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBUser* pbUser = response.updateUserInfoResponse.user;
                 if (error == nil && pbUser != nil){
                     // success
                     [[UserManager sharedInstance] storeUser:pbUser];
                 }
                 else{
                     // no user data, error here
                 }
                 
                 EXECUTE_BLOCK(callback, pbUser, error);
                 
             } isPostError:YES];

}

- (void)updateUserAvatar:(NSString*)avatar callback:(UserServiceCallBackBlock)callback
{
    PBUser* pbUser = [[UserManager sharedInstance] pbUser];
    if (pbUser == nil || [avatar length] == 0){
        return;
    }
    // build nick here
    PBUserBuilder* pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setAvatar:avatar];
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}

- (void)updateUserBackground:(NSString*)bgUrl callback:(UserServiceCallBackBlock)callback
{
    PBUser* pbUser = [[UserManager sharedInstance] pbUser];
    if (pbUser == nil || [bgUrl length] == 0){
        return;
    }
    // build nick here
    PBUserBuilder* pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setAvatarBg:bgUrl];
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}


- (void)updateUserNick:(NSString*)nickName callback:(UserServiceCallBackBlock)callback
{
    PBUser* pbUser = [[UserManager sharedInstance] pbUser];
    if (pbUser == nil || [nickName length] == 0){
        return;
    }
    // build nick here
    PBUserBuilder* pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setNick:nickName];

    [self updateUser:[pbUserBuilder build] callback:callback];
}

- (void)updateUserSignature:(NSString*)value callback:(UserServiceCallBackBlock)callback
{
    PBUser *pbUser = [[UserManager sharedInstance] pbUser];
    if (pbUser == nil || [value length] == 0) {
        return;
    }
    
    PBUserBuilder *pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setSignature:value];
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}

- (void)updateUserGender:(BOOL)value callback:(UserServiceCallBackBlock)callback
{
    PBUser *pbUser = [[UserManager sharedInstance]pbUser];
    if (pbUser == nil) {
        return;
    }
    PBUserBuilder *pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setGender:value];
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}

- (void)updateUserBarrageSpeed:(PBBarrageSpeed)value callback:(UserServiceCallBackBlock)callback
{
    PBUser *pbUser = [[UserManager sharedInstance]pbUser];
    if (pbUser == nil) {
        return;
    }
    PBUserBuilder *pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setBSpeed:value];
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}

- (void)updateUserBarrageStyle:(PBBarrageStyle)value callback:(UserServiceCallBackBlock)callback
{
    PBUser *pbUser = [[UserManager sharedInstance]pbUser];
    if (pbUser == nil) {
        return;
    }
    PBUserBuilder *pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setBStyle:value];
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}


- (void)updateUserQQopenId:(NSString*)value callback:(UserServiceCallBackBlock)callback
{
    PBUser *pbUser = [[UserManager sharedInstance]pbUser];
    if (pbUser == nil) {
        return;
    }
    PBUserBuilder *pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    //  TODO
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}

- (void)updateUserSinaId:(NSString*)value callback:(UserServiceCallBackBlock)callback
{
    PBUser *pbUser = [[UserManager sharedInstance]pbUser];
    if (pbUser == nil) {
        return;
    }
    PBUserBuilder *pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setSinaId:value];
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}

- (void)updateUserWeixinId:(NSString*)value callback:(UserServiceCallBackBlock)callback
{
    PBUser *pbUser = [[UserManager sharedInstance]pbUser];
    if (pbUser == nil) {
        return;
    }
    PBUserBuilder *pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setWeixinId:value];
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}

- (void)updateUserEmail:(NSString*)value callback:(UserServiceCallBackBlock)callback
{
    PBUser *pbUser = [[UserManager sharedInstance]pbUser];
    if (pbUser == nil) {
        return;
    }
    PBUserBuilder *pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setEmail:value];
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}

- (void)updateUserMobile:(NSString*)value callback:(UserServiceCallBackBlock)callback
{
    PBUser *pbUser = [[UserManager sharedInstance]pbUser];
    if (pbUser == nil) {
        return;
    }
    PBUserBuilder *pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setMobile:value];
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}

- (void)updateUserPwd:(NSString*)value callback:(UserServiceCallBackBlock)callback
{
    PBUser *pbUser = [[UserManager sharedInstance]pbUser];
    if (pbUser == nil) {
        return;
    }
    PBUserBuilder *pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setPassword:value];
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}

- (void)updateUserLocation:(NSString*)value callback:(UserServiceCallBackBlock)callback
{
    PBUser *pbUser = [[UserManager sharedInstance]pbUser];
    if (pbUser == nil) {
        return;
    }
    PBUserBuilder *pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setLocation:value];
    
    [self updateUser:[pbUserBuilder build] callback:callback];
}

#pragma makr - Upload User Avatar and Background

- (id<CreateImageInfoProtocol>)getImageInfo
{
    return [[CreateJpegImageInfo alloc] init];
}

#define UPLOAD_IMAGE_QUALITY        1.0f

- (void)uploadUserAvatar:(UIImage*)image callback:(UserServiceCallBackBlock)callback
{
   
    [self uploadImage:image prefix:[[CdnManager sharedInstance] getUserAvatarDataPrefix] callback:^(NSString *imageURL, NSError *error) {
        if (error == nil) {
            [self updateUserAvatar:imageURL callback:callback];
        }
        
        EXECUTE_BLOCK(callback, nil, error);
    }];

}

- (void)uploadUserBackground:(UIImage*)image callback:(UserServiceCallBackBlock)callback
{
    [self uploadImage:image prefix:[[CdnManager sharedInstance] getUserBackgroundDataPrefix] callback:^(NSString *imageURL, NSError *error) {
        if (error == nil) {
            [self updateUserBackground:imageURL callback:callback];
        }
        
        EXECUTE_BLOCK(callback, nil, error);
    }];
}


#pragma mark - Invite Codes

- (void)verifyInviteCode:(NSString*)inviteCode
                callback:(VerifyInviteCodeCallbackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBVerifyInviteCodeRequestBuilder* reqBuilder = [PBVerifyInviteCodeRequest builder];
    [reqBuilder setInviteCode:inviteCode];
    
    // set request
    PBVerifyInviteCodeRequest* req = [reqBuilder build];
    [builder setVerifyInviteCodeRequest:req];
    
    [self sendRequest:PBMessageTypeMessageVerifyInviteCode
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 EXECUTE_BLOCK(callback, inviteCode, error);
                 
             } isPostError:YES];

}

/*
- (void)getNewInviteCode:(int)count
                callback:(InviteCodeListCallBackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBGetNewInviteCodeRequestBuilder* reqBuilder = [PBGetNewInviteCodeRequest builder];
    [reqBuilder setCount:count];
    
    // set request
    PBGetNewInviteCodeRequest* req = [reqBuilder build];
    [builder setGetNewInviteCodeRequest:req];
    
    [self sendRequest:PBMessageTypeMessageGetNewInviteCode
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 NSArray* codes = response.getNewInviteCodeResponse.inviteCodes;
                 [[InviteCodeManager sharedInstance] storeCodes:codes];
                 NSArray* newCodes = [[InviteCodeManager sharedInstance] getCodes];
                 EXECUTE_BLOCK(callback, newCodes, error);
                 
             } isPostError:YES];
}

- (void)getAvailableInviteCode:(InviteCodeListCallBackBlock)callback
{
    NSArray* currentCodes = [[InviteCodeManager sharedInstance] getCodes];
    if ([currentCodes count] >= MAX_LOCAL_INVITE_CODE){
        // enough codes
        EXECUTE_BLOCK(callback, currentCodes, nil);
        return;
    }
    
    // TODO check whether user can request more code today
    
    int requestCount = MAX_LOCAL_INVITE_CODE - [currentCodes count];
    [self getNewInviteCode:requestCount
                  callback:callback];
}
*/

- (void)getUserInviteCodeList:(UserInviteCodeListCallbackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBGetUserInviteCodeListRequestBuilder* reqBuilder = [PBGetUserInviteCodeListRequest builder];
    
    // set request
    PBGetUserInviteCodeListRequest* req = [reqBuilder build];
    [builder setGetUserInviteCodeListRequest:req];
    
    [self sendRequest:PBMessageTypeMessageGetUserInviteCodeList
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBUserInviteCodeList* codes = response.getUserInviteCodeListResponse.codeList;
                 if (error == nil && codes != nil){
                     [[InviteCodeManager sharedInstance] storeUserInviteCodeList:codes];
                     codes = [[InviteCodeManager sharedInstance] getUserInviteCodeList];
                 }

                 EXECUTE_BLOCK(callback, codes, error);
                 
             } isPostError:YES];

}

- (void)applyInviteCode:(int)count callback:(UserInviteCodeListCallbackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    
    PBApplyInviteCodeRequestBuilder* reqBuilder = [PBApplyInviteCodeRequest builder];
    [reqBuilder setCount:count];
    
    // set request
    PBApplyInviteCodeRequest* req = [reqBuilder build];
    [builder setApplyInviteCodeRequest:req];
    
    [self sendRequest:PBMessageTypeMessageApplyInviteCode
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBUserInviteCodeList* codes = response.applyInviteCodeResponse.codeList;
                 if (error == nil && codes != nil){
                     [[InviteCodeManager sharedInstance] storeUserInviteCodeList:codes];
                     codes = [[InviteCodeManager sharedInstance] getUserInviteCodeList];
                 }
                 
                 EXECUTE_BLOCK(callback, codes, error);
                 
             } isPostError:YES];
}

- (void)distributeInviteCode:(PBInviteCode*)origCode sendTo:(NSString*)sendTo callback:(UserInviteCodeListCallbackBlock)callback
{
    PBInviteCodeBuilder* inviteCodeBuilder = [PBInviteCode builderWithPrototype:origCode];
    [inviteCodeBuilder setSendTo:sendTo];
    [inviteCodeBuilder setStatus:PBInviteCodeStatusCodeStatusSent];
    
    PBInviteCode* inviteCode = [inviteCodeBuilder build];
    
    PBUserInviteCodeListBuilder* codeListBuilder = [PBUserInviteCodeList builder];
    PBUserInviteCodeList* currentCodes = [[InviteCodeManager sharedInstance] getUserInviteCodeList];
    if (currentCodes){
        codeListBuilder = [PBUserInviteCodeList builderWithPrototype:currentCodes];
    }
    
    // set user ID
    [codeListBuilder setUserId:[[UserManager sharedInstance] userId]];
    
    // remove code from code list and add to send list
    PBInviteCode* removedCode = nil;
    for (PBInviteCode* code in codeListBuilder.availableCodes){
        if ([code.code isEqualToString:inviteCode.code]){
            removedCode = code;
        }
    }
    if (removedCode){
        [codeListBuilder.availableCodes removeObject:removedCode];
    }
    
    // add into sent code list
    PBInviteCode* sentCode = nil;
    int index = 0;
    for (PBInviteCode* code in codeListBuilder.availableCodes){
        if ([code.code isEqualToString:inviteCode.code]){
            sentCode = code;
            break;
        }
        
        index ++;
    }
    if (sentCode){
        // update current
        [codeListBuilder.sentCodes replaceObjectAtIndex:index withObject:inviteCode];
    }
    else{
        // add new
        [codeListBuilder addSentCodes:inviteCode];
    }
    
    // set code list in request
    PBUpdateInviteCodeRequestBuilder* reqBuilder = [PBUpdateInviteCodeRequest builder];
    [reqBuilder setCodeList:[codeListBuilder build]];
    
    // set request
    PBUpdateInviteCodeRequest* req = [reqBuilder build];

    PBDataRequestBuilder* builder = [PBDataRequest builder];
    [builder setUpdateInviteCodeRequest:req];
    
    [self sendRequest:PBMessageTypeMessageUpdateInviteCode
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 PBUserInviteCodeList* codes = response.updateInviteCodeResponse.codeList;
                 if (error == nil && codes != nil){
                     [[InviteCodeManager sharedInstance] storeUserInviteCodeList:codes];
                     codes = [[InviteCodeManager sharedInstance] getUserInviteCodeList];
                 }
                 
                 EXECUTE_BLOCK(callback, codes, error);
                 
             } isPostError:YES];
}


#pragma mark - Share SDK Methods

- (void)prepareShareSDK
{
    [ShareSDK registerApp:@"52a5ee738c3b"];
    
    [ShareSDK connectWeChatWithAppId:@"wx5882a63f730ded3f"                  //微信APPID，待申请
                           appSecret:@"9998984cc6807c520f4e1ebc44a234d3"    //微信APPSecret
                           wechatCls:[WXApi class]];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:@"2457135690"
//                               appSecret:@"9886c6c3a5683950bad471b44f47a312"
//                             redirectUri:@"http://www.sharesdk.cn"];
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"2527712829"
                                appSecret:@"4ae0e35135338f759838e6d8658445d7"
                              redirectUri:@"http://www.bibiji.me/sina/oauth"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104294794"
                           appSecret:@"DmTefnT5FJTuC3xc"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
//    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"1104294794"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
//    [ShareSDK connectWeChatWithAppId:@"wx5882a63f730ded3f"              // TODO 需要修改
//                           wechatCls:[WXApi class]];
    
    [ShareSDK connectSMS];
    
    //连接邮件
    [ShareSDK connectMail];
    
    //TODO 支持B站登录
}

- (void)prepareSmsSDK
{
    NSString* appKey = @"628d94e0be02";
    NSString* appSecret = @"a2b382deb93d4d6122abeaa976a758ac";
    
    [SMS_SDK registerApp:appKey withSecret:appSecret];
}

#pragma makr - Search User

- (void)searchUser:(NSString*)keyword
            offset:(int)offset
             limit:(int)limit
          callback:(SearchUserCallbackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];

    PBSearchUserRequestBuilder* reqBuilder = [PBSearchUserRequest builder];
    [reqBuilder setKeyword:keyword];
    [reqBuilder setOffset:offset];
    [reqBuilder setLimit:limit];
    
    // set request
    PBSearchUserRequest* req = [reqBuilder build];
    [builder setSearchUserRequest:req];
    
    [self sendRequest:PBMessageTypeMessageSearchUser
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 NSArray* pbUserList = response.searchUserResponse.users;
                 EXECUTE_BLOCK(callback, pbUserList, error);
                 
             } isPostError:YES];
    
}

#pragma mark - User FeedBack
-(void) sendUserFeedBack:(NSString*)message contactInfo:(NSString*)contactInfo
            callback:(GetUserFeedBackCallbackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    PBSendUserFeedbackRequestBuilder *reqBuilder  = [PBSendUserFeedbackRequest builder];
    [reqBuilder setMessage:message];
    [reqBuilder setContactInfo:contactInfo];
    [reqBuilder setUser:[[UserManager sharedInstance]pbUser]];
    [reqBuilder setDevice:[[UserManager sharedInstance]getCurrentDevice]];
    
    PBSendUserFeedbackRequest *req = [reqBuilder build];
    [builder setSendUserFeedbackRequest:req];
    [self sendRequest:PBMessageTypeMessageSendUserFeedback
       requestBuilder:builder
             callback:^(PBDataResponse *response, NSError *error) {
                 
                 
                 EXECUTE_BLOCK(callback, error);
                 
             } isPostError:YES];
}

#pragma mark - User Setting
-(void) veriftyUserEmail:(NSString*)destEmail
                    code:(NSString*)code
                callback:(VeriftyUserEmailCallbackBlock)callback
{
    PBDataRequestBuilder* builder = [PBDataRequest builder];
    PBVerifyUserEmailRequestBuilder *reqBuilder = [PBVerifyUserEmailRequest builder];
    [reqBuilder setDestEmail:destEmail];
    [reqBuilder setVerifyCode:code];
    
    PBVerifyUserEmailRequest *req = [reqBuilder build];
    [builder setVerifyUserEmailRequest:req];
    [self sendRequest:PBMessageTypeMessageVerifyUserEmail requestBuilder:builder callback:^(PBDataResponse *response, NSError *error) {
        if (error == nil) {
            PPDebug(@"VeriftyUserEmail success!");
        }
        else
        {
            PPDebug(@"VeriftyUserEmail fail!");
        }
        EXECUTE_BLOCK(callback, error);
    } isPostError:YES];
}

- (void)updateUserDeviceToken:(NSData*)deviceToken
{
    [[UserManager sharedInstance] saveDeviceToken:deviceToken];
    NSString* deviceTokenString = [[UserManager sharedInstance] getDeviceToken];
    
    PBUser* user = [[UserManager sharedInstance] pbUser];
    if ([user.currentDevice.deviceToken isEqualToString:deviceTokenString]){
        // the same, no need to do anything
        return;
    }
    
    PBUser* pbUser = [[UserManager sharedInstance] pbUser];
    PBDevice* pbDevice = [[UserManager sharedInstance] getCurrentDevice];
    if (pbUser == nil || pbDevice == nil){
        return;
    }
    
    // build nick here
    PBUserBuilder* pbUserBuilder = [PBUser builder];
    [pbUserBuilder setUserId:pbUser.userId];
    [pbUserBuilder setCurrentDevice:pbDevice];
    
    [self updateUser:[pbUserBuilder build] callback:nil];
}


@end
