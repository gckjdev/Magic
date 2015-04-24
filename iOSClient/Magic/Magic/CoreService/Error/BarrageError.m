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
      
      KEY(PBErrorErrorReadPostData) : @"网络错误，请检查网络是否正常连接，或者稍后再试",
      
      // TODO add error codes here, refer to PBError
      
      KEY(PBErrorErrorParsePostData) : @"系统数据解析错误，请稍后重试",   //  TODO
      KEY(PBErrorErrorNoServiceForType) : @"系统服务请求异常，请稍后重试",
      KEY(PBErrorErrorServiceCatchException) : @"系统异常，请稍后重试",
      KEY(PBErrorErrorUnknown) : @"系统错误，请稍候重试",
      KEY(PBErrorErrorDataResponseNull) : @"系统异常，请稍候重试",
      KEY(PBErrorErrorJsonException) : @"系统异常，请稍候重试",    //TODO
      
      KEY(PBErrorErrorIncorrectInputData) : @"系统接口异常，请稍候重试",
      KEY(PBErrorErrorUserLoginUnknownType) : @"登录失败，请稍后重试",
      KEY(PBErrorErrorUserLoginInfoEmpty) : @"登录信息不齐备，请稍后重试",
      KEY(PBErrorErrorUserRegisterUnknownType) : @"注册失败，请稍后重试",
      KEY(PBErrorErrorUserRegisterInfoEmpty) : @"注册信息不齐全，请稍后再试",
      KEY(PBErrorErrorUserRegisterInvalidInviteCode) : @"邀请码无效，请检查邀请码",
      KEY(PBErrorErrorUserNotFound) : @"用户不存在，请检查",
      KEY(PBErrorErrorFriendNotFound) : @"用户不存在，请检查",
      KEY(PBErrorErrorFriendNotAllowAddMe) : @"对方拒绝了你的好友请求",
      KEY(PBErrorErrorInviteCodeNotExist) : @"邀请码不存在，请检查邀请码",
      KEY(PBErrorErrorInviteCodeUsed) : @"邀请码已失效",
      KEY(PBErrorErrorEmailEmpty) : @"邮箱不能为空",
      KEY(PBErrorErrorMobileEmpty) : @"手机号码不能为空",
      KEY(PBErrorErrorSnsidEmpty) : @"社交网络帐号信息不能为空",
      KEY(PBErrorErrorEmailRegistered) : @"该邮箱已经被注册，请检查",
      KEY(PBErrorErrorPasswordInvalid) : @"密码不正确",
      KEY(PBErrorErrorSnsAuthFail) : @"社交网络授权失败",
      KEY(PBErrorErrorSnsAuthCancel) : @"社交网络授权已取消",
      KEY(PBErrorErrorSnsAuthErrorUnknown) : @"社交网络授权失败，未知错误",
      KEY(PBErrorErrorSnsGetUserInfo) : @"获取社交信息失败",
      KEY(PBErrorErrorInviteCodeNull) : @"邀请码为空，请输入邀请码",
      KEY(PBErrorErrorNoInviteCodeAvailable) : @"没有可用的邀请码",
      KEY(PBErrorErrorUserTagListNull) : @"标签列表为空",
      KEY(PBErrorErrorUserTagNameDuplicate) : @"标签命名重复",
      KEY(PBErrorErrorSnsNoCredential) : @"社交网络未授权",
      KEY(PBErrorErrorMobileExist) : @"手机号码已注册",
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


