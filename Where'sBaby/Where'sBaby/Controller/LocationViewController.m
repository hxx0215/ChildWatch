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

@interface LocationViewController ()
@property (nonatomic,weak) IBOutlet UIView *mapBackView;
@property (nonatomic,weak) IBOutlet UIView *hudView;
@property (nonatomic,weak) IBOutlet UIImageView *loadingImageView;
@property (nonatomic ,strong) MAMapView *mapView;
@end

@implementation LocationViewController
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView = [MapManager MapView];
    [self.mapBackView addSubview:self.mapView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.mapView.frame = self.mapBackView.bounds;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.hudView.hidden = NO;
    [self startAnimation];
    NSDictionary *dic = @{
                          @"deviceno" : [MapManager sharedManager].currentDeviceDic[@"deviceno"]
                          };
    [DeviceRequest GetLastLocationWithParameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.hudView.hidden = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        self.hudView.hidden = YES;
    }];
}

- (void)startAnimation
{
    static NSInteger angle = 0;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
