//
//  LoginRequest.m
//  Where'sBaby
//
//  Created by 刘向宏 on 15/9/14.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "LoginRequest.h"

#define kMethodUserRegister @"/user/userRegister"
#define kMethodUserGetAuthCode @"/user/getRandomCode"
#define kMethodUserLogin @"/user/userLogin"
#define kMethodForgetPassword @"/user/forgetPassword"
#define kMethodResetPassWord @"/user/resetPassWord"

@implementation LoginRequest
+ (void)UserRegisterWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodUserRegister WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)GetAuthCodeWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodUserGetAuthCode WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)UserLoginWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodUserLogin WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)ForgetPasswordWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodForgetPassword WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)ResetPassWordWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodResetPassWord WithParameters:parameters post:YES success:success failure:failure];
}
@end
