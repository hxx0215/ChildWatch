//
//  DeviceManager.m
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/13.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "DeviceManager.h"
#import <MAMapKit/MAMapKit.h>

@implementation DeviceModel
{
    double latitude;
    double longitude;
    LocationType type;
}

-(void)setDicLocation:(NSDictionary *)dicLocation
{
    _dicLocation = dicLocation;
    latitude = 0;
    longitude = 0;
    type = LocationTypeOFFLine;
    NSString *str = nil;
    if ([dicLocation[@"gpslocation"] length]>0) {
        type = LocationTypeGPS;
        str = dicLocation[@"gpslocation"];
    }
    if ([dicLocation[@"gsmlocation"] length]>0) {
        type = LocationTypeGSM;
        str = dicLocation[@"gsmlocation"];
    }
    if ([dicLocation[@"wifilocation"] length]>0) {
        type = LocationTypeWIFI;
        str = dicLocation[@"wifilocation"];
    }
    NSArray *array = [str componentsSeparatedByString:@","];
    if ([array count]>=2) {
        longitude = [array[0] doubleValue];
        latitude = [array[1] doubleValue];
    }
}

-(CLLocationCoordinate2D)getLocationCoordinate
{
    CLLocationCoordinate2D location = (CLLocationCoordinate2D){latitude, longitude};
    return location;
}

-(LocationType)getLocationType
{
    return type;
}
@end

@implementation DeviceManager
+(instancetype)sharedManager
{
    static DeviceManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (NSString *)currentDeviceNo{
    return [self.curentDevice.dicBase objectForKey:@"deviceno"];
}
@end
