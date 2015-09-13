//
//  BaseHTTPRequestOperationManager.m
//  DoctorFei_iOS
//
//  Created by GuJunjia on 14/11/30.
//
//

#import "BaseHTTPRequestOperationManager.h"
#import <JSONKit.h>
#import "NSString+scisky.h"

#define kErrorEmpty @"服务器返回错误"
#define kErrorConnect @"无法连接到服务器"
#define baseURL @"http://121.42.10.232/utalifeServer"
#define resourceSeeURL @"http://121.42.10.232/utalifeResource/"
#define resourceURL @"http://121.42.10.232/utalifeResource/image?image="
#define uploadResourceURL @" http://121.42.10.232/utalifeResource/image"

@implementation BaseHTTPRequestOperationManager
+ (BaseHTTPRequestOperationManager *)sharedManager
{
    static BaseHTTPRequestOperationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self manager]initWithBaseURL:nil];
        _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
        //_sharedManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_sharedManager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
        _sharedManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_sharedManager.responseSerializer setStringEncoding:NSUTF8StringEncoding];
        [_sharedManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/html",nil]];
    });
    return _sharedManager;
}

- (void)defaultHTTPWithMethod:(NSString *)method WithParameters:(id)parameters  post:(BOOL)bo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,method];
    NSDictionary *dicDES = nil;
    if (parameters) {
        NSLog(@"%@",parameters);
        NSString *jasonString = [parameters JSONString];
        dicDES = @{
                   @"param" : [jasonString AESEncrypt]
                   };
    }
    if (bo) {
        [self defaultPostWithUrl:urlString WithParameters:dicDES success:success failure:failure];
    }
    else
    {
        [[BaseHTTPRequestOperationManager sharedManager]GET:urlString parameters:dicDES success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject) {
                success(operation, responseObject);
            }
            else{
                NSError *error = [NSError errorWithDomain:kErrorEmpty code:0 userInfo:nil];
                failure(operation, error);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
        }];
    }
    
}

- (void)defaultPostWithUrl:(NSString *)urlString WithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSLog(@"%@",parameters);
    [[BaseHTTPRequestOperationManager sharedManager]POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            id object = [responseObject objectFromJSONData];
            if (object) {
                success(operation, object);
            }
            else
            {
                NSError *error = [NSError errorWithDomain:kErrorEmpty code:0 userInfo:nil];
                failure(operation, error);
            }
            
        }
        else{
            NSError *error = [NSError errorWithDomain:kErrorEmpty code:0 userInfo:nil];
            failure(operation, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
        NSError *error2 = [NSError errorWithDomain:kErrorConnect code:0 userInfo:nil];
        failure(operation, error2);
    }];
}


- (void)filePostWithUrl:(NSString *)urlString WithParameters:(NSData *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[BaseHTTPRequestOperationManager sharedManager]POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:parameters name:@"File" fileName:@"addImage" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            id object = [responseObject objectFromJSONData];
            if (object) {
                success(operation, object);
            }
            else
            {
                NSError *error = [NSError errorWithDomain:kErrorEmpty code:0 userInfo:nil];
                failure(operation, error);
            }
            
        }
        else{
            NSError *error = [NSError errorWithDomain:kErrorEmpty code:0 userInfo:nil];
            failure(operation, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
        NSError *error2 = [NSError errorWithDomain:kErrorConnect code:0 userInfo:nil];
        failure(operation, error2);
    }];
}
@end
