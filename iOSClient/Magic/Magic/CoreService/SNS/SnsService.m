//
//  SnsService.m
//  BarrageClient
//
//  Created by pipi on 15/1/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "SnsService.h"
#import "PPDebug.h"
#import "UIViewUtils.h"
#import "LocaleUtils.h"
#import "GTMBase64.h"
#import "UIUtils.h"
#import "BarrageConfigManager.h"
#import "Error.pb.h"
#import "UserService.h"
#import "UserManager.h"

@implementation SnsService

IMPL_SINGLETON_FOR_CLASS(SnsService)

- (BOOL)isAuthenticated:(ShareType)shareType
{
    if (shareType == ShareTypeAny){
        return NO;
    }
    
    return [ShareSDK hasAuthorizedWithType:shareType];
}

- (BOOL)isExpired:(ShareType)shareType
{
    if (shareType == ShareTypeAny){
        return NO;
    }
    
    if ([self isAuthenticated:shareType] == NO){
        return YES;
    }
    
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:shareType];      //传入获取授权信息的类型
    id<ISSPlatformCredential> cred = (id<ISSPlatformCredential>)credential;                 //转换为OAuth2授权凭证
    PPDebug(@"<isExpired> shareType=%d, accessToken = %@, expiresIn = %@, available=%d", shareType, [cred token], [cred expired], [cred available]);
    
    return [cred available] == NO;
}

- (void)autheticate:(ShareType)shareType
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
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:[SnsService snsOfficialNick:shareType]],
                                    SHARE_TYPE_NUMBER(shareType),
                                    nil]];
    
    [ShareSDK authWithType:shareType                                            //需要授权的平台类型
                   options:authOptions                                          //授权选项，包括视图定制，自动授权
                    result:^(SSAuthState state, id<ICMErrorInfo> error) {       //授权返回后的回调方法
                        if (state == SSAuthStateSuccess)
                        {
                            // TODO save user weibo bind info, get user infomation here and upload user information to server
                            [self readUserInfoAndUpdateToServer:shareType];

                            // TODO
                            POST_SUCCESS_MSG(@"授权完成");
                            PPDebug(@"autheticate shareType(%d) success", shareType);
                            
                        }
                        else if (state == SSAuthStateFail)
                        {
                            POST_ERROR(@"授权失败");
                            PPDebug(@"autheticate shareType(%d) failure, error=%@", shareType, [error errorDescription]);
                        }
                        else if (state == SSAuthStateBegan){
                            POSTMSG(@"授权请求中...");
                            PPDebug(@"autheticate shareType(%d) began", shareType);
                        }
                        else if (state == SSAuthStateCancel){
                            POSTMSG(@"授权已取消");
                            PPDebug(@"autheticate shareType(%d) cancel", shareType);
                        }
                        else{
                            PPDebug(@"autheticate shareType(%d) unknown state(%d), error=%@", shareType, state, [error errorDescription]);
                        }
                    }];
}

- (void)cancelAuthentication:(ShareType)shareType
{
    if (shareType == ShareTypeAny){
        return;
    }
    
    [ShareSDK cancelAuthWithType:shareType];
}

- (void)followUser:(ShareType)shareType weiboId:(NSString*)weiboId weiboName:(NSString*)weiboName
{
    if (shareType == ShareTypeAny){
        return;
    }
    
    SSUserFieldType fieldType = SSUserFieldTypeUid;
    NSString* field = weiboId;
    if ([weiboId length] == 0 && [weiboName length] > 0){
        fieldType = SSUserFieldTypeName;
        field = weiboName;
    }
    
    if ([field length] == 0){
        PPDebug(@"<followUser> but field(%@) is nil", field);
        return;
    }
    
    PPDebug(@"<followUser> field(%@) type(%d) shareType(%d) weiboId(%@) weiboNick(%@)", field, fieldType, shareType, weiboId, weiboName);
    
    BOOL needUpdateUserInfo = [self isExpired:shareType];
    
    //关注用户
    [ShareSDK followUserWithType:shareType              //平台类型
                           field:field                  //关注用户的名称或ID
                       fieldType:fieldType              //字段类型，用于指定第二个参数是名称还是ID
                     authOptions:nil                    //授权选项
                    viewDelegate:nil                    //授权视图委托
                          result:^(SSResponseState state, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {               //返回回调
                              if (state == SSResponseStateSuccess)
                              {
                                  // TODO save user weibo bind info, get user infomation here and upload user information to server
                                  if (needUpdateUserInfo){
                                      [self readUserInfoAndUpdateToServer:shareType];
                                  }
                                  
                                  POSTMSG(NSLS(@"关注完成"));
                              }
                              else if (state == SSResponseStateFail)
                              {
                                  POSTMSG(NSLS(@"关注失败"));
                                  PPDebug(@"follow user failure, code=%d, error=%@", [error errorCode], error.errorDescription);
                                  
                              }
                          }];
}

//- (void)postWeiboSuccessMessage:(NSString*)successMessage awardCoins:(int)awardCoins
//{
//    NSString* msg = nil;
//    if ([successMessage length] > 0){
//        
//        if (awardCoins > 0){
//            NSString* awardMsg = [NSString stringWithFormat:NSLS(@"kPublishWeiboAwardInfo"), awardCoins];
//            msg = [NSString stringWithFormat:@"%@, %@", successMessage, awardMsg];
//        }
//        else{
//            msg = successMessage;
//        }
//        
//        POSTMSG2(msg, 2.5);
//    }
//}

- (void)handlePublishWeiboSuccess:(ShareType)shareType
                            state:(SSResponseState)state
                            error:(id<ICMErrorInfo>)error
               needUpdateUserInfo:(BOOL)needUpdateUserInfo
                       awardCoins:(int)awardCoins
                   successMessage:(NSString*)successMessage
                   failureMessage:(NSString*)failureMessage
{
    if (state == SSPublishContentStateSuccess)
    {
        PPDebug(@"publish weibo success");
        
        // TODO save user weibo bind info, get user infomation here and upload user information to server
        if (needUpdateUserInfo){
            [self readUserInfoAndUpdateToServer:shareType];
        }
        
//        [[AccountService defaultService] chargeCoin:awardCoins source:ShareWeiboReward];
//
        if ([successMessage length] > 0){
            POSTMSG2(successMessage, 2.5);
        }
    }
    else if (state == SSPublishContentStateFail)
    {
        //        NSString* msg = failureMessage;
        //        if ([error.errorDescription length] > 0){
        //            msg = [NSString stringWithFormat:@"%@, %@", failureMessage, error.errorDescription];
        //        }
        POSTMSG2(failureMessage, 2.5);
        PPDebug(@"publish weibo failure, code=%d, error=%@", [error errorCode], error.errorDescription);
    }
}

- (void)publishWeibo:(ShareType)shareType
                text:(NSString*)text
       imageFilePath:(NSString*)imagePath
              inView:(UIView*)view
          awardCoins:(int)awardCoins
      successMessage:(NSString*)successMessage
      failureMessage:(NSString*)failureMessage
{
    [self publishWeibo:shareType
                  text:text
         imageFilePath:imagePath
                inView:view
            awardCoins:awardCoins
        successMessage:successMessage
        failureMessage:failureMessage
                taskId:0];
}

- (void)publishWeibo:(ShareType)shareType
                text:(NSString*)text
       imageFilePath:(NSString*)imagePath
              inView:(UIView*)view
          awardCoins:(int)awardCoins
      successMessage:(NSString*)successMessage
      failureMessage:(NSString*)failureMessage
              taskId:(int)taskId
{
    [self publishWeibo:shareType
                  text:text
         imageFilePath:imagePath
              audioURL:nil
                 title:@""
                inView:view
            awardCoins:awardCoins
        successMessage:successMessage
        failureMessage:failureMessage
                taskId:taskId];
}

- (void)publishWeibo:(ShareType)shareType
                text:(NSString*)text
       imageFilePath:(NSString*)imagePath
            audioURL:(NSString*)audioURL
               title:(NSString*)title
              inView:(UIView*)view
          awardCoins:(int)awardCoins
      successMessage:(NSString*)successMessage
      failureMessage:(NSString*)failureMessage
{
    [self publishWeibo:shareType
                  text:text
         imageFilePath:imagePath
              audioURL:audioURL
                 title:title
                inView:view
            awardCoins:awardCoins
        successMessage:successMessage
        failureMessage:failureMessage
                taskId:0];
    
}

- (void)publishWeibo:(ShareType)shareType
                text:(NSString*)text
       imageFilePath:(NSString*)imagePath
            audioURL:(NSString*)audioURL
               title:(NSString*)title
              inView:(UIView*)view
          awardCoins:(int)awardCoins
      successMessage:(NSString*)successMessage
      failureMessage:(NSString*)failureMessage
              taskId:(int)taskId

{
    if (shareType == ShareTypeAny){
        return;
    }
    
    PPDebug(@"<publishWeibo> sns(%d) text(%@) image(%@) audio(%@)", shareType, text, imagePath, audioURL);
    
    SSPublishContentMediaType mediaType = SSPublishContentMediaTypeText;
    if ([audioURL length] > 0){
        mediaType = SSPublishContentMediaTypeMusic;
        if ([title length] == 0){
            title = text;
        }
    }
    else{
        if ([[imagePath pathExtension] isEqualToString:@"gif"] ||
            [[imagePath pathExtension] isEqualToString:@"GIF"]){
            mediaType = SSPublishContentMediaTypeGif;
        }
        else{
            mediaType = ([imagePath length] > 0) ? SSPublishContentMediaTypeImage : SSPublishContentMediaTypeText;
        }
    }
    
    //创建分享内容
    id<ISSCAttachment> image = nil;
    if (mediaType == SSPublishContentMediaTypeGif &&
        (shareType == ShareTypeWeixiSession || shareType == ShareTypeWeixiTimeline)){
        
        mediaType = SSPublishContentMediaTypeImage;
        image = [ShareSDK imageWithPath:imagePath];
        
        text = nil;
        title = nil;
        audioURL = nil;
    }
    else{
        image = [ShareSDK imageWithPath:imagePath];
    }
    
    if (shareType == ShareTypeQQSpace && mediaType == SSPublishContentMediaTypeImage){
        audioURL = DEFAULT_SHARE_URL;
    }
    
    PPDebug(@"<publishWeibo> image size is %d", [image.data length]);
    
    id<ISSContent> publishContent = [ShareSDK content:text
                                       defaultContent:@""
                                                image:image
                                                title:title
                                                  url:audioURL
                                          description:nil
                                            mediaType:mediaType];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:view arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];  // _appDelegate.viewDelegate]; TODO check
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:[SnsService snsOfficialNick:shareType]],
                                    SHARE_TYPE_NUMBER(shareType),
                                    nil]];
    
    NSArray *oneKeyShareList = [ShareSDK getShareListWithType:shareType, nil];
    
    BOOL needUpdateUserInfo = [self isExpired:shareType];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:shareType
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:oneKeyShareList //[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:YES
                                                     wxSessionButtonHidden:YES
                                                    wxTimelineButtonHidden:YES
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil //_appDelegate.viewDelegate TODO check
                                                       friendsViewDelegate:nil //_appDelegate.viewDelegate TODO check
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 
                                 [self handlePublishWeiboSuccess:shareType
                                                           state:state
                                                           error:error
                                              needUpdateUserInfo:needUpdateUserInfo
                                                      awardCoins:awardCoins
                                                  successMessage:successMessage
                                                  failureMessage:failureMessage];
                                 
                                 if (state == SSPublishContentStateSuccess){
                                 }
                             }];
    
}

- (void)publishWeiboAtBackground:(ShareType)shareType
                            text:(NSString*)text
                   imageFilePath:(NSString*)imagePath
                      awardCoins:(int)awardCoins
                  successMessage:(NSString*)successMessage
                  failureMessage:(NSString*)failureMessage

{
    if (shareType == ShareTypeAny){
        return;
    }
    
    PPDebug(@"<publishWeiboAtBackground> sns(%d) text(%@) image(%@)", shareType, text, imagePath);
    SSPublishContentMediaType mediaType = ([imagePath length] > 0) ? SSPublishContentMediaTypeImage : SSPublishContentMediaTypeText;
    
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:text
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:mediaType];
    
    BOOL needUpdateUserInfo = [self isExpired:shareType];
    
    //显示分享菜单
    [ShareSDK shareContent:publishContent
                      type:shareType
               authOptions:nil
              shareOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        [self handlePublishWeiboSuccess:shareType
                                                  state:state
                                                  error:error
                                     needUpdateUserInfo:needUpdateUserInfo
                                             awardCoins:awardCoins
                                         successMessage:successMessage
                                         failureMessage:failureMessage];
                        
                    }];
}

- (void)publishWeibo:(ShareType)shareType
                text:(NSString*)text
              inView:(UIView*)view
          awardCoins:(int)awardCoins
      successMessage:(NSString*)successMessage
      failureMessage:(NSString*)failureMessage


{
    [self publishWeibo:shareType
                  text:text
         imageFilePath:nil
                inView:view
            awardCoins:awardCoins
        successMessage:successMessage
        failureMessage:failureMessage];
}

- (void)publishWeiboToAll:(NSString*)text
{
    
}

- (void)setAccessTokenClickHandler:(UIButton *)sender
{
    
}

- (void)saveSNSInfoIntoShareSDK:(ShareType)shareType credentialString:(NSString*)credentialString
{
    PPDebug(@"<saveSNSInfoIntoShareSDK> type(%d) credential(%@)", shareType, credentialString);
    if (shareType == ShareTypeAny){
        return;
    }
    
    if ([credentialString length] == 0){
        return;
    }
    
    NSData* credentialData = [GTMBase64 decodeString:credentialString];
    if (credentialData == nil){
        return;
    }
    
    //将授权数据转换为新的授权凭证
    id<ISSPlatformCredential> newCredential = [ShareSDK credentialWithData:credentialData type:shareType];
    
    //设置使用新的授权凭证
    [ShareSDK setCredential:newCredential type:shareType];
}

- (void)saveSNSInfoIntoShareSDK:(NSArray*)snsUserList
{
    for (PBSNSUser* snsUser in snsUserList){
        [self saveSNSInfoIntoShareSDK:snsUser.type credentialString:snsUser.credential];
    }
}

+ (NSString*)snsOfficialNick:(ShareType)type
{
    NSString* weiboNick = [BarrageConfigManager snsOfficialId:type];
    if ([weiboNick length] > 0){
        return [NSString stringWithFormat:@"@%@", weiboNick];
    }
    else{
        return [UIUtils getAppName];
    }
    
}

- (void)cleanAllSNSInfo
{
    NSArray* shareTypes = @[ @(ShareTypeSinaWeibo), @(ShareTypeTencentWeibo),
                             @(ShareTypeFacebook), @(ShareTypeQQSpace), @(ShareTypeTwitter),
                             @(ShareTypeQQ)];
    
    for (NSNumber* shareType in shareTypes){
        [ShareSDK setCredential:nil type:[shareType intValue]];
    }
}

- (void)cleanSNSInfo:(ShareType)shareType
{
    [ShareSDK setCredential:nil type:shareType];
}

- (void)cleanSNSInfoIfExpired:(ShareType)shareType
{
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:shareType];      //传入获取授权信息的类型
    if (credential == nil){
        return;
    }
    
    if ([credential available] == NO || [ShareSDK hasAuthorizedWithType:shareType] == NO){
        PPDebug(@"<cleanSNSInfoIfExpired> shareType=%d", shareType);
        [ShareSDK setCredential:nil type:shareType];
    }
}

// TODO save data to ShareSDK while login and get user info back

//- (void)saveSNSInfo:(NSArray*)snsCredentials
//{
//    if ([snsCredentials count] == 0){
//        return;
//    }
//    
//    for (PBSNSUserCredential* credential in snsCredentials){
//        
//        PPDebug(@"<saveSNSInfo> restore SNS credential, type(%d), credential(%@)", credential.type, credential.credential);
//        
//        if ([credential.credential length] == 0){
//            continue;
//        }
//        
//        // store into local PB user
//        [[UserManager defaultManager] saveSNSCredential:credential.type credential:credential.credential];
//        
//        // set in Share SDK
//        [self saveSNSInfoIntoShareSDK:credential.type credentialString:credential.credential];
//    }
//}

- (PBUser*)createUpdateSNSInfo:(id<ISSPlatformUser>)snsUser
                    credential:(id<ISSPlatformCredential>)credential
                     shareType:(ShareType)shareType
{
    PBUser* currentUser = [[UserManager sharedInstance] pbUser];
    
    PBUserBuilder* builder = [PBUser builder];
    
    if ([currentUser.nick length] == 0){
        [builder setNick:snsUser.nickname];
    }
    
    if ([currentUser hasGender] == NO){
        [builder setGender:(snsUser.gender == 0) ? true : false];
    }
    
    if ([currentUser.location length] == 0){
        [builder setLocation:[snsUser.sourceData objectForKey:@"location"]];
    }
    
    if ([currentUser.avatar length] == 0){
        [builder setAvatar:snsUser.profileImage];
    }
    
    // add SNS
    PBSNSUser* pbSnsUser = [[UserService sharedInstance] createSNSUser:snsUser
                                                            credential:credential
                                                             shareType:shareType];
    
    if (pbSnsUser){
        // add current
        [builder addSnsUsers:pbSnsUser];
    }
    
    if (currentUser.snsUsers){
        for (PBSNSUser* user in currentUser.snsUsers){
            if (user.type != pbSnsUser.type){
                // add other SNS info
                [builder addSnsUsers:user];
            }
        }
    }
    
    // set dummy user ID
    [builder setUserId:currentUser.userId];
    
    return [builder build];
}

- (void)readUserInfoAndUpdateToServer:(ShareType)shareType
{
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:shareType];      //传入获取授权信息的类型
    if (credential == nil){
        return;
    }
    
    id<ISSPlatformCredential> cred = (id<ISSPlatformCredential>)credential;             //转换为OAuth2授权凭证
    
    PPDebug(@"<readUserInfoAndUpdateToServer> user access token(%@), expire(%@)", [cred token], [cred expired]);
    PPDebug(@"<readUserInfoAndUpdateToServer> credential(%@), oauth2(%@)", [credential description], [cred description]);
    
    // read user information and upload to server
    [ShareSDK getUserInfoWithType:shareType                                     //平台类型
                      authOptions:nil                                           //授权选项
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {             //返回回调
                               if (result){
                                   PPDebug(@"<getUserInfo> success, userInfo(%@)", [userInfo.sourceData description]);
                                   
                                   PBUser* userToUpdate = [self createUpdateSNSInfo:userInfo
                                                                         credential:cred
                                                                          shareType:shareType];
                                   
                                   [[UserService sharedInstance] updateUser:userToUpdate
                                                                   callback:^(PBUser *pbUser, NSError *error) {
                                                                       PPDebug(@"<readUserInfoAndUpdateToServer> result(%@)", error);
                                                                   }];
                                   
                               }
                               else{
                                   PPDebug(@"<getUserInfo> error(%d) desc(%@)", error.errorCode, error.errorDescription);
                               }
                           }];
    
    
}

#pragma mark - Handle Open URL

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

@end
