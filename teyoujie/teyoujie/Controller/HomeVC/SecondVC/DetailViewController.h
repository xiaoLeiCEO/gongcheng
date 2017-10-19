//
//  DetailViewController.h
//  freeBill
//
//  Created by 张梦川 on 16/12/7.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface DetailViewController : BaseViewController
@property(nonatomic, copy)NSString *fuwuId;
@property(nonatomic,copy)NSString *goodsId;
@property(nonatomic,copy)NSString *location;
@property(nonatomic,copy)NSString *goodsThumb;

@end
