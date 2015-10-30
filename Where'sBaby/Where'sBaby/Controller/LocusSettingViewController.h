//
//  LocusSettingViewController.h
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/30.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocusSettingViewControllerDelegate <NSObject>
-(void)didLocusSetting:(NSArray *)array;
@end

@interface LocusSettingViewController : UIViewController
@property (nonatomic,weak) id<LocusSettingViewControllerDelegate> delegate;
@end
