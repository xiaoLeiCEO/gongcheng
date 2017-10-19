//
//  ReceiveAddressListViewController.h
//  teYouJie
//
//  Created by 王长磊 on 2017/5/6.
//  Copyright © 2017年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiveAddressListViewController : UIViewController


//收件人
@property (weak, nonatomic) IBOutlet UITextField *consigneeTf;

//手机号码
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTf;

//收货地址
@property (weak, nonatomic) IBOutlet UITextField *addressTf;

//详细地址
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTf;

@property (nonatomic,copy) NSString *consignee;
@property (nonatomic,copy) NSString *phoneNum;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *detailAddress;
@property (nonatomic,copy) NSString *addressId;


@end

