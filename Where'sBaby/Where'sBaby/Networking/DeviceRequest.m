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
#define kMethodUpdateDeviceConfigInfo @"/device/updateDeviceConfig"
#define kMethodFindDevice @"/device/findoutCommand"

#define kMethodGetSafeAreaList @"/safeArea/getSafeAreaList"
#define kMethodInsertSafeArea @"/safeArea/insertSafeArea"
#define kMethodUpdateSafeArea @"/safeArea/updateSafeArea"
#define kMethodDeleteSafeArea @"/safeArea/deleteSafeArea"

#define kMethodGetPhoneBookList @"/user/getPhoneBookList"
#define kMethodAddFriends @"/user/addFriends"
#define kMethodUpdatePhoneBook @"/user/updatePhoneBook"
#define kMethodDeletePhoneBook @"/user/deletePhoneBook"

#define kMethodAssignAdmin @"/user/assignAdmin"
#define kMethodRemoveDeviceBind @"/user/removeDeviceBind"

#define kMethodGetTrackByDeviceNo @"/device/getTrackByDeviceNo"

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

+ (void)UpdateDeviceConfigInfoWithParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodUpdateDeviceConfigInfo WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)FindDeviceWithParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodFindDevice WithParameters:parameters post:YES success:success failure:failure];
}

//安全区域
//查询安全区域列表/safeArea/getSafeAreaList
+ (void)GetSafeAreaListWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodGetSafeAreaList WithParameters:parameters post:YES success:success failure:failure];
}
//添加安全区域/safeArea/
+ (void)InsertSafeAreaWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodInsertSafeArea WithParameters:parameters post:YES success:success failure:failure];
}
//编辑安全区域/safeArea/updateSafeArea
+ (void)UpdateSafeAreaWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodUpdateSafeArea WithParameters:parameters post:YES success:success failure:failure];
}
//删除安全区域/safeArea/deleteSafeArea
+ (void)DeleteSafeAreaWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodDeleteSafeArea WithParameters:parameters post:YES success:success failure:failure];
}
//end安全区域

+ (void)GetPhoneBookListWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodGetPhoneBookList WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)AddFriendsWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodAddFriends WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)UpdatePhoneBookWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodUpdatePhoneBook WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)DeletePhoneBookWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodDeletePhoneBook WithParameters:parameters post:YES success:success failure:failure];
}


+ (void)AssignAdminWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodAssignAdmin WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)RemoveDeviceBindWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodRemoveDeviceBind WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)GetTrackByDeviceNoWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    [[BaseHTTPRequestOperationManager sharedManager] defaultHTTPWithMethod:kMethodGetTrackByDeviceNo WithParameters:parameters post:YES success:success failure:failure];
}
@end
