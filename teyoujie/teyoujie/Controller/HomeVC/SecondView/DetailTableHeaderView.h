//
//  detailTableHeaderView.h
//  freeBill
//
//  Created by 张梦川 on 16/12/7.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableHeaderView : UIView
    @property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *detailImgView;
@property (weak, nonatomic) IBOutlet UILabel *detailName;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *menshiPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *saleNumLabel;

@end
