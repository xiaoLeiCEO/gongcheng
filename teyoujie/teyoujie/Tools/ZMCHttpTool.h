//
//  ZMCHttpTool.h
//  ZMCWB
//
//  Created by 张梦川 on 14-8-23.
//  Copyright (c) 2014年 ZMC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"
typedef void (^successBlock)(id responseObject);
typedef void (^failureBlock)(NSError *error);
typedef void (^constructingBodyWithBlock)(id <AFMultipartFormData> formData);
@interface ZMCHttpTool : NSObject


/**
 url : 请求的地址
 parameters: 请求参数
 success: 请求成功的回调
 failure: 请求失败的回调
 */
+ (void)postWithUrl:(NSString *)url  parameters:(NSDictionary *)parameters  success:(successBlock)success  failure:(failureBlock)failure;
/**
 url : 请求的地址
 parameters: 请求参数
 success: 请求成功的回调
 failure: 请求失败的回调
 */
+ (void)getWithUrl:(NSString *)url  parameters:(NSDictionary *)parameters  success:(successBlock)success  failure:(failureBlock)failure;


+ (void)postWithUrl:(NSString *)url  parameters:(NSDictionary *)parameters  constructingBodyWithBlock:(constructingBodyWithBlock)block success:(successBlock)success  failure:(failureBlock)failure;
+ (void)postForJavaWithUrl:(NSString *)url  parameters:(NSDictionary *)parameters  success:(successBlock)success  failure:(failureBlock)failure;
@end
