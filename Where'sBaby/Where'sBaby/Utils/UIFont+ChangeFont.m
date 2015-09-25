//
//  UIFont+ChangeFont.m
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/25.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "UIFont+ChangeFont.h"
#import <objc/message.h>
NSString *const CustomFontName = @"RTWSYueRoudGoDemo-Regular";

@implementation UIFont (ChangeFont)
+ (void)load {
    [self exchangeClassMethod:@selector(systemFontOfSize:) modified:@selector(custom_systemFontOfSize:)];
    [self exchangeClassMethod:@selector(boldSystemFontOfSize:) modified:@selector(custom_boldSystemFontOfSize:)];
    [self exchangeInstanceMethod:@selector(initWithCoder:) modified:@selector(initCustomWithCoder:)];
}
+ (void)exchangeClassMethod:(SEL)origin modified:(SEL)modified{
    Class cls = [self class];
    Method originMethod = class_getClassMethod(cls, origin);
    Method modifiedMethod = class_getClassMethod(cls, modified);
    method_exchangeImplementations(originMethod, modifiedMethod);
}
+ (void)exchangeInstanceMethod:(SEL)origin modified:(SEL)modified{
    Class cls = [self class];
    Method originMethod = class_getInstanceMethod(cls, origin);
    Method modifiedMethod = class_getInstanceMethod(cls, modified);
    method_exchangeImplementations(originMethod, modifiedMethod);
    
}

+ (UIFont *)custom_boldSystemFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:CustomFontName size:size];
}
+ (UIFont *)custom_systemFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:CustomFontName size:size];
}
+ (UIFont *)custom_italicFontofSize:(CGFloat)size{
    return [UIFont fontWithName:CustomFontName size:size];
}
- (id)initCustomWithCoder:(NSCoder *)aDecoder {
    BOOL result = [aDecoder containsValueForKey:@"UIFontDescriptor"];

    if (result) {
        UIFontDescriptor *descriptor = [aDecoder decodeObjectForKey:@"UIFontDescriptor"];
        
        NSString *fontName;
        if ([descriptor.fontAttributes[@"NSCTFontUIUsageAttribute"] isEqualToString:@"CTFontRegularUsage"]) {
            fontName = CustomFontName;
        }
        else if ([descriptor.fontAttributes[@"NSCTFontUIUsageAttribute"] isEqualToString:@"CTFontEmphasizedUsage"]) {
            fontName = CustomFontName;
        }
        else if ([descriptor.fontAttributes[@"NSCTFontUIUsageAttribute"] isEqualToString:@"CTFontObliqueUsage"]) {
            fontName = CustomFontName;
        }
        else {
            fontName = descriptor.fontAttributes[@"NSFontNameAttribute"];
        }
        
        return [UIFont fontWithName:fontName size:descriptor.pointSize];
    }

    self = [self initCustomWithCoder:aDecoder];

    return self;
}
@end
