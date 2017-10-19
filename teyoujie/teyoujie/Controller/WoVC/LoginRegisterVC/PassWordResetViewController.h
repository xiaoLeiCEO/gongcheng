//
//  PassWordResetViewController.h
//  playboy
//
//  Created by 张梦川 on 16/1/26.
//  Copyright © 2016年 yaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface PassWordResetViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *oldpwd;
@property (weak, nonatomic) IBOutlet UITextField *newpwd;

@property (weak, nonatomic) IBOutlet UITextField *aginNewpwd;

@end
