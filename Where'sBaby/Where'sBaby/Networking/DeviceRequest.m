//
//  DeviceRequest.m
//  Where'sBaby
//
//  Created by 刘向宏 on 15/9/22.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "DeviceRequest.h"
#import "BaseHTTPRequestOperationManager.h"

#define kMethodUserDeviceList @"/user/getMyDeviceList"
#define kMethodGetLastLocation @"/device/getLastLocationByDeviceNo"
#define kMethodLocationCommand @"/device/locationCommand"
#define kMethodGetDeviceInfo @"/device/getDeviceInfo"
#define kMethodUpdateDeviceInfo @"/device/updateDeviceInfo"
#define kMethodGetDeviceConfigInfo @"/device/getDeviceConfigInfo"

@implementation DeviceRequest
+ (void)DeviceListWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [[BaseHTTPRequestOperationManager sharedManager]defaultHTTPWithMethod:kMethodUserDeviceList WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)GetLastLocationWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [[BaseHTTPRequestOperationManager sharedManager]defaultHTTPWithMethod:kMethodGetLastLocation WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)LocationCommandWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [[BaseHTTPRequestOperationManager sharedManager]defaultHTTPWithMethod:kMethodLocationCommand WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)GetDeviceInfoWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [[BaseHTTPRequestOperationManager sharedManager]defaultHTTPWithMethod:kMethodGetDeviceInfo WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)UpdateDeviceInfoWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [[BaseHTTPRequestOperationManager sharedManager]defaultHTTPWithMethod:kMethodUpdateDeviceInfo WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)GetDeviceConfigInfoWithParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodGetDeviceConfigInfo WithParameters:parameters post:YES success:success failure:failure];
}
@end
