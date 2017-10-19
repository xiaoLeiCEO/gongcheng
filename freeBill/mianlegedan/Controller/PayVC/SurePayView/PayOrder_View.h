//
//  PayOrder_View.h
//  freeBill
//
//  Created by 张梦川 on 16/12/11.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayOrder_View : UIView

@property (weak, nonatomic) IBOutlet UIButton *weixinPayBtn;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhiFuBaoPayBtn;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@end
