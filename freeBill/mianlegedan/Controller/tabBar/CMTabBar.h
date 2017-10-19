//
//  CMTabBar.h
//  cloudsmall
//
//  Created by 张梦川 on 15/7/1.
//  Copyright (c) 2015年 simpleway. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMTabBar;

@protocol CMTabBarDelegate <NSObject>

//- (void)tabBar:(IWTabBar *)tabBar selectedButtonTag:(NSInteger)tag;
/**
 *  当自定义tabBar的按钮被点击之后的监听方法
 *
 *  @param tabBar 触发事件的控件
 *  @param from   上一次选中的按钮的tag
 *  @param to     当前选中按钮的tag
 */
- (void)tabBar:(CMTabBar *)tabBar selectedButtonfrom:(NSInteger)from to:(NSInteger)to;
@end
@interface CMTabBar : UIView
/**
 *  根据模型创建对应控制器的对应按钮
 *
 *  @param item 数据模型(图片/选中图片/标题)
 */
- (void)addTabBarButton:(UITabBarItem *)item;

@property (nonatomic, weak) id<CMTabBarDelegate>  delegate;

@end
