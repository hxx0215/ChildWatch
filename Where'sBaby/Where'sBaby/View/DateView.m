//
//  DateView.m
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/30.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "DateView.h"

@interface DateView()
@property (nonatomic,weak) IBOutlet UIView *contentView;
@end

@implementation DateView
{
    long year;
    long month;
    long day;
    long hours;
    long mints;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"DateView" owner:self options:nil];
        [self addSubview:self.contentView];
        self.datePicker.maximumDate = [NSDate date];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
