//
//  CartSubmitGoodsTableViewCell.h
//  mianlegedan
//
//  Created by 王长磊 on 2017/5/18.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartSubmitGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsThumbImg;

@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLb;

@end
