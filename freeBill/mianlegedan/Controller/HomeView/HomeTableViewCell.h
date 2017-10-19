//
//  HomeTableViewCell.h
//  mianlegedan
//
//  Created by 王长磊 on 2017/5/18.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;

@end
