//
//  LoginRequest.h
//  Where'sBaby
//
//  Created by 刘向宏 on 15/9/14.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHTTPRequestOperationManager.h"

@interface LoginRequest : BaseHTTPRequestOperationManager

+ (void)UserRegisterWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)GetAuthCodeWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)UserLoginWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)ForgetPasswordWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)ResetPassWordWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
