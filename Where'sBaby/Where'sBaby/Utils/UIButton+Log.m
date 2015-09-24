//
//  UIButton+Log.m
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/24.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "UIButton+Log.h"
#import <objc/message.h>

@implementation UIButton (Log)

+(void)load{
    Class cls= [self class];
    SEL originAddtarget = @selector(addTarget:action:forControlEvents:);
    SEL swizAddtarget = @selector(swizz_addTarget:action:forControlEvents:);
    Method origin = class_getInstanceMethod(cls, originAddtarget);
    Method swizz = class_getInstanceMethod(cls, swizAddtarget);
    method_exchangeImplementations(origin, swizz);
}

- (void)swizz_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)events{
    [self swizz_addTarget:target action:action forControlEvents:events];
    
    Class targetCls = [target class];
    NSString *originName = NSStringFromSelector(action);
    if ([originName rangeOfString:@"swizz_"].location != NSNotFound){
        return;
    }
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"swizz_%@",originName]);
//    IMP buttonAction = imp_implementationWithBlock(^(id self,SEL _cmd,id sender){
//        ((void(*)(id,SEL,id))objc_msgSend)(self,selector,sender);
//    });  // acording the definition of imp_implementationWithBlock the selector is not available;
    if (class_addMethod(targetCls, selector, (IMP)buttonAction, "v@:")){
        Method orignMethod = class_getInstanceMethod(targetCls, action);
        Method swizzMethod = class_getInstanceMethod(targetCls, selector);
        method_exchangeImplementations(orignMethod, swizzMethod);
    }
    
}

void buttonAction(id self,SEL _cmd,id sender){
    if (logButton)
        NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"swizz_%@",NSStringFromSelector(_cmd)]);
    ((void(*)(id,SEL,id))objc_msgSend)(self,selector,sender);
}
@end
