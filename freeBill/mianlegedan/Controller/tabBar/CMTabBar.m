//
//  CMTabBar.m
//  cloudsmall
//
//  Created by 张梦川 on 15/7/1.
//  Copyright (c) 2015年 simpleway. All rights reserved.
//

#import "CMTabBar.h"
#import "UIView+MJExtension.h"
#import "CMTabBarButton.h"
#import "ViewUtil.h"
#import "UserBean.h"
@interface CMTabBar()

/**
 *  保存所有选项卡按钮
 */
@property (nonatomic, strong) NSMutableArray  *buttons;
/**
 *  当前选中的按钮
 */
@property (nonatomic, weak) UIButton  *selectedButton;
@end
@implementation CMTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        // 1.设置自定义tabBar的背景图片
        [self setupBg];
        
    }
    return self;
}
/**
 *  设置自定义tabBar的背景图片
 */
- (void)setupBg
{
    self.backgroundColor = [UIColor whiteColor];
}


#pragma mark - 设置子控件frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    // 1.设置选项卡按钮的frame
    [self setupOtherBtnFrame];
}
/**
 *  设置选项卡按钮的frame
 */
- (void)setupOtherBtnFrame
{
    
    // 遍历数组设置选项卡frame
    // 计算宽度, 获取高度, 获取按钮的个数只需要执行一次即可
    NSInteger count = self.buttons.count;
    CGFloat btnWidth  = self.mj_w / count;
    CGFloat btnHeigth = self.mj_h;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.buttons[i];
        btn.mj_w = btnWidth;
        btn.mj_h = btnHeigth;
        btn.mj_y = 0;
        btn.mj_x = i * btn.mj_w;
        
    }
}

#pragma mark - 添加按钮方法
- (void)addTabBarButton:(UITabBarItem *)item
{
    // 1.创建按钮
    CMTabBarButton *btn = [[CMTabBarButton alloc] init];
    
    // 2.从UITabBarItem取出标题, 设置标题
    btn.item = item;
    
    [self addSubview:btn];
    
    // 设置按钮的tag
    btn.tag = self.buttons.count;
    
    // 3.每次添加完按钮后将按钮存储到数组中
    [self.buttons addObject:btn];
    
    // 4.监听按钮点击事件
    [btn addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchDown];
    
    // 5.设置默认选中的按钮
    if (self.buttons.count == 1) {
        // 选中某一个按钮就相当于点击某一个按钮
        [self buttonOnClick:btn];
    }
}



- (void)buttonOnClick:(UIButton *)btn
{
    if(![UserBean isSignIn] && btn.tag == 2){
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];

//         dict[@"isLogin"] = @"isLogin";
        NSNotification *notification =[NSNotification notificationWithName:@"notLogin" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];

        return;
    }
    
    // 0. 通知代理按钮被点击了
    if ([self.delegate respondsToSelector:@selector(tabBar:selectedButtonfrom:to:)]) {
        [self.delegate tabBar:self selectedButtonfrom:self.selectedButton.tag to:btn.tag];
    }
    
    // 1.取消上一次选中的按钮
    self.selectedButton.selected = NO;
    // 2.选中当前按钮
    btn.selected = YES;
    // 3.记录当前选中的按钮
    self.selectedButton = btn;
}

#pragma mark - 懒加载
- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end
