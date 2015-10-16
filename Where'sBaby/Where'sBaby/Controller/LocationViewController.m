//
//  LocationViewController.m
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/10.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "LocationViewController.h"
#import "MapManager.h"
#import "DeviceRequest.h"
#import "CustomAnnotationView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "ChildDeviceManager.h"

@interface LocationViewController () <AMapSearchDelegate,MAMapViewDelegate>
@property (nonatomic,weak) IBOutlet UIView *mapBackView;
@property (nonatomic,weak) IBOutlet UIView *hudView;
@property (nonatomic,weak) IBOutlet UIImageView *loadingImageView;
@property (nonatomic,weak) IBOutlet UIButton *typeButton;
@property (nonatomic,weak) IBOutlet UILabel *typeLabel;
@property (nonatomic,weak) IBOutlet UIImageView *typeImageView;
@property (nonatomic,weak) IBOutlet UIButton *locationButton;
@property (nonatomic ,strong) MAMapView *mapView;
@property (nonatomic ,strong) UIView *holdView;
@end

@implementation LocationViewController
{
    NSTimer *countDownTimer;
    long timeCount;
    BOOL first;
    NSInteger angle;

    AMapSearchAPI *_search;
    NSString *adrress;
    
    BOOL offLine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView = [MapManager MapView];
    [self.mapBackView addSubview:self.mapView];
    [self.mapBackView sendSubviewToBack:self.mapBackView];
    [MapManager MapViewDelegate:self reset:YES];
    [MapManager MapSearchDelegate:self reset:YES];
    _search = [MapManager MapSearch];
    
    self.holdView = [[UIView alloc]init];
    self.holdView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.mapBackView addSubview:self.holdView];
    [self.mapBackView bringSubviewToFront:self.holdView];

    timeCount = 0;
    first = YES;
    angle = 0;
    offLine = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (first) {
        [self showHudView];
        [self startAnimation];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (countDownTimer) {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.mapView.frame = self.mapBackView.bounds;
    self.holdView.frame = self.mapBackView.bounds;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (first) {
        first = NO;
        NSDictionary *dic = @{
                              @"deviceno" : [ChildDeviceManager sharedManager].curentDevice.dicBase[@"deviceno"]
                              };
        [DeviceRequest LocationCommandWithParameters:dic success:^(id responseObject) {
            NSLog(@"LocationCommand %@",responseObject);
            if ([responseObject[@"state"] integerValue]==0) {
                offLine = NO;
                countDownTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(countDownTest) userInfo:nil repeats:YES];
            }
            else
            {
                [self doLocation];
                offLine = YES;
            }
            
        } failure:^(NSError *error) {
            NSLog(@"LocationCommand %@",error);
        }];
    }
}

- (void)startAnimation
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI /180.0f));
    [UIView animateWithDuration:0.03 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.loadingImageView.transform = endAngle;
    } completion:^(BOOL finished) {
        angle += 15;
        if (self.hudView.hidden == NO) {
            [self startAnimation];
        }
    }];
    
}

-(IBAction)backClic:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)locationClick:(id)sender
{
    if (countDownTimer) {
        return;
    }
    [self doLocation];
}

-(void)countDownTest{
    timeCount++;
    if (timeCount>3) {
        if (countDownTimer) {
            [countDownTimer invalidate];
            countDownTimer = nil;
        }
    }
    [self showHudView];
    [self doLocation];
}

-(void)doLocation
{
    NSDictionary *dic = @{
                          @"deviceno" : [ChildDeviceManager sharedManager].curentDevice.dicBase[@"deviceno"]
                          };
    [DeviceRequest GetLastLocationWithParameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"state"] integerValue]==0) {
            [ChildDeviceManager sharedManager].curentDevice.dicLocation = [responseObject[@"data"] firstObject];
            //构造AMapReGeocodeSearchRequest对象
            AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
            regeo.location = [AMapGeoPoint locationWithLatitude:[[ChildDeviceManager sharedManager].curentDevice getLocationCoordinate].latitude  longitude:[[ChildDeviceManager sharedManager].curentDevice getLocationCoordinate].longitude];
            //regeo.radius = 10000;
            regeo.requireExtension = YES;
            //发起逆地理编码
            [_search AMapReGoecodeSearch: regeo];
        }
        else
        {
            [self hideHudView];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self hideHudView];
    }];
}

-(void)showHudView
{
    self.hudView.hidden = NO;
    self.holdView.hidden = NO;
    self.locationButton.hidden = YES;
    self.typeButton.hidden = YES;
    self.typeLabel.hidden = YES;
    self.typeImageView.hidden = YES;
}

-(void)hideHudView
{
    if (!self.hudView.hidden) {
        self.hudView.hidden = YES;
        self.holdView.hidden = YES;
        self.locationButton.hidden = NO;
        self.typeButton.hidden = NO;
        self.typeLabel.hidden = NO;
        self.typeImageView.hidden = NO;
    }
}

-(void)upDateUi
{
    switch ([[ChildDeviceManager sharedManager].curentDevice getLocationType]) {
        case LocationTypeWIFI:
        {
            self.typeImageView.hidden = self.typeLabel.hidden = YES;
            [self.typeButton setBackgroundImage:[UIImage imageNamed:@"WIFI定位"] forState:UIControlStateNormal];
        }
            break;
        case LocationTypeGPS:
        {
            self.typeImageView.hidden = self.typeLabel.hidden = YES;
            [self.typeButton setBackgroundImage:[UIImage imageNamed:@"GPS定位"] forState:UIControlStateNormal];
        }
            break;
        case LocationTypeGSM:
        {
            self.typeLabel.text = @"基站定位准确度比较差,建议移动到开阔地带使用GPS定位";
            self.typeImageView.hidden = self.typeLabel.hidden = NO;
            [self.typeButton setBackgroundImage:[UIImage imageNamed:@"GSM定位"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    if (offLine) {
        self.typeLabel.text = @"手表不在线,当前为最后一次定位位置";
        self.typeImageView.hidden = self.typeLabel.hidden = NO;
    }
}

#pragma mark - Utility

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    [self hideHudView];
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        adrress = response.regeocode.formattedAddress;
        NSLog(@"ReGeo: %@", adrress);
        [self addAnnotationWithCooordinate:[[ChildDeviceManager sharedManager].curentDevice getLocationCoordinate]];
    }
}

-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:annotation];
    [self.mapView setRegion:MACoordinateRegionMakeWithDistance(coordinate, 10000, 10000) animated:YES];
    [self upDateUi];
}

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}
#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier2";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
            annotationView.image = [UIImage imageNamed:@"位置_空"];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"语音"]];
            imageView.frame = CGRectMake(8, 5, annotationView.frame.size.width-16, annotationView.frame.size.width-16);
            [annotationView addSubview:imageView];
            annotationView.top = adrress;
            annotationView.left = @"10fenzhong";
            annotationView.right = @"jingdu100m";
            annotationView.selected = YES;
        }
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Action Handle

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
        if ([view isKindOfClass:[CustomAnnotationView class]]) {
            CustomAnnotationView *cusView = (CustomAnnotationView *)view;
            CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
    
            frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-8, -8, -8, -8));
    
            if (!CGRectContainsRect(self.mapView.frame, frame))
            {
                /* Calculate the offset to make the callout view show up. */
                CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
    
                CGPoint theCenter = self.mapView.center;
                theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
    
                CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
    
                [self.mapView setCenterCoordinate:coordinate animated:YES];
            }
            
        }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
