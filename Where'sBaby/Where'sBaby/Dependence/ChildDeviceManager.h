//
//  DeviceManager.h
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/13.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
@class AMapTip;
typedef enum {
    LocationTypeWIFI,
    LocationTypeGPS,
    LocationTypeGSM,
    LocationTypeOFFLine
}LocationType;

@interface DeviceModel : NSObject
@property (nonatomic ,strong) NSDictionary *dicBase;
@property (nonatomic ,strong) NSDictionary *dicLocation;
@property (nonatomic ,strong) NSMutableDictionary *dicBabyData;
@property (nonatomic ,strong) AMapTip *mapTip;
-(CLLocationCoordinate2D)getLocationCoordinate;
-(LocationType)getLocationType;
@end

@interface ChildDeviceManager : NSObject
+(instancetype)sharedManager;
@property (nonatomic ,strong) DeviceModel *curentDevice;
@property (nonatomic, readonly) NSString *currentDeviceNo;
@property (nonatomic, readonly) NSString *currentNickName;
@end
