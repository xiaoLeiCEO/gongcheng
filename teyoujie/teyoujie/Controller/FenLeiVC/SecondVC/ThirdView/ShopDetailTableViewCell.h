//
//  ShopDetailTableViewCell.h
//  freeBill
//
//  Created by 张梦川 on 16/12/18.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopName;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *expMoney;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end
