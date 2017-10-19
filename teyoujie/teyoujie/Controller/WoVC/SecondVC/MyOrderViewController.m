//
//  MyOrderViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/5.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "MyOrderViewController.h"
#import "UIViewAdditions.h"
#import "SMPagerTabView.h"
#import "ViewUtil.h"
#import "MyOrderListViewController.h"
#import "MJRefresh.h"
#import "UserBean.h"
#import "CommonUrl.h"
#import "ZMCHttpTool.h"

@interface MyOrderViewController ()<SMPagerTabViewDelegate>
@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) SMPagerTabView *segmentView;


@end

@implementation MyOrderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor lightGrayColor];
    _allVC = [NSMutableArray array];
    self.navigationController.navigationBarHidden= YES;
    MyOrderListViewController *one = [[MyOrderListViewController alloc]init];
    one.title = @"全部";
    [_allVC addObject:one];
    MyOrderListViewController *two = [[MyOrderListViewController alloc]init];
    two.title = @"待付款";
    [_allVC addObject:two];
    MyOrderListViewController *three = [[MyOrderListViewController alloc]init];
    three.title = @"待发货";
    [_allVC addObject:three];
    MyOrderListViewController *four = [[MyOrderListViewController alloc]init];
    four.title = @"待收货";
    [_allVC addObject:four];
    MyOrderListViewController *five = [[MyOrderListViewController alloc]init];
    five.title = @"已收货";
    [_allVC addObject:five];
    self.segmentView.delegate = self;
    //可自定义背景色和tab button的文字颜色等
    //开始构建UI
    [_segmentView buildUI];
    //起始选择一个tab
    [_segmentView selectTabWithIndex:0 animate:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    return [_allVC count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    return _allVC[number];
}

- (void)whenSelectOnPager:(NSUInteger)number {
    NSLog(@"页面 %lu",(unsigned long)number);
    MyOrderListViewController *orderListVC = _allVC[number];
    orderListVC.payStatus = [NSString stringWithFormat:@"%lu",(unsigned long)number];
    [orderListVC loadData:[NSString stringWithFormat:@"%lu",(unsigned long)number]];
    
}

#pragma mark - setter/getter
- (SMPagerTabView *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[SMPagerTabView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 22)];
        [self.view addSubview:_segmentView];
    }
    return _segmentView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
