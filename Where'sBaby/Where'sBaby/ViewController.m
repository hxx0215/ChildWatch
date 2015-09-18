//
//  ViewController.m
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/9.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,assign) BOOL isLogin;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"devicebind"] integerValue] == 0) {
            [self performSegueWithIdentifier:@"BindingSegueIdentifier" sender:nil];
        }
    }
    
}

@end
