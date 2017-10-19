//
//  RegisterViewController.h
//  playboy
//
//  Created by 张梦川 on 16/1/7.
//  Copyright © 2016年 yaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol registerDelegate <NSObject>

-(void)alertMsg:(NSString *)message;

@end


@interface RegisterViewController : BaseViewController
@property id<registerDelegate>regDelegate;
@end
