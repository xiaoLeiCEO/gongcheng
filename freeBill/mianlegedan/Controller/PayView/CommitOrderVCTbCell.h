//
//  CommitOrderVCTbCell.h
//  mianlegedan
//
//  Created by 王长磊 on 2017/5/22.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitOrderVCTbCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsThumbImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;
@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLb;

@end
