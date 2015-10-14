//
//  DeviceManager.h
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/13.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

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
-(CLLocationCoordinate2D)getLocationCoordinate;
-(LocationType)getLocationType;
@end

@interface DeviceManager : NSObject
+(instancetype)sharedManager;
@property (nonatomic ,strong) DeviceModel *curentDevice;
@property (nonatomic, readonly) NSString *currentDeviceNo;
@end
