//
//  ViewController.m
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/9.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "ViewController.h"
#import <SWRevealViewController.h>
#import <MAMapKit/MAMapKit.h>
//#import "CustomAnnotationView.h"
IB_DESIGNABLE

@interface MapBackView : MAMapView
@end
@implementation MapBackView

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        self.showsScale = NO;
        self.showsCompass = NO;
        self.showsUserLocation = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.clipsToBounds = YES;
}
@end

@interface ViewController () <MAMapViewDelegate>
@property (nonatomic,assign) BOOL isLogin;
@property (nonatomic,weak) IBOutlet MapBackView *mapView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (self.revealViewController){
        self.revealViewController.rightViewRevealWidth = 102;
    }
    self.mapView.delegate = self;
    [self addAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"id"]){
        [self.navigationController performSegueWithIdentifier:@"WelcomSegueIdentifier" sender:nil];
    }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"devicebind"] integerValue] != 0) {
            [self performSegueWithIdentifier:@"BindingSegueIdentifier" sender:nil];
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
    
    randomPoint.x = arc4random() % (int)(CGRectGetWidth(self.mapView.bounds));
    randomPoint.y = arc4random() % (int)(CGRectGetHeight(self.mapView.bounds));
    
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

#pragma mark - Action Handle

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
//    if ([view isKindOfClass:[CustomAnnotationView class]]) {
//        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
//        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
//        
//        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-8, -8, -8, -8));
//        
//        if (!CGRectContainsRect(self.mapView.frame, frame))
//        {
//            /* Calculate the offset to make the callout view show up. */
//            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
//            
//            CGPoint theCenter = self.mapView.center;
//            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
//            
//            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
//            
//            [self.mapView setCenterCoordinate:coordinate animated:YES];
//        }
//        
//    }
}

- (void)addAction
{
    
    CLLocationCoordinate2D randomCoordinate = [self.mapView convertPoint:[self randomPoint] toCoordinateFromView:self.mapView];
    
    [self addAnnotationWithCooordinate:randomCoordinate];
}
@end
