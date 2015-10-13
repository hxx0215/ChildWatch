//
//  DeviceManager.h
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/13.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject
@property (nonatomic ,strong) NSDictionary *dicBase;
@property (nonatomic ,strong) NSDictionary *dicLocation;
@end

@interface DeviceManager : NSObject
+(instancetype)sharedManager;
@property (nonatomic ,strong) DeviceModel *curentDevice;
@end
