//
//  UIFont+ChangeFont.m
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/25.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "UIFont+ChangeFont.h"
#import <objc/message.h>

@implementation UIFont (ChangeFont)
+ (void)load {
    Class cls = [self class];
    SEL originSel = @selector(systemFontOfSize:);
    SEL customSel = @selector(custom_systemFontOfSize:);
    Method origin = class_getClassMethod(cls, originSel);
    Method custom = class_getClassMethod(cls, customSel);
    method_exchangeImplementations(origin, custom);
    
    SEL oSel = @selector(fontWithName:size:);
    SEL cSel = @selector(custom_fontWithName:size:);
    method_exchangeImplementations(class_getClassMethod(cls, oSel), class_getClassMethod(cls, cSel));
    
    SEL ioSel = @selector(fontWithName:size:);
    SEL icSel = @selector(custom_fontWithName:size:);
    method_exchangeImplementations(class_getInstanceMethod(cls, ioSel), class_getInstanceMethod(cls, icSel));
}

+ (UIFont *)custom_systemFontOfSize:(CGFloat)size{
    return [UIFont custom_fontWithName:@"RTWSYueRoudGoDemo-Regular" size:size];
    
}

+ (nullable UIFont *)custom_fontWithName:(NSString *)fontName size:(CGFloat)fontSize{
    return [UIFont custom_fontWithName:@"RTWSYueRoudGoDemo-Regular" size:fontSize];
}


- (UIFont *)custom_fontWithSize:(CGFloat)fontSize{
    return [UIFont custom_fontWithName:@"RTWSYueRoudGoDemo-Regular" size:fontSize];
}
@end
