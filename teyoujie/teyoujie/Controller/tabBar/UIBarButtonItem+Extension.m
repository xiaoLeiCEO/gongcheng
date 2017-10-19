//
//  UIBarButtonItem+Extension.m
//
//
//  Created by apple on 06/08/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+MJExtension.h"
@implementation UIBarButtonItem (Extension)


+ (instancetype)barButtonItemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName  target:(id)target sel:(SEL)sel;
{
    // 2.1创建按钮
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    // 设置size
    btn.mj_size = btn.currentImage.size;
    // 添加按钮监听事件
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    // 2.2. 将UIButton包装成UIBarButtonItem
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    // 2.3返回item
    return item;

}
@end
