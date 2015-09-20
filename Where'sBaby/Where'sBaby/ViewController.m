//
//  ViewController.m
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/9.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "ViewController.h"
#import <SWRevealViewController.h>

@interface ViewController ()
@property (nonatomic,assign) BOOL isLogin;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (self.revealViewController){
        self.revealViewController.rightViewRevealWidth = 102;
    }
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

@end
