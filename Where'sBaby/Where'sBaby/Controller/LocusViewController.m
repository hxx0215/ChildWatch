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

@interface LocusViewController ()<MAMapViewDelegate,LocusSettingViewControllerDelegate>
@property (nonatomic,weak) IBOutlet UIView *mapBackView;
@property (nonatomic ,strong) MAMapView *mapView;
@end

@implementation LocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView = [MapManager MapView];
    [self.mapBackView addSubview:self.mapView];
    [self.mapBackView sendSubviewToBack:self.mapBackView];
    [MapManager MapViewDelegate:self reset:YES];
    
    NSLog(@"%@",self.array);
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

-(IBAction)backClic:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)resetClic:(id)sender
{
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
