//
//  ViewController.m
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/9.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "ViewController.h"
#import <SWRevealViewController.h>
#import "MapManager.h"
#import "DeviceRequest.h"
#import <UIButton+AFNetworking.h>
#import "ChildDeviceManager.h"
#import "filerequest.h"
#import <MBProgressHUD.h>
//#import "CustomAnnotationView.h"
//IB_DESIGNABLE

@interface MapBackView : UIView
@property (nonatomic,strong) MAMapView *mapView;
@end
@implementation MapBackView

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        
    }
    return self;
}
-(void)setMapView:(MAMapView *)mapView
{
    _mapView = mapView;
    [self addSubview:mapView];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.mapView.frame = self.bounds;
}
-(void)drawRect:(CGRect)rect{
    self.layer.cornerRadius = self.bounds.size.width / 2;
    self.clipsToBounds = YES;
}
@end

@interface ViewController () <MAMapViewDelegate>
@property (nonatomic,assign) BOOL isLogin;
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,weak) IBOutlet MapBackView *mapViewContant;
@property (nonatomic,weak) IBOutlet UIView *mapBackView;

@property (nonatomic,weak) IBOutlet UIButton *childButtonCurrent;
@property (nonatomic,weak) IBOutlet UILabel *childLabelCurrent;
@property (nonatomic,weak) IBOutlet UIButton *childButton1;
@property (nonatomic,weak) IBOutlet UILabel *childLabel1;
@property (nonatomic,weak) IBOutlet UIButton *childButton2;
@property (nonatomic,weak) IBOutlet UILabel *childLabel2;
@property (nonatomic,weak) IBOutlet UIButton *childButton3;
@property (nonatomic,weak) IBOutlet UILabel *childLabel3;
@property (nonatomic,weak) IBOutlet UIButton *childButton4;
@property (nonatomic,weak) IBOutlet UILabel *childLabel4;
@end

@implementation ViewController
{
    NSInteger childTag;
    NSMutableArray *childDeviceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (self.revealViewController){
        self.revealViewController.rightViewRevealWidth = 102;
    }
    
    _childButtonCurrent.imageView.layer.cornerRadius = (66-8)/2;
    _childButtonCurrent.imageView.layer.masksToBounds = YES;
    _childButton1.imageView.layer.cornerRadius = (30-4)/2;
    _childButton1.imageView.layer.masksToBounds = YES;
    _childButton2.imageView.layer.cornerRadius = (30-4)/2;
    _childButton2.imageView.layer.masksToBounds = YES;
    _childButton3.imageView.layer.cornerRadius = (30-4)/2;
    _childButton3.imageView.layer.masksToBounds = YES;
    _childButton4.imageView.layer.cornerRadius = (30-4)/2;
    _childButton4.imageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapClick:)];
    self.mapBackView.userInteractionEnabled = YES;
    [self.mapBackView addGestureRecognizer:tapGesture];
    
    [self addAction];
    [self updateChild];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mapView = [MapManager MapView];
    self.mapViewContant.mapView = self.mapView;
    [MapManager MapViewDelegate:self reset:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"id"]){
        [self.navigationController performSegueWithIdentifier:@"WelcomSegueIdentifier" sender:nil];
        childDeviceArray = nil;
        childTag = 0;
    }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"devicebind"] integerValue] == 0) {
            [self performSegueWithIdentifier:@"BindingSegueIdentifier" sender:nil];
        }
        else
        {
            NSDictionary *rDic = @{
                                   @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]
                                   };
            [DeviceRequest DeviceListWithParameters:rDic success:^(id responseObject) {
                NSLog(@"%@",responseObject);
                if (responseObject[@"state"]&&[responseObject[@"state"] integerValue]==0)
                {
                    NSArray *array = responseObject[@"data"];
                    childDeviceArray = [[NSMutableArray alloc]init];
                    for (NSDictionary *dic in array) {
                        DeviceModel *model = [[DeviceModel alloc]init];
                        model.dicBase = dic;
                        [childDeviceArray addObject:model];
                    }
                    [self updateChild];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
    }
    
}
- (IBAction)menuClicked:(UIButton *)sender {
    if (self.revealViewController){
        [self.revealViewController rightRevealToggle:sender];
    }
}
- (IBAction)hideMenu:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    }
}

- (IBAction)childButtonClicked:(UIButton *)sender {
    if (sender.tag ==0) {
        [self.revealViewController performSegueWithIdentifier:@"baby" sender:nil];
    }
    else if ([childDeviceArray count] == sender.tag) {
        [self performSegueWithIdentifier:@"BindingSegueIdentifier" sender:nil];
    }
    else
    {
        if ((childTag+1)<=sender.tag) {
            childTag = sender.tag;
        }
        else
            childTag = sender.tag-1;
        [self updateChild];
    }
}

-(IBAction)safeButtonClick:(id)sender
{
    if ([ChildDeviceManager sharedManager].curentDevice) {
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        [self performSegueWithIdentifier:@"SafeIdentifier" sender:nil];
    }
    
}

-(IBAction)callPhoneClick:(id)sender
{
    NSDictionary *dic = @{
                          @"deviceno" : [ChildDeviceManager sharedManager].currentDeviceNo
                          };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DeviceRequest GetDeviceInfoWithParameters:dic success:^(id responseObject) {
        if ([responseObject[@"state"] integerValue]==0) {
            [ChildDeviceManager sharedManager].curentDevice.dicBabyData = [[NSMutableDictionary alloc] initWithDictionary:[responseObject[@"data"] firstObject]];
            [hud hide:YES];
            
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[ChildDeviceManager sharedManager].curentDevice.dicBabyData[@"mobile"]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"获取宝贝资料失败";
            [hud hide:YES afterDelay:1.5f];
        }
    } failure:^(NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    }];
}
//-(IBAction)selector:(id)sender)

-(void)mapClick:(id)sender
{
    NSLog(@"mapClick");
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    [self performSegueWithIdentifier:@"LocationIdentifier" sender:nil];
}

-(void)updateChild
{
    for (NSInteger i=1,j=0; i<5; j++) {
        DeviceModel *device = nil;
        if (j<[childDeviceArray count]) {
            device = [childDeviceArray objectAtIndex:j];
        }
        if (childTag == j) {
            [self setChildButton:self.childButtonCurrent label:self.childLabelCurrent whithDic:device add:NO];
            [ChildDeviceManager sharedManager].curentDevice = device;
        }
        else
        {
            UIButton *btn = nil;
            UILabel *label = nil;
            switch (i) {
                case 1:
                {
                    btn = self.childButton1;
                    label = self.childLabel1;
                }
                    break;
                case 2:
                {
                    btn = self.childButton2;
                    label = self.childLabel2;
                }
                    break;
                case 3:
                {
                    btn = self.childButton3;
                    label = self.childLabel3;
                }
                    break;
                case 4:
                {
                    btn = self.childButton4;
                    label = self.childLabel4;
                }
                    break;
                    
                default:
                    break;
            }
            if (j == ([childDeviceArray count])) {
                [self setChildButton:btn label:label whithDic:nil add:YES];
            }
            else
                [self setChildButton:btn label:label whithDic:device add:NO];
            i++;
        }
    }
}

-(void)setChildButton:(UIButton *)btn label:(UILabel *)label whithDic:(DeviceModel *)model add:(BOOL)add
{
    if (add) {
        btn.hidden = NO;
        label.hidden = NO;
        [btn setImage:[UIImage imageNamed:@"增加"] forState:UIControlStateNormal];
        label.text = @"添加";
    }
    else if (model==nil) {
        btn.hidden = YES;
        label.hidden = YES;
    }
    else
    {
        btn.hidden = NO;
        label.hidden = NO;
        [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[FileRequest imageURL:model.dicBase[@"headimage"]]] placeholderImage:[UIImage imageNamed:@"默认头像1"]];
        label.text = [model.dicBase[@"nickname"] length]>0?model.dicBase[@"nickname"]:@"宝贝";
    }
}
         
#pragma mark - Utility
-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title    = @"宝贝";
    annotation.subtitle = @"宝贝位置";
    
    [self.mapView addAnnotation:annotation];
}

- (CGPoint)randomPoint
{
    CGPoint randomPoint = CGPointZero;
    
    randomPoint.x = arc4random() % (int)(CGRectGetWidth(self.mapViewContant.bounds));
    randomPoint.y = arc4random() % (int)(CGRectGetHeight(self.mapViewContant.bounds));
    
    return randomPoint;
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
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
            annotationView.image = [UIImage imageNamed:@"位置"];
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)addAction
{
    
    CLLocationCoordinate2D randomCoordinate = [self.mapView convertPoint:[self randomPoint] toCoordinateFromView:self.mapView];
    
    [self addAnnotationWithCooordinate:randomCoordinate];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
@end
