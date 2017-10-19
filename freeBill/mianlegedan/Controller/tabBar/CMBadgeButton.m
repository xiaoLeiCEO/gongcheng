//
//  CMBadgeButton.m
//  cloudsmall
//
//  Created by 张梦川 on 15/7/1.
//  Copyright (c) 2015年 simpleway. All rights reserved.
//

#import "CMBadgeButton.h"

@implementation CMBadgeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.userInteractionEnabled = NO;
        self.adjustsImageWhenDisabled = NO;
        self.mj_size = self.currentBackgroundImage.size;
    }
    return self;
}


- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    
    // 1.设置提醒数字
    int newCount = [self.badgeValue intValue];
    if (newCount > 0) {
        // 需要显示提示按钮
        self.hidden = NO;
        
        if (newCount < 100) {
            NSString * newCountStr = [NSString stringWithFormat:@"%d", newCount];
            [self setTitle:newCountStr forState:UIControlStateNormal];
        }else
        {
            [self setTitle:@"N" forState:UIControlStateNormal];
        }
    }else
    {
        self.hidden = YES;
    }
}
@end
