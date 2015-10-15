//
//  FileRequest.h
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/15.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FileRequest : NSObject

+(NSString *)imageURL:(NSString *)name;

+(void)UploadImage:(UIImage *)image success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
@end
