//
//  MyOrderListViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/5.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "ViewUtil.h"
#import "MyOrderTableViewCell.h"
#import "MJRefresh.h"
#import "UserBean.h"
#import "ZMCHttpTool.h"
#import "CommonUrl.h"
#import "MyOrderViewController.h"
@interface MyOrderListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIImageView *backgroundImg;

@end

@implementation MyOrderListViewController{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadTableView];
}

-(UIImageView *)backgroundImg{
    if (!_backgroundImg){
        _backgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
        _backgroundImg.image = [UIImage imageNamed:@"我的订单background"];
    }
    return _backgroundImg;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)loadData:(NSString *)status{
    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc]init];
    paramaters[@"token"] = [UserBean getUserDictionary][@"token"];
    paramaters[@"status"] = status;
    [ZMCHttpTool postWithUrl:FBGetOrderUrl parameters:paramaters success:^(id responseObject) {
        NSLog(@"%@", responseObject[@"msg"]);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
        _dataSource = responseObject[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }
        else {
            //获取订单失败
        [self.view addSubview:self.backgroundImg];
        }
    } failure:^(NSError *error) {
        
    }];
}


-(void)loadTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-104) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 45)];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 35)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    //付款、提醒发货按钮
    UIButton *payMoneyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    payMoneyBtn.frame = CGRectMake(screen_width - 80, 5, 70, 25);
    payMoneyBtn.layer.cornerRadius = 10;
    payMoneyBtn.layer.borderWidth = 1;
    payMoneyBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    [payMoneyBtn setTitleColor:[UIColor orangeColor] forState:normal];
    payMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    payMoneyBtn.tag = section + 100;
    if (_dataSource){
        if  ([_dataSource[section][@"pay_status"] isEqualToString:@"0"]){
            [payMoneyBtn setTitle:@"付款" forState:normal];
        }
        else if ( [_dataSource[section][@"pay_status"] isEqualToString:@"2"]){
            [payMoneyBtn setTitle:@"提醒发货" forState:normal];
        }
    }
    [payMoneyBtn addTarget:self action:@selector(payMoneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //编辑按钮
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    delBtn.frame = CGRectMake(screen_width - 80 - 80, 5, 70, 25);
    delBtn.layer.cornerRadius = 10;
    delBtn.layer.borderWidth = 1;
    delBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    [delBtn setTitleColor:[UIColor orangeColor] forState:normal];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    delBtn.tag = section + 200;
    [delBtn setTitle:@"删除订单" forState:normal];
    [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:delBtn];
    [contentView addSubview:payMoneyBtn];
    [footerView addSubview:contentView];
    return footerView;
}

//编辑按钮点击事件
-(void)delBtnClick:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:@"确认删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *paramaters = [[NSMutableDictionary alloc]init];
        paramaters[@"token"] = [UserBean getUserDictionary][@"token"];
        paramaters[@"order_id"] = _dataSource[sender.tag - 200][@"order_id"];
        [ZMCHttpTool postWithUrl:FBDelOrderUrl parameters:paramaters success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]){
                [self loadData:_payStatus];
            }
        } failure:^(NSError *error) {
            
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

//付款按钮点击事件
-(void)payMoneyBtnClick:(UIButton *)sender{
//    NSLog(@"点击%@页面%ld行", _payStatus,sender.tag - 100);
    NSLog(@"%@",_dataSource[sender.tag - 100][@"goods_name"]);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 100, 5, 100, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor orangeColor];
    if (_dataSource){
        if  ([_dataSource[section][@"pay_status"] isEqualToString:@"0"]){
        label.text = @"等待买家付款";
        }
        else if ( [_dataSource[section][@"pay_status"] isEqualToString:@"2"]){
            label.text = @"已付款";
        }
    }
    [headerView addSubview:label];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *cellIndetif = @"myOrderCell";
        MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil]lastObject];
        }
        cell.goodsNumLb.text = [NSString stringWithFormat:@"x%@",_dataSource[indexPath.section][@"goods_number"]];
        cell.goodsNameLb.text = _dataSource[indexPath.section][@"goods_name"];
        cell.goodsPriceLb.text = [NSString stringWithFormat:@"￥%@",_dataSource[indexPath.section][@"goods_price"]];
        [cell.goodsThumbImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,_dataSource[indexPath.section][@"goods_thumb"]]]];
        cell.goodsAllPrice.text = [NSString stringWithFormat:@"共计%@件商品 合计: ￥%@",_dataSource[indexPath.section][@"goods_number"],_dataSource[indexPath.section][@"goods_amount"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
