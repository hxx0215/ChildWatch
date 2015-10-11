//
//  MapManager.m
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/10.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "MapManager.h"

@interface MapManager()
@property (nonatomic ,strong) MAMapView *mapView;
@end

@implementation MapManager
+(instancetype)sharedManager
{
    static MapManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.mapView = [[MAMapView alloc]init];
        _sharedInstance.mapView.showsScale = NO;
        _sharedInstance.mapView.showsCompass = NO;
        _sharedInstance.mapView.showsUserLocation = NO;
    });
    return _sharedInstance;
}

+(MAMapView *)MapView
{
    return [MapManager sharedManager].mapView;
}
@end
