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
@end
