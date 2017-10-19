//
//  OrderDetailViewController.m
//  teyoujie
//
//  Created by 王长磊 on 2017/6/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "CommonUrl.h"
#import "CartSubmitAddressTableViewCell.h"
#import "CartSubmitGoodsTableViewCell.h"
#import "ViewUtil.h"
#import "ZMCHttpTool.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataSource;
}

@property (nonatomic,strong) UITableView *tableView;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"订单详情";
    
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)loadData{
    
}

//UITableView的协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2){
        return 1;
    }
    else {
        return 2;
    }
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0){
//        if (indexPath.row == 0) {
//        
//        }
//        else {
//        
//        }
//    }
//    else if (indexPath.section == 1) {
//        if (indexPath.row == 0) {
//        
//        }
//        else {
//            
//        }
//    }
//    else {
//        
//    }
//}

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
