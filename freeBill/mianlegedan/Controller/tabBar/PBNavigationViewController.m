//
//  PBNavigationViewController.m
//  playboy
//
//  Created by 张梦川 on 15/11/4.
//  Copyright © 2015年 yaoyu. All rights reserved.
//

#import "PBNavigationViewController.h"
#import "UIBarButtonItem+Extension.h"
@interface PBNavigationViewController ()

@end

@implementation PBNavigationViewController

+ (void)initialize
{
    // 1.设置导航条的主题
    [self setupNavTheme];

}

/**
 *设置导航条的主题
 */
+ (void)setupNavTheme
{
    // 1.1获取外观对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"64x1"] forBarMetrics:UIBarMetricsDefault];
    //[navBar setBackgroundColor:[UIColor redColor]];
    // 1.1.2设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    // 1.1.3设置标题颜色
    NSMutableDictionary *titleMd = [NSMutableDictionary dictionary];
    // 设置字体颜色
    titleMd[NSForegroundColorAttributeName] = [UIColor whiteColor];
    // 设置字体大小
    titleMd[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [navBar setTitleTextAttributes:titleMd];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;  
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    if (self.childViewControllers.count > 0) { // 如果不是添加栈底的控制器才需要隐藏tabbar
        // 不能直接让所有的控制器都隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;

        // 覆盖系统左边和右边的按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"back" highlightedImageName:@"ic_arrow_back_check" target:self sel:@selector(back)];


    }



    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    // 移除栈顶控制器
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
