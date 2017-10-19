//
//  HomeDetailTableViewCell.h
//  freeBill
//
//  Created by 张梦川 on 16/12/14.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *caleNum;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopImgView;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
