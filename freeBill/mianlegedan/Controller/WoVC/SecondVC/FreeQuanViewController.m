//
//  freeQuanViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/5.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "FreeQuanViewController.h"
#import "ViewUtil.h"
#import "CouponHeaderView.h"
#import "CouponTableViewCell.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
@interface FreeQuanViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FreeQuanViewController{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = false;
    [self setTableView];
    self.title = @"免单券";
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self loadData];
}

-(void)loadData{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"act"] = @"list";
//    parameters[@"Is_use"] = @"0";
    parameters[@"page"] = @"1";
    parameters[@"token"] = [UserBean getUserDictionary][@"token"];
    [ZMCHttpTool postWithUrl:FBFuVoucherListUrl parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            _dataSource = responseObject[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetif = @"couponCell";
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CouponTableViewCell" owner:self options:nil]lastObject];
    }
    cell.goodsNameLb.text = _dataSource[indexPath.row][@"goods_name"];
    cell.orderNumLb.text = [NSString stringWithFormat:@"券号：%@",_dataSource[indexPath.row][@"vou_no"]];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        CouponHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"CouponHeaderView" owner:self options:nil]lastObject];
        return headerView;
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
