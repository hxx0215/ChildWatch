//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"

#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   250.0
#define kCalloutHeight  70.0

@interface CustomAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@end

@implementation CustomAnnotationView

@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;

#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark - Override

-(void)setTop:(NSString *)top
{
    self.topLabel.text = top;
}

- (NSString *)top
{
    return self.topLabel.text;
}

-(void)setLeft:(NSString *)left
{
    self.leftLabel.text = left;
}

- (NSString *)left
{
    return self.leftLabel.text;
}

-(void)setRight:(NSString *)right
{
    self.rightLabel.text = right;
}

- (NSString *)right
{
    return self.rightLabel.text;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            [self.topLabel sizeToFit];
            [self.leftLabel sizeToFit];
            [self.rightLabel sizeToFit];
            CGFloat widthT = self.topLabel.bounds.size.width+60;
            CGFloat widthB = kCalloutWidth;
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, widthT>widthB?widthT:widthB, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            [self.calloutView addSubview:self.topLabel];
            [self.calloutView addSubview:self.leftLabel];
            [self.calloutView addSubview:self.rightLabel];
            [self.calloutView bringSubviewToFront:self.topLabel];
            self.topLabel.frame = CGRectMake(30, 12, self.topLabel.frame.size.width, self.topLabel.frame.size.height);
            self.leftLabel.frame = CGRectMake(30, 29, self.leftLabel.frame.size.width, self.leftLabel.frame.size.height);
            self.rightLabel.frame = CGRectMake(self.calloutView.frame.size.width - self.rightLabel.frame.size.width - 30, 29, self.rightLabel.frame.size.width, self.rightLabel.frame.size.height);
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        //[self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
        self.backgroundColor = [UIColor clearColor];
        
//        /* Create portrait image view and add to view hierarchy. */
//        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
//        [self addSubview:self.portraitImageView];
//        
//        /* Create name label. */
//        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitWidth + kHoriMargin,
//                                                                   kVertMargin,
//                                                                   kWidth - kPortraitWidth - kHoriMargin,
//                                                                   kHeight - 2 * kVertMargin)];
//        self.nameLabel.backgroundColor  = [UIColor clearColor];
//        self.nameLabel.textAlignment    = UITextAlignmentCenter;
//        self.nameLabel.textColor        = [UIColor whiteColor];
//        self.nameLabel.font             = [UIFont systemFontOfSize:15.f];
//        [self addSubview:self.nameLabel];
        self.topLabel = [[UILabel alloc]init];
        self.topLabel.textColor = [UIColor darkGrayColor];
        self.topLabel.font = [UIFont systemFontOfSize:14];
        self.leftLabel = [[UILabel alloc]init];
        self.leftLabel.textColor = [UIColor darkGrayColor];
        self.leftLabel.font = [UIFont systemFontOfSize:14];
        self.rightLabel = [[UILabel alloc]init];
        self.rightLabel.textColor = [UIColor lightGrayColor];
        self.rightLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return self;
}

@end
