//
//  SecondDetailCell.h
//  freeBill
//
//  Created by 张梦川 on 16/12/10.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pingfenLabel;
@property (weak, nonatomic) IBOutlet UIImageView *star_ImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *comentNumLabel;

@end
