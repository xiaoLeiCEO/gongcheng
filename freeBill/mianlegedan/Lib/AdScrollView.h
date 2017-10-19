//
//  AdScrollView.h
//  图片幻灯循环滚动效果
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,//default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
    UIPageControlShowStyleTopCenter
};

typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};

@interface AdScrollView : UIScrollView<UIScrollViewDelegate>

@property (retain,nonatomic,readonly) UIPageControl * pageControl;
@property (retain,nonatomic,readwrite) NSArray * imageNameArray;
@property (assign,nonatomic,readwrite) UIPageControlShowStyle  pageControlShowStyle;
@property (assign,nonatomic,readwrite) UIView *pageControlSuperView; // 控制条父视图, 需要在 pageControlShowStyle 之前设置

// 当前页
- (NSInteger)currentPage;

// 点击处理
- (void)setSliderClickTarget:(id)target selector:(SEL)selector;

- (UIImage *)imageAtPage:(NSInteger)pageIndex;

// 开始自动滚动
- (void)startAutoScroll;

// 停止自动滚动
- (void)stopAutoScroll;

@end
