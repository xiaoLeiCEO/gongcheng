//
//  CMTabBarButton.m
//  cloudsmall
//
//  Created by 张梦川 on 15/7/1.
//  Copyright (c) 2015年 simpleway. All rights reserved.
//

#import "CMTabBarButton.h"
#import "CMBadgeButton.h"
#import "ViewUtil.h"
#define CMTabBarButtonRatio 0.6
@interface CMTabBarButton()

/**
 * 提醒按钮
 */

@property(nonatomic, weak)CMBadgeButton *badgeBtn;
@end
@implementation CMTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.设置按钮的属性
        // 设置按钮图片居中显示
        self.imageView.contentMode = UIViewContentModeCenter;
        // 设置按钮标题居中显示
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置按钮的字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        // 设置标题颜色
        [self setTitleColor: [ViewUtil hexColor:@"#ed6d4d"] forState:UIControlStateNormal];
        // 设置按钮选中状态的文字颜色
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        // 2.添加提醒按钮
        CMBadgeButton *badgeBtn = [[CMBadgeButton alloc] init];
        [self addSubview:badgeBtn];
        self.badgeBtn = badgeBtn;
        badgeBtn.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.badgeBtn.mj_size = self.badgeBtn.currentBackgroundImage.size;
    self.badgeBtn.mj_x = self.mj_w - self.badgeBtn.mj_w - 5;
    self.badgeBtn.mj_y = 0;
}


// 控制器图片的位置
// contentRect 就是当前按钮的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 3;
    CGFloat imageW = self.mj_w;
    CGFloat imageH = self.mj_h * CMTabBarButtonRatio;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
// 控制器标题的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = self.mj_h * CMTabBarButtonRatio;
    CGFloat titleW = self.mj_w;
    CGFloat titleH = self.mj_h - titleY;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setHighlighted:(BOOL)highlighted
{
}

/**
 * 接收外界传入的UITabBarItem
 */
- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    // 设置按钮显示的内容
    [self setTitle:item.title forState:UIControlStateNormal];
    // 设置默认状态的图片
    [self setImage:item.image forState:UIControlStateNormal];
    // 设置选中状态的图片
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    
    // 注册监听, 监听badgeValue的改变
    [_item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:@"xxoo"];
    
    // 监听_item的标题属性的改变
    [_item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [_item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [_item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}

/**
 * 当监听到对象的属性改变之后就会自动调用
 * keyPath: 被监听的属性
 * object: 被监听的对象
 * change: 修改之后的一些数据(可能时新值, 也可能时旧值, 也可能新旧都有)
 * context 当初注册监听的时候传递的参数
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    // 1.设置提醒数字
    self.badgeBtn.badgeValue = self.item.badgeValue;
    
    // 2.设置标题
    [self setTitle:self.item.title forState:UIControlStateNormal];
    
    // 3.设置图片
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
}


@end
