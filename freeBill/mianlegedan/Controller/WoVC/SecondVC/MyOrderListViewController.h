//
//  MyOrderListViewController.h
//  freeBill
//
//  Created by 张梦川 on 16/12/5.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderListViewController : UIViewController
-(void)loadData:(NSString *)status;
@property (nonatomic,copy) NSString* payStatus;
@end
