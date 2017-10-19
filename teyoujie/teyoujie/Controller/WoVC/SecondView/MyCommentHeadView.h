//
//  MyCommentHeadView.h
//  freeBill
//
//  Created by 张梦川 on 16/12/6.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentHeadView : UIView
    @property (weak, nonatomic) IBOutlet UIImageView *userImageView;
    
    @property (weak, nonatomic) IBOutlet UILabel *userName;
    @property (weak, nonatomic) IBOutlet UIButton *meituanBtn;
    @property (weak, nonatomic) IBOutlet UIButton *waimaiBtn;
    @property (weak, nonatomic) IBOutlet UIButton *movieComment;
    @property (weak, nonatomic) IBOutlet UIView *lineView;
    
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end
