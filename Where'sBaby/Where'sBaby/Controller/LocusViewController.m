//
//  LocusViewController.m
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/30.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "LocusViewController.h"
#import "MapManager.h"
#import "LocusSettingViewController.h"
#import <MBProgressHUD.h>
#import "DeviceRequest.h"
#import "ChildDeviceManager.h"

@interface LocusViewController ()<MAMapViewDelegate,LocusSettingViewControllerDelegate>
@property (nonatomic,weak) IBOutlet UIView *mapBackView;
@property (nonatomic ,strong) MAMapView *mapView;
@end

@implementation LocusViewController
{
    BOOL first;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView = [MapManager MapView];
    [self.mapBackView addSubview:self.mapView];
    [self.mapBackView sendSubviewToBack:self.mapBackView];
    [MapManager MapViewDelegate:self reset:YES];
    
    NSLog(@"%@",self.array);
    first = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (first) {
        [self laodLocus];
        first = NO;
    }
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.mapView.frame = self.mapBackView.bounds;
}

-(IBAction)backClic:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)resetClic:(id)sender
{
    
    
}

-(void)laodLocus
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDate *dateBig = self.array[0];
    NSDate *dateSmall = self.array[1];
    long countTime = [self.array[2] longValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMdd"];
    NSString *big = [dateFormatter stringFromDate:dateBig];
    [dateFormatter setDateFormat: @"HHmm"];
    NSString *small = [dateFormatter stringFromDate:dateSmall];
    NSString *dateString = [NSString stringWithFormat:@"%@%@00",big,small];
    NSLog(@"%@",dateString);
    [dateFormatter setDateFormat: @"yyyyMMddHHmm00"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSDate *dateAfter = [NSDate dateWithTimeInterval:countTime*60 sinceDate:date];
    NSString *dateAfterString = [dateFormatter stringFromDate:dateAfter];
    NSLog(@"%@",dateAfterString);
    
    NSDictionary *dic = @{
                          @"deviceno" : [ChildDeviceManager sharedManager].curentDevice.dicBase[@"deviceno"],
                          @"starttime" : dateString,
                          @"endtime" : dateAfterString
                          };
    [DeviceRequest GetTrackByDeviceNoWithParameters:dic success:^(id responseObject)
    {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"state"] integerValue]==0) {
            [hud hide:YES];
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"无法获取宝贝轨迹";
            [hud hide:YES afterDelay:1.5f];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    } ];
    
}
#pragma mark - LocusSettingViewControllerDelegate

-(void)didLocusSetting:(NSArray *)array{
    NSLog(@"%@",array);
    self.array = array;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"LocusSettingIdentifier"]) {
        LocusSettingViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}


@end
