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
@end
