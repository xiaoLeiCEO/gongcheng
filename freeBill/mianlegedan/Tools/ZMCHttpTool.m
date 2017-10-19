//
//  ZMCHttpTool.m
//  ZMCWB
//
//  Created by 张梦川 on 14-8-23.
//  Copyright (c) 2014年 ZMC. All rights reserved.
//

#import "ZMCHttpTool.h"
@implementation ZMCHttpTool

/**
 url : 请求的地址
 parameters: 请求参数
 success: 请求成功的回调
 failure: 请求失败的回调
 */
+ (void)postWithUrl:(NSString *)url  parameters:(NSDictionary *)parameters  success:(successBlock)success  failure:(failureBlock)failure{
    
    // 1.创建网络请求管理者
    AFHTTPSessionManager *manager= [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // JSON解析
        NSError *jsonError;
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* strdata = [[NSString alloc]initWithData:responseObject encoding:enc];//在将NSString类型转为NSData
         NSData * data = [strdata dataUsingEncoding:NSUTF8StringEncoding];//这样解决的乱码问题。
        
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError ];
        
        if (success) {
            success(json);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
        }
    }];
}
    
+ (void)postForJavaWithUrl:(NSString *)url  parameters:(NSDictionary *)parameters  success:(successBlock)success  failure:(failureBlock)failure{
    
    // 1.创建网络请求管理者
    AFHTTPSessionManager *manager= [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // JSON解析
        NSError *jsonError;
      
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&jsonError ];
        
        if (success) {
            success(json);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
        }
    }];
}
/**
 url : 请求的地址
 parameters: 请求参数
 success: 请求成功的回调
 failure: 请求失败的回调
 */
+ (void)getWithUrl:(NSString *)url  parameters:(NSDictionary *)parameters  success:(successBlock)success  failure:(failureBlock)failure{
    
    // 1.创建网络请求管理者
    AFHTTPSessionManager *manager= [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.发送网络请求请求数据
    
    
   [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
       
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // JSON解析
       NSError *jsonError;
       NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
       NSString* strdata = [[NSString alloc]initWithData:responseObject encoding:enc];//在将NSString类型转为NSData
       NSData * data = [strdata dataUsingEncoding:NSUTF8StringEncoding];//这样解决的乱码问题。
       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError ];
       if (success) {
           success(json);
       }

   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       if (failure) {
           failure(error);
       }
   }];
}
+ (void)postWithUrl:(NSString *)url  parameters:(NSDictionary *)parameters  constructingBodyWithBlock:(constructingBodyWithBlock)block success:(successBlock)success  failure:(failureBlock)failure{
    
    // 1.创建网络请求管理者
    AFHTTPSessionManager *manager= [AFHTTPSessionManager manager];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /*
         Data: 需要上传的二进制数据
         name: 参数名称
         fileName: 文件名称(时给服务器用的, 可以瞎写)
         mimeType: 每种类型的文件都有自己对应的mime类型
         */
        // 取出用户选择的图片
        if (block) {
            block(formData);
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *jsonError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError];        
        if (success) {
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
