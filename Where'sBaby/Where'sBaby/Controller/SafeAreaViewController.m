//
//  SafeAreaViewController.m
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/16.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "SafeAreaViewController.h"
#import "MapManager.h"
#import "DeviceRequest.h"
#import <MBProgressHUD.h>
#import "CustomAnnotationView.h"
#import "ChildDeviceManager.h"
#import <UIImageView+AFNetworking.h>
#import "FileRequest.h"
#import "ChildDeviceManager.h"

@interface SafeAreaViewController ()<MAMapViewDelegate,UITextFieldDelegate,AMapSearchDelegate>
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* constraintLabel;
@property (nonatomic,weak) IBOutlet UITextField* nameTextField;
@property (nonatomic,weak) IBOutlet UIButton* homeButton;
@property (nonatomic,weak) IBOutlet UIButton* schollButton;
@property (nonatomic,weak) IBOutlet UIButton* inAlarmButton;
@property (nonatomic,weak) IBOutlet UIButton* outAlarmButton;
@property (nonatomic,weak) IBOutlet UIButton* inAndOutAlarmButton;
@property (nonatomic,weak) IBOutlet UILabel* valueLabel;
@property (nonatomic,weak) IBOutlet UIView* mapBackView;
@property (nonatomic,weak) IBOutlet UIView* valueBackView;

@property (nonatomic ,strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) MACircle *circle;
@end

@implementation SafeAreaViewController
{
    NSInteger value;
    
    NSString *adrress;
    
    CLLocationCoordinate2D locationCoord;
    
    CLLocationDistance distance;
    
    NSInteger alarmType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView = [MapManager MapView];
    [self.mapBackView addSubview:self.mapView];
    [self.mapBackView sendSubviewToBack:self.mapBackView];
    [MapManager MapViewDelegate:self reset:YES];
    self.search = [MapManager MapSearch];
    [MapManager MapSearchDelegate:self reset:YES];
    
    self.homeButton.layer.cornerRadius = 15;
    self.homeButton.layer.masksToBounds = true;
    
    self.schollButton.layer.cornerRadius = 15;
    self.schollButton.layer.masksToBounds = true;
    
    self.valueLabel.layer.cornerRadius = 11;
    self.valueLabel.layer.masksToBounds = true;
    
    alarmType = 1;
    self.inAlarmButton.selected = YES;
    value = 1;
    distance = 500;
    [self updateValueLabelConstraint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.mapView.frame = self.mapBackView.bounds;
}

-(IBAction)backButtonClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)saveButtonClick:(id)sender{
    if ([self.nameTextField.text length]==0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请设置安全区域名称";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (self.circle) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *dic = @{
                                     @"areaname": self.nameTextField.text,
                                     @"deviceno": [ChildDeviceManager sharedManager].currentDeviceNo,
                                     @"lat": @(locationCoord.latitude),
                                     @"lon": @(locationCoord.longitude),
                                     @"locationname": adrress,
                                     @"radius": @(distance),
                                     @"type": @(alarmType)
                                     };
        [DeviceRequest InsertSafeAreaWithParameters:dic success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            hud.mode = MBProgressHUDModeText;
            if (responseObject[@"state"] == 0) {
                hud.detailsLabelText = @"成功";
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                hud.detailsLabelText = @"失败";
            }
            [hud hide:YES afterDelay:1.5f];
        } failure:^(NSError *error) {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = error.domain;
            [hud hide:YES afterDelay:1.5f];
        }];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请设置安全区域";
        [hud hide:YES afterDelay:1.5f];
    }
}
-(IBAction)inAlarmButtonClick:(id)sender{
    self.inAlarmButton.selected = YES;
    self.outAlarmButton.selected = NO;
    self.inAndOutAlarmButton.selected = NO;
    alarmType = 1;
}
-(IBAction)outAlarmButtonClick:(id)sender{
    self.inAlarmButton.selected = NO;
    self.outAlarmButton.selected = YES;
    self.inAndOutAlarmButton.selected = NO;
    alarmType = 2;
}
-(IBAction)inAndOutAlarmButtonClick:(id)sender{
    self.inAlarmButton.selected = NO;
    self.outAlarmButton.selected = NO;
    self.inAndOutAlarmButton.selected = YES;
    alarmType = 3;
}
-(IBAction)homeButtonClick:(id)sender{
    self.nameTextField.text = @"家";
}
-(IBAction)schollButtonClick:(id)sender{
    self.nameTextField.text = @"学校";
}
-(IBAction)addButtonClick:(id)sender{
    if (value == 7){
        return;
    }
    value++;
    [self updateValueLabelConstraint];
}
-(IBAction)lowerButtonClick:(id)sender{
    if (value == 1){
        return;
    }
    value--;
    [self updateValueLabelConstraint];
}

-(IBAction)babyLocationClick:(id)sender{
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode  = MAUserTrackingModeNone;
    [self doLocation];
}

-(IBAction)phoneLocationClick:(id)sender{
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode  = MAUserTrackingModeFollow;
}

-(IBAction)searchLocationClick:(id)sender{
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode  = MAUserTrackingModeNone;
}

-(void)updateValueLabelConstraint{
    self.constraintLabel.constant = self.valueBackView.frame.size.width/8 * value;
    NSString *m = @"500米";
    distance = 500;
    switch (value){
    case 1:
        m = @"500米";
            break;
    case 2:
        {
            m = @"1千米";
            distance = 1000;
        }
            
            break;
    case 3:
        m = @"1.5千米";
            distance = 1500;
            break;
    case 4:
        m = @"2千米";
            distance = 2000;
            break;
    case 5:
        m = @"3千米";
            distance = 3000;
            break;
    case 6:
        m = @"4千米";
            distance = 4000;
            break;
    case 7:
        m = @"5千米";
            distance = 5000;
            break;
    default:
        m = @"500米";
            distance = 500;
            break;
    }
    
    self.valueLabel.text = [NSString stringWithFormat:@"  %@  ",m];
    
    if (self.circle) {
        [self addMACircle];
    }
    
}

// MARK: - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)doLocation
{
    NSDictionary *dic = @{
                          @"deviceno" : [ChildDeviceManager sharedManager].curentDevice.dicBase[@"deviceno"]
                          };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DeviceRequest GetLastLocationWithParameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"state"] integerValue]==0) {
            [ChildDeviceManager sharedManager].curentDevice.dicLocation = [responseObject[@"data"] firstObject];
            [self doReGoecode:[[ChildDeviceManager sharedManager].curentDevice getLocationCoordinate]];
            [hud hide:YES];
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"无法获取宝贝位置";
            [hud hide:YES afterDelay:1.5f];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    }];
}

-(void)doReGoecode:(CLLocationCoordinate2D)coord{
    locationCoord = coord;
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coord.latitude  longitude:coord.longitude];
    //regeo.radius = 10000;
    regeo.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
}

#pragma mark - MAMapView
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        adrress = response.regeocode.formattedAddress;
        NSLog(@"ReGeo: %@", adrress);
        [self addAnnotationWithCooordinate:locationCoord];
    }
}

-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:annotation];
    [self.mapView setRegion:MACoordinateRegionMakeWithDistance(coordinate, 10000, 10000) animated:YES];
    [self addMACircle];
}

-(void)addMACircle{
    [self.mapView removeOverlay:self.circle];
    self.circle = [MACircle circleWithCenterCoordinate:locationCoord radius:distance];
    [self.mapView addOverlay:self.circle];
}

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

#pragma mark - MAMapView
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        self.mapView.showsUserLocation = NO;
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [self doReGoecode:CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude)];
    }
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifierSafeArea];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifierSafeArea];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -10);
            annotationView.image = [UIImage imageNamed:@"位置_空"];
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView setImageWithURL:[NSURL URLWithString:[FileRequest imageURL:[ChildDeviceManager sharedManager].curentDevice.dicBase[@"headimage"]]] placeholderImage:[UIImage imageNamed:@"默认头像1"]];
            imageView.frame = CGRectMake(8, 5, annotationView.frame.size.width-16, annotationView.frame.size.width-16);
            imageView.layer.cornerRadius = imageView.frame.size.width/2;
            //okButton.layer.borderWidth = 0;
            //okButton.layer.borderColor = UIColor.grayColor().CGColor;
            imageView.layer.masksToBounds = true;
            
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

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth   = 0;
        //circleRenderer.strokeColor = [UIColor blueColor];77 190 244
        circleRenderer.fillColor   = [UIColor colorWithRed:77/255.0f green:190/255.0f blue:244/255.0f alpha:0.6f] ;
        
        return circleRenderer;
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
