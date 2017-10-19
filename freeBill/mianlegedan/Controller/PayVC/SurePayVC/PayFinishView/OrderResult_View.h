//
//  OrderResult_View.h
//  freeBill
//
//  Created by 张梦川 on 16/12/12.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderResult_View : UIView

@property (weak, nonatomic) IBOutlet UIButton *finish_Btn;

@property (weak, nonatomic) IBOutlet UIButton *orderDetailBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodsThumbImg;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLb;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumLb;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImg;

@end
