//
//  DeviceRequest.h
//  Where'sBaby
//
//  Created by 刘向宏 on 15/9/22.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceRequest : NSObject
+ (void)DeviceListWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)GetLastLocationWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)LocationCommandWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)GetDeviceInfoWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)UpdateDeviceInfoWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)GetDeviceConfigInfoWithParameters: (id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)UpdateDeviceConfigInfoWithParameters: (id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)FindDeviceWithParameters: (id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//安全区域
//查询安全区域列表/safeArea/getSafeAreaList
+ (void)GetSafeAreaListWithParameters: (id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//添加安全区域/safeArea/
+ (void)InsertSafeAreaWithParameters: (id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//编辑安全区域/safeArea/updateSafeArea
+ (void)UpdateSafeAreaWithParameters: (id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//删除安全区域/safeArea/deleteSafeArea
+ (void)DeleteSafeAreaWithParameters: (id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end安全区域

+ (void)GetPhoneBookListWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)AddFriendsWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)UpdatePhoneBookWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)DeletePhoneBookWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)AssignAdminWithParameters: (id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end
