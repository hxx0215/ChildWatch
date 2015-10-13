//
//  DeviceManager.m
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/13.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "DeviceManager.h"

@implementation DeviceModel
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
@end
