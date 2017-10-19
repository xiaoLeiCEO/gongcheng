//
//  UploadImg.m
//  cloudsmall
//
//  Created by 张梦川 on 15/7/30.
//  Copyright (c) 2015年 simpleway. All rights reserved.
//

#import "UploadImg.h"
#import "AFNetworking.h"
#import "UserBean.h"
@implementation UploadImg


// 上传图片
// 图片上传方法
+ (NSDictionary *)uploadImageWithUrl:(NSString *)url image:(UIImage *)image errorCode:(NSString **)errorCode errorMsg:(NSString **)errorMsg {
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    //得到图片的data
    NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    

    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@\"\r\n",fileName];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    // 发送数据
    NSURLResponse *response;
    NSError *error;

    NSData *rspData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//     NSData *rspData = [NSURLSession ]
    if (rspData == nil || error) {
        *errorCode = @"HttpError";
        *errorMsg = @"网络数据异常";
        
        return nil;
    }
    
    // JSON解析
    NSError *jsonError;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:rspData options:NSJSONReadingMutableContainers error:&jsonError];
    if (result == nil || jsonError) {
        *errorCode = @"JsonError";
        *errorMsg = jsonError ? [NSString stringWithFormat:@"%@", [jsonError domain]] : @"JsonError";
        
        return nil;
    }
    
    return result;
}

+(void)uploadImage:(UIImage *)img withUrl:(NSString *)imageUrl{
    NSLog(@"图片选中");
    //截取图片
    NSData *imageData = UIImageJPEGRepresentation(img, 0.001);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    NSDictionary *dict = [UserBean getUserDictionary];
    
    // 访问路径
    NSString *stringURL = [NSString stringWithFormat:@"%@",FBUploadImgUrl];
    //NSString *stringURL = [NSString stringWithFormat:@"%@",imageUrl];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"token"] = dict[@"token"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:stringURL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传文件
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData name:@"photo" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        [self showHUDmessage:@"上传中"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // JSON解析
        NSError *jsonError;
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* strdata = [[NSString alloc]initWithData:responseObject encoding:enc];//在将NSString类型转为NSData
        NSData * data = [strdata dataUsingEncoding:NSUTF8StringEncoding];//这样解决的乱码问题。
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError ];

        NSString *result = json[@"status"];
        if ([result isEqualToString:@"0"]== true ) {
            //            [self showHUDmessage:@"上传失败"];
            NSLog(@"上传失败");
        } else {
            //            [self showHUDmessage:@"上传成功"];
            NSLog(@"上传成功");
            //创建通知
           
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"stats"] = result;
        NSNotification *notification =[NSNotification notificationWithName:@"uploadImg" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传错误");
    }];
    

}
    

@end
