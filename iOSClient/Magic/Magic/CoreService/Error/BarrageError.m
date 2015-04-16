//
//  BarrageError.m
//  BarrageClient
//
//  Created by pipi on 14/11/29.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "BarrageError.h"
#import "Error.pb.h"
#import "PPDebug.h"
#import "MessageCenter.h"

@implementation BarrageError

#define KEY(intX) @(intX)





+ (NSString *)errorMessageForCode:(NSInteger)code
{
    NSDictionary *errorMSGDict =
    @{
      
      KEY(PBErrorErrorReadPostData) : @"网络错误，请检查系统是否可以访问网络",
      
      // TODO add error codes here, refer to PBError
      
      KEY(PBErrorErrorParsePostData) : @"网络错误，请检查系统是否可以访问网络",   //  TODO
      KEY(PBErrorErrorNoServiceForType) : @"找不到服务器，请稍后重试",
      KEY(PBErrorErrorServiceCatchException) : @"网络异常，请稍后重试",
      KEY(PBErrorErrorUnknown) : @"未知错误，请稍候重试",
      KEY(PBErrorErrorDataResponseNull) : @"无应答，请稍候重试",
      KEY(PBErrorErrorJsonException) : @"网络错误，请检查系统是否可以访问网络",    //TODO
      
      KEY(PBErrorErrorIncorrectInputData) : @"输入有误，请重新输入",
      KEY(PBErrorErrorUserLoginUnknownType) : @"登录出现未知错误，请稍后重试",
      KEY(PBErrorErrorUserLoginInfoEmpty) : @"请输入登录信息",
      KEY(PBErrorErrorUserRegisterUnknownType) : @"注册出现未知错误，请稍后重试",
      KEY(PBErrorErrorUserRegisterInfoEmpty) : @"请输入注册信息",
      KEY(PBErrorErrorUserRegisterInvalidInviteCode) : @"注册所用的邀请码无效，请重新获取",
      KEY(PBErrorErrorUserNotFound) : @"该用户不存在，请确认输入是否有误",
      KEY(PBErrorErrorFriendNotFound) : @"该好友不存在，请确认输入是否有误",
      KEY(PBErrorErrorFriendNotAllowAddMe) : @"对方拒绝了你的好友请求",
      KEY(PBErrorErrorInviteCodeNotExist) : @"邀请码不存在，请确认邀请码是否正确",
      KEY(PBErrorErrorInviteCodeUsed) : @"邀请码已失效，请重新获取",
      KEY(PBErrorErrorEmailEmpty) : @"请输入邮箱",
      KEY(PBErrorErrorMobileEmpty) : @"请输入手机号码",
      KEY(PBErrorErrorSnsidEmpty) : @"请重新输入账号",
      KEY(PBErrorErrorEmailRegistered) : @"该邮箱已经被注册，请选择其他邮箱",
      KEY(PBErrorErrorPasswordInvalid) : @"密码无效，请重新输入",
      KEY(PBErrorErrorSnsAuthFail) : @"社交应用授权失败",
      KEY(PBErrorErrorSnsAuthCancel) : @"社交应用授权取消",
      KEY(PBErrorErrorSnsAuthErrorUnknown) : @"社交应用授权未知错误",
      KEY(PBErrorErrorSnsGetUserInfo) : @"社交应用获取信息出错",
      KEY(PBErrorErrorInviteCodeNull) : @"邀请码为空，请输入邀请码",
      KEY(PBErrorErrorNoInviteCodeAvailable) : @"没有可用的邀请码",
      KEY(PBErrorErrorUserTagListNull) : @"标签列表为空",
      KEY(PBErrorErrorUserTagNameDuplicate) : @"标签命名重复",
      KEY(PBErrorErrorSnsNoCredential) : @"社交应用无证书",
      KEY(PBErrorErrorMobileExist) : @"手机号码已被用来注册",
      KEY(PBErrorErrorFeedActionInvalid) : @"", //  TODO
      KEY(PBErrorErrorCreateImage) : @"创建图片出错",
      KEY(PBErrorErrorUploadImage) : @"上传图片出错",
      
      };
    NSString *errorMessage = errorMSGDict[KEY(code)];
    if (errorMessage == nil){
        errorMessage = @"系统错误，请稍后再试";
    }
    PPDebug(@"post error %@", errorMessage);
    return errorMessage;
//    return [errorMessage length] == 0 ? NSLS(@"kUnknowError") : errorMessage;
}

+ (NSError *)errorWithCode:(NSInteger) code
{
    if (code == 0) {
        return nil;
    }
    NSString *errorMessage = [self errorMessageForCode:code];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    return [NSError errorWithDomain:@"ServiceError" code:code userInfo:userInfo];
}

+ (void)postError:(NSError *)error
{
    POSTMSG([error localizedDescription]);
}

+ (void)postErrorWithCode:(NSInteger) code
{
    [self postError:[self errorWithCode:code]];
}

@end


