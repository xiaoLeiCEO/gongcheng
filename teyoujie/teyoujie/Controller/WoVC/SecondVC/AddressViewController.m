//
//  AddressViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/15.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressFooterView.h"
#import "ViewUtil.h"
#import "MyAddrTableViewCell.h"
#import "AddressEditViewController.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
#import "ReceiveAddressListViewController.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView *backgroundImg;

@end

@implementation AddressViewController{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"收货地址";
    //注册通知
    [self setTableView];
    
    AddressFooterView *footerView =[[[NSBundle mainBundle]loadNibNamed:@"AddressFooterView" owner:self options:nil]lastObject];
    footerView.tag = 2001;
    footerView.frame = CGRectMake(0, screen_height - 50, screen_width, 50);
    [footerView.addAddrBtn addTarget:self action:@selector(addNewAddrAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footerView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.backgroundImg removeFromSuperview];
    [self loadData];
    
}
-(UIImageView *)backgroundImg{
    if (!_backgroundImg){
        _backgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
        _backgroundImg.image = [UIImage imageNamed:@"addressDef"];
    }
    return _backgroundImg;
}
//添加收货地址按钮事件
-(void)addNewAddrAction{
    AddressEditViewController *addrEditVC = [[AddressEditViewController alloc]init];
    [self.navigationController pushViewController:addrEditVC animated:YES];
}

-(void)loadData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *dict =[UserBean getUserDictionary];
    parameters[@"act"] = @"address_list";
    parameters[@"token"] = dict[@"token"];
    parameters[@"sign"] = [ViewUtil getSign:parameters];
    [ZMCHttpTool postWithUrl:FBAddressReceiveUrl parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            _dataSource = [[NSMutableArray alloc]init];
            NSArray *arr = responseObject[@"data"];
            [_dataSource addObjectsFromArray:arr];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_dataSource.count<1) {
                    [self.view insertSubview:self.backgroundImg belowSubview:[self.view viewWithTag:2001]];
                }
                [_tableView reloadData];
            });
        }
        else {
            [self.view insertSubview:self.backgroundImg belowSubview:[self.view viewWithTag:2001]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  124;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetif = @"myOrderCell";
    MyAddrTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyAddrTableViewCell" owner:self options:nil]lastObject];
    }
    cell.consigneeLb.text = _dataSource[indexPath.section][@"consignee"];
    cell.telLb.text = _dataSource[indexPath.section][@"mobile"];
    cell.addressLb.text = [NSString stringWithFormat:@"%@%@%@%@",_dataSource[indexPath.section][@"province"],_dataSource[indexPath.section][@"city"],_dataSource[indexPath.section][@"district"],_dataSource[indexPath.section][@"address"]];
    cell.defaultAddressBtn.tag = indexPath.section + 100;
    [cell.defaultAddressBtn addTarget:self action:@selector(setDefaultReceiveAddress:) forControlEvents:UIControlEventTouchUpInside];
    if ([_dataSource[indexPath.section][@"default_address"] isEqual:@1]) {
        cell.defaultAddressBtn.selected = YES;
    }
    
    [cell.editAddressBtn addTarget:self action:@selector(editAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.editAddressBtn.tag = indexPath.section + 200;
    [cell.delAddressBtn addTarget:self action:@selector(delAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delAddressBtn.tag = indexPath.section + 300;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//编辑
-(void)editAddressBtnAction:(UIButton *)sender{
    ReceiveAddressListViewController *receiveAddressListVC = [[ReceiveAddressListViewController alloc]init];
    receiveAddressListVC.addressId = _dataSource[sender.tag - 200][@"address_id"];
    receiveAddressListVC.consignee = _dataSource[sender.tag - 200][@"consignee"];
    receiveAddressListVC.phoneNum = _dataSource[sender.tag - 200][@"mobile"];
    NSString *address = [NSString stringWithFormat:@"%@%@%@",_dataSource[sender.tag - 200][@"province"],_dataSource[sender.tag - 200][@"city"],_dataSource[sender.tag - 200][@"district"]];
    receiveAddressListVC.address = address;
    receiveAddressListVC.detailAddress = _dataSource[sender.tag - 200][@"address"];
    [self.navigationController pushViewController:receiveAddressListVC animated:YES];
}
//删除
-(void)delAddressBtnAction:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:@"确认删除该收货地址？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"address_id"] = _dataSource[sender.tag - 300][@"address_id"];
        parameters[@"token"] = [UserBean getUserDictionary][@"token"];
        parameters[@"act"] = @"del_address";
        [ZMCHttpTool postWithUrl:FBAddressReceiveUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]){
                //删除成功
                [self loadData];
            }
            else {
                //删除失败
            }
        } failure:^(NSError *error) {
            
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

//设为默认收货地址
-(void)setDefaultReceiveAddress:(UIButton *)sender{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"address_id"] = _dataSource[sender.tag - 100][@"address_id"];
    parameters[@"token"] = [UserBean getUserDictionary][@"token"];
    [ZMCHttpTool postWithUrl:FBSetDefaultAddressUrl parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            //设置默认收货地址成功
            [self loadData];
        }
        else{
            //设置默认收货地址失败
            sender.selected = NO;
        }
        
    } failure:^(NSError *error) {
        
    }];
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
