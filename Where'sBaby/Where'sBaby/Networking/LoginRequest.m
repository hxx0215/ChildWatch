//
//  LoginRequest.m
//  Where'sBaby
//
//  Created by 刘向宏 on 15/9/14.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "BaseHTTPRequestOperationManager.h"
#import "LoginRequest.h"

#define kMethodUserRegister @"/user/userRegister"
#define kMethodUserGetAuthCode @"/user/getRandomCode"
#define kMethodUserLogin @"/user/userLogin"
#define kMethodForgetPassword @"/user/forgetPassword"
#define kMethodResetPassWord @"/user/resetPassword"

@implementation LoginRequest
+ (void)UserRegisterWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [[BaseHTTPRequestOperationManager sharedManager]defaultHTTPWithMethod:kMethodUserRegister WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)GetAuthCodeWithParameters: (id)parameters type:(int)type  success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    if (type==0) {
        [[BaseHTTPRequestOperationManager sharedManager]defaultHTTPWithMethod:kMethodUserGetAuthCode WithParameters:parameters post:YES success:success failure:failure];
    }
    else
    {
        [[BaseHTTPRequestOperationManager sharedManager]defaultHTTPWithMethod:kMethodForgetPassword WithParameters:parameters post:YES success:success failure:failure];
    }
}

+ (void)UserLoginWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [[BaseHTTPRequestOperationManager sharedManager]defaultHTTPWithMethod:kMethodUserLogin WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)ResetPassWordWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [[BaseHTTPRequestOperationManager sharedManager]defaultHTTPWithMethod:kMethodResetPassWord WithParameters:parameters post:YES success:success failure:failure];
}
@end
