//
//  NSString+scisky.h
//  scisky
//
//  Created by 刘向宏 on 15/6/18.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (scisky)
-(NSString *)AESEncrypt;
- (BOOL)checkTel;
+ (BOOL)validateIDCardNumber:(NSString *)value;
- (BOOL)isValidateEmail;
@end