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
@property (nonatomic, strong) AMapSearchAPI *search;
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
        
        _sharedInstance.search = [[AMapSearchAPI alloc] init];
    });
    return _sharedInstance;
}

+(MAMapView *)MapView
{
    return [MapManager sharedManager].mapView;
}

+(AMapSearchAPI *)MapSearch{
    return [MapManager sharedManager].search;
}

+(void)MapViewDelegate:(id<MAMapViewDelegate>)delegate reset:(BOOL)reset
{
    [MapManager sharedManager].mapView.delegate = delegate;
    if (reset) {
        [[MapManager sharedManager].mapView removeAnnotations:[MapManager sharedManager].mapView.annotations];
        [[MapManager sharedManager].mapView removeOverlays:[MapManager sharedManager].mapView.overlays];
    }
}

+(void)MapSearchDelegate:(id<AMapSearchDelegate>)delegate reset:(BOOL)reset{
    [MapManager sharedManager].search.delegate = delegate;
}
@end
