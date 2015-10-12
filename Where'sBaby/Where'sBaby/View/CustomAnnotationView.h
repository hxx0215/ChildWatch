//
//  CustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) UIView *calloutView;

@property (nonatomic, strong) NSString *top;
@property (nonatomic, strong) NSString *left;
@property (nonatomic, strong) NSString *right;
@end
