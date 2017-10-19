//
//  UploadImg.h
//  cloudsmall
//
//  Created by 张梦川 on 15/7/30.
//  Copyright (c) 2015年 simpleway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonUrl.h"
@interface UploadImg : NSObject
// 图片上传方法
+ (NSDictionary *)uploadImageWithUrl:(NSString *)url image:(UIImage *)image errorCode:(NSString **)errorCode errorMsg:(NSString **)errorMsg;
+(void)uploadImage:(UIImage *)img withUrl:(NSString *)imageUrl;
@end
