//
//  MyAddrTableViewCell.h
//  freeBill
//
//  Created by 张梦川 on 16/12/15.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAddrTableViewCell : UITableViewCell
//收件人
@property (weak, nonatomic) IBOutlet UILabel *consigneeLb;
//电话
@property (weak, nonatomic) IBOutlet UILabel *telLb;
//收货地址
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIButton *defaultAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *editAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *delAddressBtn;

@end
