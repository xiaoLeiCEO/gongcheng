//
//  woTableViewCell.h
//  freeBill
//
//  Created by 张梦川 on 16/12/3.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface woTableViewCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UIImageView *cell_Image;
    @property (weak, nonatomic) IBOutlet UILabel *cell_title;
    @property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
