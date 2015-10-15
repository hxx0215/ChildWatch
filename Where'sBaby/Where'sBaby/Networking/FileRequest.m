//
//  FileRequest.m
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/15.
//  Copyright © 2015年 coolLH. All rights reserved.
//

#import "FileRequest.h"
#import "BaseHTTPRequestOperationManager.h"
#define uploadResourceURL @"http://121.42.10.232/utalifeResource/image"
#define imageSeeURL @"http://121.42.10.232/utalifeResource/images/"

@implementation FileRequest

+(NSString *)imageURL:(NSString *)name
{
    return [NSString stringWithFormat:@"%@%@",imageSeeURL,name];
}

+(void)UploadImage:(UIImage *)image success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [[BaseHTTPRequestOperationManager sharedManager] filePostWithUrl:uploadResourceURL WithParameters:UIImageJPEGRepresentation(image, 0.8) success:success failure:failure];
}
@end
