//
//  LocusSettingViewController.m
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/30.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "LocusSettingViewController.h"
#import <IHKeyboardAvoiding.h>
#import "DateView.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LocusSettingViewController ()<UITextFieldDelegate>
@property (nonatomic,weak) IBOutlet UIButton *okButton;
@property (nonatomic,weak) IBOutlet UIButton *showLineButton;
@property (nonatomic,weak) IBOutlet UIButton *showPointButton;
@property (nonatomic,weak) IBOutlet UITextField *beginTextField;
@property (nonatomic,weak) IBOutlet UITextField *timeTextField;
@property (nonatomic,weak) IBOutlet UIView *backView;
@end

@implementation LocusSettingViewController
{
    UIDatePicker *datePick;
    UIDatePicker *timePick;
    
    DateView *dateView;
    
    NSDate *dateDate;
    NSDate *timeDate;
    long countTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.okButton.layer.cornerRadius = 15;
    self.okButton.layer.masksToBounds = true;
    
    [IHKeyboardAvoiding setAvoidingView:self.backView];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    topView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelChoice)];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneChoice)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:cancelButton,btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    
    UIToolbar * topView2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    topView2.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * btnSpace2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * cancelButton2 = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelChoice2)];
    UIBarButtonItem * doneButton2 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneChoice2)];
    NSArray * buttonsArray2 = [NSArray arrayWithObjects:cancelButton2,btnSpace2,doneButton2,nil];
    [topView2 setItems:buttonsArray2];
    
    datePick = [[UIDatePicker alloc]init];
    datePick.maximumDate = [NSDate date];
    [datePick setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    datePick.datePickerMode = UIDatePickerModeDateAndTime;
    
    timePick = [[UIDatePicker alloc]init];
    timePick.backgroundColor = [UIColor whiteColor];
    [timePick setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    timePick.datePickerMode = UIDatePickerModeCountDownTimer;
    
    dateView = [[DateView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    self.beginTextField.inputView = dateView;
    self.beginTextField.inputAccessoryView = topView;
    
    self.timeTextField.inputView = timePick;
    self.timeTextField.inputAccessoryView = topView2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.timeTextField.isFirstResponder) {
        [self doneChoice2];
    }
    else if (self.beginTextField.isFirstResponder)
    {
        [self doneChoice];
    }
    else
        [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)cancelChoice{
    [self.beginTextField resignFirstResponder];
}

-(void)doneChoice{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateDate = dateView.datePicker.date;
    timeDate = dateView.timePicker.date;
    NSString *destDateString = [dateFormatter stringFromDate:dateView.datePicker.date];
    [dateFormatter setDateFormat:@" HH:mm"];
    NSString *timeDateString = [dateFormatter stringFromDate:dateView.timePicker.date];
    self.beginTextField.text = [NSString stringWithFormat:@"%@%@",destDateString,timeDateString];
    [self.beginTextField resignFirstResponder];
}

-(void)cancelChoice2{
    [self.timeTextField resignFirstResponder];
}

-(void)doneChoice2{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH小时mm分钟"];
    long time = countTime = timePick.countDownDuration/60;
    self.timeTextField.text = [NSString stringWithFormat:@"%ld分钟",time];
    [self.timeTextField resignFirstResponder];
}

-(IBAction)showLineClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(IBAction)showPointClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(IBAction)okClick:(UIButton *)sender{
    if (self.beginTextField.text.length==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请选择开始时间";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (self.timeTextField.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请选择播放时间";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didLocusSetting:)]) {
        [self dismissViewControllerAnimated:NO completion:^{
            [self.delegate didLocusSetting:@[dateDate,timeDate,@(countTime),@(self.showLineButton.selected),@(self.showPointButton.selected)]];
        }];
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
