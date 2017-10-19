//
//  AdScrollView.m
//  图片幻灯循环滚动效果
#import "AdScrollView.h"
#import "ViewUtil.h"

#define UISCREENWIDTH  self.bounds.size.width//广告的宽度
#define UISCREENHEIGHT  self.bounds.size.height//广告的高度

#define HIGHT self.bounds.origin.y //由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标
#define LOADING @"LOADING"

static CGFloat const chageImageTime = 3.0;

@interface AdScrollView ()

{
    //循环滚动的三个视图
    UIImageView * _leftImageView;
    UIImageView * _centerImageView;
    UIImageView * _rightImageView;
    //循环滚动的周期时间
    NSTimer * _moveTime;
    //用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
    BOOL _isTimeUp;
}

@property (retain,nonatomic,readonly) UIImageView * leftImageView;
@property (retain,nonatomic,readonly) UIImageView * centerImageView;
@property (retain,nonatomic,readonly) UIImageView * rightImageView;

@end

@implementation AdScrollView {
    NSInteger _currentPage;//记录中间图片的下标
    NSTimeInterval _touchTimer;
    __weak id _clickTarget;
    SEL _clickSelector;
    
    BOOL _started; // 释放已经启动
}

// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        //self.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
        self.contentSize = CGSizeMake(UISCREENWIDTH * 3, UISCREENHEIGHT);
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = YES;
        self.delegate = self;
        
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        _leftImageView.image = [UIImage imageNamed:@"loading_xiaocaiwa"];
        [self addSubview:_leftImageView];
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        _centerImageView.image = [UIImage imageNamed:@"loading_xiaocaiwa"];
        [self addSubview:_centerImageView];
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH*2, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        _rightImageView.image = [UIImage imageNamed:@"loading_xiaocaiwa"];
        [self addSubview:_rightImageView];
        
        _isTimeUp = NO;
        
        _currentPage = 0;
        
    }
    return self;
}

// 开始自动滚动
- (void)startAutoScroll {
    if (_started) {
        return;
    }
    
    _started = YES;
    
    _moveTime = [NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
}

// 停止自动滚动
- (void)stopAutoScroll {
    _started = NO;
    [_moveTime invalidate];
}

- (NSInteger)currentPage {
    return [self getCurrentPage];
}

//thouchesBegan 获取到touch的时间点
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _touchTimer = [touch timestamp];
}


//touchesEnded，touch事件完成，根据此时时间点获取到touch事件的总时间，
- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _touchTimer = [touch timestamp] - _touchTimer;
    
    NSUInteger tapCount = [touch tapCount];
    //CGPoint touchPoint = [touch locationInView:self];
    
    //判断单击事件，touch时间和touch的区域
    if (tapCount == 1 && _touchTimer <= 3)
    {
        //进行单击的跳转等事件
        [_clickTarget performSelector:_clickSelector withObject:nil afterDelay:0];
    }
    
}


// 点击处理
- (void)setSliderClickTarget:(id)target selector:(SEL)selector {
    _clickTarget = target;
    _clickSelector = selector;
}

// 设置幻灯所使用的图片URL
- (void)setImageNameArray:(NSArray *)imageNameArray
{
    if (!imageNameArray || [imageNameArray count] == 0) {
        imageNameArray = [NSMutableArray arrayWithObjects:LOADING, nil];
    }
    
    NSUInteger imageNum = [imageNameArray count];
    if (imageNum < 3) {
        NSMutableArray *newImageArray = [NSMutableArray arrayWithArray:imageNameArray];
        NSString *tplUrl = imageNameArray[imageNum - 1];
        for (NSUInteger i = imageNum; i < 3; i ++) {
            newImageArray[i] = tplUrl;
        }
        
        imageNameArray = newImageArray;
    }
        
    _imageNameArray = imageNameArray;
    _currentPage = 0;

    // 图片赋值
    [self getImageAtPage:[self getPrevPage] imageViewForShow:_leftImageView];
    [self getImageAtPage:[self getCurrentPage] imageViewForShow:_centerImageView];
    [self getImageAtPage:[self getNextPage] imageViewForShow:_rightImageView];
    
}

- (void)getImageAtPage:(NSInteger)pageIndex imageViewForShow:(UIImageView *)imageView {
    if (pageIndex < 0) {
        pageIndex = [_imageNameArray count] - 1;
    }
    
    NSInteger index = (pageIndex)%([_imageNameArray count]);
    
    [self loadImageFromUrl:_imageNameArray[index] imageViewForShow:imageView];
}

- (UIImage *)imageAtPage:(NSInteger)pageIndex {
    if (pageIndex < 0) {
        pageIndex = [_imageNameArray count] - 1;
    }
    
    NSInteger index = (pageIndex)%([_imageNameArray count]);
//    return [ViewUtil loadImageSync:_imageNameArray[index]];
    return nil;
}

// 前一张
- (NSInteger)getPrevPage {
    NSInteger imageIndex = _currentPage - 1;
    if (imageIndex < 0) {
        imageIndex = [_imageNameArray count] - 1;
    }
    
    return (imageIndex)%([_imageNameArray count]);
}

// 后一张
- (NSInteger)getNextPage {
    NSInteger imageIndex = _currentPage + 1;
    if (imageIndex < 0) {
        imageIndex = [_imageNameArray count] - 1;
    }
    
    return (imageIndex)%([_imageNameArray count]);
}

// 当前页
- (NSInteger)getCurrentPage {
    NSInteger imageIndex = _currentPage;
    if (imageIndex < 0) {
        imageIndex = [_imageNameArray count] - 1;
    }
    
    return (imageIndex)%([_imageNameArray count]);
}

// 加载图片
- (void)loadImageFromUrl:(NSString *)imageUrl imageViewForShow:(UIImageView *)imageView {
    
    if ([imageUrl isEqualToString:@""]) {
        UIImage *image = [UIImage imageNamed:@"placeImg"];
        imageView.image = image;
    } else {
//        [ViewUtil loadImage:imageUrl onFinished:^(UIImage *image) {
//            imageView.image = image;
//        }];
    }
    
}

// 创建pageControl,指定其显示样式
- (void)setPageControlShowStyle:(UIPageControlShowStyle)controlShowStyle
{
    if (controlShowStyle == UIPageControlShowStyleNone) {
        return;
    }
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _imageNameArray.count;
    
    if (controlShowStyle == UIPageControlShowStyleLeft) {
        _pageControl.frame = CGRectMake(10, HIGHT+UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
    }
    else if (controlShowStyle == UIPageControlShowStyleCenter) {
        _pageControl.frame = CGRectMake(0, 0, 20*_pageControl.numberOfPages, 20);
        _pageControl.center = CGPointMake(UISCREENWIDTH/2.0, HIGHT+UISCREENHEIGHT - 10);
    }
    else if (controlShowStyle == UIPageControlShowStyleTopCenter) {
        _pageControl.frame = CGRectMake(0, 0, 20*_pageControl.numberOfPages, 20);
        _pageControl.center = CGPointMake(UISCREENWIDTH/2.0, 40);
    }
    else {
        _pageControl.frame = CGRectMake( UISCREENWIDTH - 20*_pageControl.numberOfPages, HIGHT+UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
    }
    _pageControl.currentPage = 0;
    
    _pageControl.enabled = NO;
    
    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
    
}

//由于PageControl这个空间必须要添加在滚动视图的父视图上(添加在滚动视图上的话会随着图片滚动,而达不到效果)
- (void)addPageControl
{
    if(_pageControlSuperView) {
        [_pageControlSuperView addSubview:_pageControl];
    } else {
        [[self superview] addSubview:_pageControl];
    }
}

// 计时器到时,系统滚动图片
- (void)animalMoveImage
{
    if (!_started) {
        return;
    }
    
    [self setContentOffset:CGPointMake(UISCREENWIDTH * 2, 0) animated:YES];
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

// 图片停止时,调用该函数使得滚动视图复用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.contentOffset.x == 0)
    {
        _currentPage --;
        _pageControl.currentPage = [self getCurrentPage];
    }
    else if(self.contentOffset.x == UISCREENWIDTH * 2)
    {
        _currentPage ++;
        _pageControl.currentPage = [self getCurrentPage];
    }
    else
    {
        return;
    }
    
    // 图片赋值
    [self getImageAtPage:[self getPrevPage] imageViewForShow:_leftImageView];
    [self getImageAtPage:[self getCurrentPage] imageViewForShow:_centerImageView];
    [self getImageAtPage:[self getNextPage] imageViewForShow:_rightImageView];
    
    self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
    
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimeUp) {
        [_moveTime setFireDate:[NSDate dateWithTimeIntervalSinceNow:chageImageTime]];
    }
    _isTimeUp = NO;
}

@end
