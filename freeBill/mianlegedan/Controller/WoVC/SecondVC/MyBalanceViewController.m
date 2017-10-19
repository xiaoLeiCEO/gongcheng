//
//  MyBalanceViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/6.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "MyBalanceViewController.h"
#import "ViewUtil.h"
#import "MyBalanceContentView.h"
//#import "MyWalletHeaderView.h"
@interface MyBalanceViewController ()

@end

@implementation MyBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"余额";
    self.navigationController.navigationBarHidden = false;
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setTitle:@"余额明细" forState:UIControlStateNormal];
//    [rightButton setFrame:CGRectMake(0, 0, 100, 30)];
//    [rightButton addTarget:self
//                    action:@selector(editAction)
//          forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    MyBalanceContentView *balanceView = [[[NSBundle mainBundle]loadNibNamed:@"MyBalanceContentView" owner:self options:nil] lastObject];
    balanceView.frame = CGRectMake(0, 50, screen_width, 300);
    [self.view addSubview:balanceView];
    
    
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
