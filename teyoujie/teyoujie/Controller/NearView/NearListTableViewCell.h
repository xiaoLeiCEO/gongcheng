//
//  NearListTableViewCell.h
//  freeBill
//
//  Created by 张梦川 on 16/12/4.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fuwuImgView;
@property (weak, nonatomic) IBOutlet UILabel *fuwuName;
@property (weak, nonatomic) IBOutlet UILabel *fuwu_PingFen;
@property (weak, nonatomic) IBOutlet UIImageView *star_an_ImgView;

@property (weak, nonatomic) IBOutlet UILabel *fuwuContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLbael;
@end
