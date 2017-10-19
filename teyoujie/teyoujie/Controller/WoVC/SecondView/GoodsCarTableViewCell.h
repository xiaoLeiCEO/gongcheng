//
//  GoodsCarTableViewCell.h
//  freeBill
//
//  Created by 张梦川 on 16/12/15.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLb;
@property (weak, nonatomic) IBOutlet UIImageView *goodsThumbImg;

@property (weak, nonatomic) IBOutlet UILabel *goodsPropertyLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLb;

@end
