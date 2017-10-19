//
//  wo_headView.h
//  freeBill
//
//  Created by 张梦川 on 16/12/3.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wo_headView : UIView
    @property (weak, nonatomic) IBOutlet UIImageView *headImage;

    @property (weak, nonatomic) IBOutlet UILabel *userName;
    @property (weak, nonatomic) IBOutlet UIButton *settingBtn;
    @property (weak, nonatomic) IBOutlet UIButton *freequanBtn;
    @property (weak, nonatomic) IBOutlet UIButton *collectBtn;
    @property (weak, nonatomic) IBOutlet UIButton *changeHeadImg;
@property (weak, nonatomic) IBOutlet UIButton *myInfoBtn;
@end
