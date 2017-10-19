//
//  MyCommentCellView.h
//  freeBill
//
//  Created by 张梦川 on 16/12/6.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentCellView : UIView
    @property (weak, nonatomic) IBOutlet UIImageView *userImageView;
    @property (weak, nonatomic) IBOutlet UILabel *userName;
    @property (weak, nonatomic) IBOutlet UIImageView *commentStarImageView;
    @property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
