//
//  NearViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/1.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "NearViewController.h"
#import "UIViewAdditions.h"
#import "NearListViewController.h"
#import "SMPagerTabView.h"
#import "ViewUtil.h"
#import "DetailViewController.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
#import "SearchViewController.h"
@interface NearViewController ()<SMPagerTabViewDelegate>
@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) SMPagerTabView *segmentView;
@end

@implementation NearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _allVC = [NSMutableArray array];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toDetailViewAction:) name:@"TODetailView" object:nil];
    
    NearListViewController *one = [[NearListViewController alloc]initWithNibName:nil bundle:nil];
    one.title = @"享美食";
   
    [_allVC addObject:one];
    
    NearListViewController *two = [[NearListViewController alloc]initWithNibName:nil bundle:nil];
    two.title = @"住酒店";
       [_allVC addObject:two];
    
    NearListViewController *three = [[NearListViewController alloc]initWithNibName:nil bundle:nil];
    three.title = @"爱玩乐";
    [_allVC addObject:three];
    NearListViewController *four = [[NearListViewController alloc]initWithNibName:nil bundle:nil];
    four.title = @"全部";
    [_allVC addObject:four];
    self.segmentView.delegate = self;
    //可自定义背景色和tab button的文字颜色等
    //开始构建UI
    [_segmentView buildUI];
    //起始选择一个tab
    [_segmentView selectTabWithIndex:0 animate:NO];
    
}
-(void)toDetailViewAction:(NSNotification *)dict{

   DetailViewController *detailVC = [[DetailViewController alloc]init];
////////////////////////////////////////////////
    //今后需要用,现在只是为了上线
//    detailVC.goodsId = shopDict[@"goodsId"];
//    detailVC.fuwuId = shopDict[@"shopId"];
        detailVC.goodsId = @"85";
        detailVC.fuwuId = @"487";
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)setNav{
    //城市
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(0, 0, 50, 25);
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([UserBean getCityName]) {
            [cityBtn setTitle:[UserBean getCityName] forState:UIControlStateNormal];
        }
    });
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //
//    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityBtn.frame), 8, 13, 10)];
//    [arrowImage setImage:[UIImage imageNamed:@"cityArrow"]];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 53, 25)];
    [leftView addSubview:cityBtn];
//    [leftView addSubview:arrowImage];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView: leftView];
    self.navigationController.navigationBar.barTintColor = [UIColor yellowColor];
    self.navigationItem.title = @"附近";
    self.navigationItem.leftBarButtonItem = leftBarBtn;
//    //搜索框
//    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityBtn.frame)+60, 30, screen_width-110, 25)];
//        searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"near_search"]];
//    searchView.backgroundColor = [UIColor whiteColor];
//    searchView.layer.masksToBounds = YES;
//    searchView.layer.cornerRadius = 12;
//    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchBtn.frame =searchView.frame;
//    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
//   
//    //
//    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 15, 15)];
//    [searchImage setImage:[UIImage imageNamed:@"sousuo"]];
//    [searchView addSubview:searchImage];
//    
//    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 25)];
//    placeHolderLabel.font = [UIFont boldSystemFontOfSize:13];
//    //    placeHolderLabel.text = @"请输入商家、品类、商圈";
//    placeHolderLabel.text = @"搜索附近吃喝玩乐";
//    placeHolderLabel.textColor = [ViewUtil hexColor:@"#999999"];
//    [searchView addSubview:placeHolderLabel];
//    self.navigationItem.titleView = searchView;
}

-(void)searchAction{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self presentViewController:searchVC animated:YES completion:nil];
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
    NSString *catId;
    if (number == 0) {
        catId = @"496";
    } else if (number == 1){
        catId = @"505";
    } else if (number == 2){
        catId = @"514";
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"Id"] = catId;
    [ZMCHttpTool postForJavaWithUrl:FBEightCatUrl parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"list"] = responseObject[@"data"];
//        parameters[@"fuid"] = catId;
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"nearListHot" object:nil userInfo:parameters];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - setter/getter
- (SMPagerTabView *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[SMPagerTabView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 22)];
        [self.view addSubview:_segmentView];
    }
    return _segmentView;
}

-(void)dealloc{
 [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:self];
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
