//
//  UserService.h
//  BarrageClient
//
//  Created by pipi on 14/12/5.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import <ShareSDK/ShareSDK.h>

typedef void (^UserServiceCallBackBlock) (PBUser* pbUser, NSError* error);
typedef void (^InviteCodeListCallBackBlock) (NSArray* codeList, NSError* error);
typedef void (^UserInviteCodeListCallbackBlock) (PBUserInviteCodeList* userInviteCodeList, NSError* error);
typedef void (^VerifyInviteCodeCallbackBlock) (NSString* code, NSError* error);
typedef void (^SearchUserCallbackBlock) (NSArray* pbUserList, NSError* error);
typedef void (^GetUserFeedBackCallbackBlock) (NSError* error);
typedef void (^VeriftyUserEmailCallbackBlock)(NSError* error);

@interface UserService : CommonService

DEF_SINGLETON_FOR_CLASS(UserService);

#pragma mark - Registration

- (void)regiseterUserByEmail:(NSString*)email
                    password:(NSString*)password
                  inviteCode:(NSString*)inviteCode
                    callback:(UserServiceCallBackBlock)callback;

- (void)regiseterUserByMobile:(NSString*)mobile
                     password:(NSString*)password
                   inviteCode:(NSString*)inviteCode
                     callback:(UserServiceCallBackBlock)callback;

- (void)registerBySns:(ShareType)shareType
           inviteCode:(NSString*)inviteCode
             callback:(UserServiceCallBackBlock)callback;

#pragma mark - Login User

- (void)loginUserByEmail:(NSString*)email
                password:(NSString*)password
                callback:(UserServiceCallBackBlock)callback;

- (void)loginUserByMobile:(NSString*)mobile
                password:(NSString*)password
                callback:(UserServiceCallBackBlock)callback;

- (void)loginUserBySns:(ShareType)shareType
              callback:(UserServiceCallBackBlock)callback;

- (PBSNSUser*)createSNSUser:(id<ISSPlatformUser>)snsUser
                 credential:(id<ISSPlatformCredential>)credential
                  shareType:(ShareType)shareType;


#pragma mark - Update User
- (void)updateUser:(PBUser*)pbUser callback:(UserServiceCallBackBlock)callback;
- (void)updateUserNick:(NSString*)nickName callback:(UserServiceCallBackBlock)callback;
- (void)updateUserSignature:(NSString*)value callback:(UserServiceCallBackBlock)callback;
- (void)updateUserGender:(BOOL)value callback:(UserServiceCallBackBlock)callback;
- (void)updateUserBarrageStyle:(PBBarrageStyle)value callback:(UserServiceCallBackBlock)callback;
- (void)updateUserBarrageSpeed:(PBBarrageSpeed)value callback:(UserServiceCallBackBlock)callback;
- (void)updateUserQQopenId:(NSString*)value callback:(UserServiceCallBackBlock)callback;
- (void)updateUserSinaId:(NSString*)value callback:(UserServiceCallBackBlock)callback;
- (void)updateUserWeixinId:(NSString*)value callback:(UserServiceCallBackBlock)callback;
- (void)updateUserEmail:(NSString*)value callback:(UserServiceCallBackBlock)callback;
- (void)updateUserMobile:(NSString*)value callback:(UserServiceCallBackBlock)callback;
- (void)updateUserPwd:(NSString*)value callback:(UserServiceCallBackBlock)callback;
- (void)updateUserLocation:(NSString*)value callback:(UserServiceCallBackBlock)callback;

#pragma makr - Upload User Avatar and Background

- (void)uploadUserAvatar:(UIImage*)image callback:(UserServiceCallBackBlock)callback;
- (void)uploadUserBackground:(UIImage*)image callback:(UserServiceCallBackBlock)callback;

#pragma mark - ShareSDK & SMS SDK
- (void)prepareShareSDK;
- (void)prepareSmsSDK;


#pragma mark - Invite Codes
- (void)verifyInviteCode:(NSString*)inviteCode
                callback:(VerifyInviteCodeCallbackBlock)callback;

//- (void)getAvailableInviteCode:(InviteCodeListCallBackBlock)callback;
- (void)getUserInviteCodeList:(UserInviteCodeListCallbackBlock)callback;
- (void)applyInviteCode:(int)count callback:(UserInviteCodeListCallbackBlock)callback;
- (void)distributeInviteCode:(PBInviteCode*)origCode sendTo:(NSString*)sendTo callback:(UserInviteCodeListCallbackBlock)callback;


#pragma mark - Search User
- (void)searchUser:(NSString*)keyword
            offset:(int)offset
             limit:(int)limit
          callback:(SearchUserCallbackBlock)callback;


#pragma mark - User FeedBack
-(void) sendUserFeedBack:(NSString*)message contactInfo:(NSString*)contactInfo
            callback:(GetUserFeedBackCallbackBlock)callback;

#pragma mark - User Setting

-(void) veriftyUserEmail:(NSString*)destEmail
                    code:(NSString*)code
                callback:(VeriftyUserEmailCallbackBlock)callback;
@end
