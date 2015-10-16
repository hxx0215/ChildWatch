//
//  MapManager.h
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/10.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MapManager : NSObject
+(instancetype)sharedManager;
+(MAMapView *)MapView;
+(AMapSearchAPI *)MapSearch;
+(void)MapViewDelegate:(id<MAMapViewDelegate>)delegate reset:(BOOL)reset;
+(void)MapSearchDelegate:(id<AMapSearchDelegate>)delegate reset:(BOOL)reset;
@end
