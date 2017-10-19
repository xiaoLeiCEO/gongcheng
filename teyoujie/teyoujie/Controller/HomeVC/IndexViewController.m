//
//  ViewController.m
//  playboy
//
//  Created by 张梦川 on 15/11/4.
//  Copyright © 2015年 yaoyu. All rights reserved.
//

#import "IndexViewController.h"
#import "HomeViewController.h"
#import "WoViewController.h"
#import "NearViewController.h"
#import "CMTabBar.h"
#import "PBNavigationViewController.h"
#import "CategoryViewController.h"
@interface IndexViewController ()<CMTabBarDelegate>

/**
 *  自定义tabBar
 */
@property (nonatomic, weak) CMTabBar *customTabBar;

@property(nonatomic, weak) HomeViewController *homeVC;
@property(nonatomic, weak) WoViewController *woVC;
@property(nonatomic, weak) NearViewController *nearVC;
@property(nonatomic, weak) CategoryViewController *cateVC;
@end

@implementation IndexViewController


// 其实在调用init方法的时候, 系统内部会默认调用initWithNibName
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // 添加子控制器
        // 首页
        HomeViewController *homeVC = [[HomeViewController alloc] init];
        [self addOneChildVc:homeVC title:@"首页" imageName:@"home_back" selectedImageName:@"home"];
        self.homeVC = homeVC;
        CategoryViewController *cateVC = [[CategoryViewController alloc]init];
        NearViewController *nearVC = [[NearViewController alloc]init];
        [self addOneChildVc:nearVC title:@"附近" imageName:@"near_back" selectedImageName:@"near"];
        self.nearVC = nearVC;
        [self addOneChildVc:cateVC title:@"商品" imageName:@"fenlei_back" selectedImageName:@"fenlei"];
        self.cateVC = cateVC;
        
        WoViewController *woVC = [[WoViewController alloc]init];
        [self addOneChildVc:woVC title:@"我的" imageName:@"wo_back" selectedImageName:@"wo"];
        self.woVC = woVC;
        
       
    }
    return self;
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           需要添加的子控制器
 *  @param title             需要调节自控制器的标题
 *  @param imageName         需要调节自控制器的默认状态的图片
 *  @param selectedImageName 需要调节自控制器的选中状态的图片
 */
- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置子控制器的属性
    childVc.view.backgroundColor = [UIColor whiteColor];
    childVc.title = title;
    
    UIImage *norImage = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [ UIImage imageNamed:selectedImageName];
    
    childVc.tabBarItem.image = norImage;
    
    // 在设置tabbar选中图片之前告诉系统, 不要根据tintColor来渲染图片
    childVc.tabBarItem.selectedImage = selectedImage;
    
    
    // 给每一个子控制器包装一个导航控制器
    PBNavigationViewController *nav = [[PBNavigationViewController alloc] init];
       [nav addChildViewController:childVc];
    // 2.将自控制器添加到tabbar控制器中
//    if ([nav.viewControllers.firstObject isKindOfClass:[HomeViewController class]]){
//        nav.navigationBarHidden = YES;
//    }
    [self addChildViewController:nav];
    
    // 3.调用自定义tabBar的添加按钮方法, 创建一个与当前控制器对应的按钮
    [self.customTabBar addTabBarButton: childVc.tabBarItem];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.创建自定义tabBar
    CMTabBar *customTabBar = [[CMTabBar alloc] init];
    // 设置frame
    customTabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
    // 设置代理
    customTabBar.delegate = self;
   
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showWoVC) name:@"showWoVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backtoHome:) name:@"tongzhi" object:nil];
}

-(void)showWoVC{
    self.selectedIndex = 3;
}

-(void)backtoHome:(NSNotification *)loginnotifiction{
    NSString *backFalg =  loginnotifiction.userInfo[@"isLogin"];
    if ([backFalg isEqualToString:@"isLogin"]) {
//        [self tabBar:self.customTabBar selectedButtonfrom:2 to:0];
        
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    // 遍历系统的tabbar移除不需要的控件
    for (UIView *subView in self.tabBar.subviews) {
        // UITabBarButton私有API, 普通开发者不能使用
        if ([subView isKindOfClass:[UIControl class]]) {
            // 判断如果子控件时UITabBarButton, 就删除
            [subView removeFromSuperview];
        }
    }
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
   
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

#pragma mark - IWTabBarDelegate
- (void)tabBar:(CMTabBar *)tabBar selectedButtonfrom:(NSInteger)from to:(NSInteger)to
{
    // 切换控制器
    self.selectedIndex = to;
    NSLog(@"%ld",(long)to);
    // 如果当前点击的时首页, 还需要刷新数据
    if (0 == from) {
        if (0 == to) {
            NSLog(@"刷新数据");
            
        }
    }
    
}


-(void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
