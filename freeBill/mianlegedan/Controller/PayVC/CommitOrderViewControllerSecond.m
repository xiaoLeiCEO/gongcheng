//
//  CommitOrderViewControllerSecond.m
//  teyoujie
//
//  Created by 王长磊 on 2017/5/9.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "CommitOrderViewControllerSecond.h"
#import "CommitOrderNav_View.h"
#import "CommitOrderFooterView.h"
#import "ViewUtil.h"
#import "CommonUrl.h"
#import "PayOrderViewController.h"
#import "UserBean.h"
#import "ZMCHttpTool.h"
#import "CommitOrderVCTbCell.h"
#import "CartSubmitAddressTableViewCell.h"
#import "PayOrder_View.h"
#import "WXApi.h"
#import "AddressViewController.h"
#import "MBProgressHUD.h"
#import <AlipaySDK/AlipaySDK.h>
@interface CommitOrderViewControllerSecond ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableDictionary *_dataDic;
    PayOrder_View *_payOrderView;
    UITextField *_postscriptTF;

}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MBProgressHUD *progressHud;
@end

@implementation CommitOrderViewControllerSecond {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"提交订单";
    [self createUI];

}

-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
}
-(void)createUI{
    _postscriptTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 12, screen_width - 110, 21)];
    _postscriptTF.font = [UIFont systemFontOfSize:15];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64 - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CommitOrderVCTbCell" bundle:nil] forCellReuseIdentifier:@"CommitOrderVCTbCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CartSubmitAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"CartSubmitAddressTableViewCell"];
    [self.view addSubview:_tableView];
    CommitOrderFooterView *footerView = [[NSBundle mainBundle]loadNibNamed:@"CommitOrderFooterView" owner:self options:nil].lastObject;
    footerView.frame = CGRectMake(0, screen_height - 50, screen_width, 50);
    [footerView.commitOrderBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footerView];
}


//提交订单的点击事件
-(void)commitAction{
    if (_dataDic){
        if (_goodsNum.integerValue > 0) {
            _payOrderView = [[NSBundle mainBundle]loadNibNamed:@"PayOrder_View" owner:self options:nil].lastObject;
            _payOrderView.frame = CGRectMake(0, screen_height, screen_width, 351);
            [self.view addSubview:_payOrderView];
            
            _progressHud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_progressHud];
            
            [_payOrderView.finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
            //微信支付
            [_payOrderView.weixinPayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            _payOrderView.weixinPayBtn.showsTouchWhenHighlighted = YES;
            //支付宝支付
            [_payOrderView.zhiFuBaoPayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            _payOrderView.zhiFuBaoPayBtn.showsTouchWhenHighlighted = YES;
            //银行卡支付
            [_payOrderView.bankPayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            _payOrderView.bankPayBtn.showsTouchWhenHighlighted = YES;
            
            _tableView.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.5 animations:^{
                _payOrderView.center = CGPointMake(screen_width / 2, screen_height - 175.5);
            }];
        }
        else {
            [self showAlert:@"请添加商品数量"];
        }
    }
    else {
        [self showAlert:@"请添加收货地址"];
    }
}

-(void)loadData{
    NSMutableDictionary *para = [[NSMutableDictionary alloc]init];
    para[@"token"] = [UserBean getUserDictionary][@"token"];
    [ZMCHttpTool postWithUrl:FBGetAdressUrl parameters:para success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            _dataDic = responseObject[@"data"];
            [_tableView reloadData];
        }
        else {
            //获取默认收货地址失败
            _dataDic = nil;
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}


-(void)btnAction: (UIButton *) sender{
    
    for (int i=100;i<103;i++){
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = NO;
        if (sender.tag == 100){
            //银行卡支付
            sender.selected = YES;
        }
        else if (sender.tag == 101){
            //微信支付
            sender.selected = YES;
        }
        else if (sender.tag == 102) {
            //支付宝支付
            sender.selected = YES;
        }
        
    }
    
}

-(void)finishAction{
    NSInteger tag = 0;
    for (int i=100;i<103;i++){
        UIButton *btn = [self.view viewWithTag:i];
        if (btn.selected) {
            tag = btn.tag;
        }
    }
    
    if (tag == 100){
        //银行卡支付
        _progressHud.mode = MBProgressHUDModeText;
        _progressHud.label.text = @"敬请期待";
        [_progressHud showAnimated:YES];
        [_progressHud hideAnimated:YES afterDelay:1];
    }
    else if (tag == 101){
        //微信支付
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = [UserBean getUserDictionary][@"token"];
        parameters[@"goods_id"] = _goodsId;
        parameters[@"num"] = _goodsNum;
        parameters[@"postscript"] = _postscriptTF.text;
        parameters[@"address_id"] = _dataDic[@"address_id"];
        _progressHud.label.text = @"正在加载...";
        _progressHud.mode = MBProgressHUDModeIndeterminate;
        [_progressHud showAnimated:YES];
        [ZMCHttpTool postWithUrl:FBOrderZhiYingUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]){
                NSDictionary *dic = responseObject[@"data"][@"weixin"];
                PayReq *request = [[PayReq alloc]init];
                request.partnerId = dic[@"partnerid"];
                request.prepayId= dic[@"prepayid"];
                request.package = dic[@"package"];
                request.nonceStr= dic[@"noncestr"];
                request.timeStamp = [dic[@"timestamp"] integerValue];
                request.sign = dic[@"sign"];
                [WXApi sendReq:request];
                [_progressHud hideAnimated:YES];
            }
            else {
                //生成订单失败
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else if (tag == 102) {
        //支付宝支付
        //支付宝支付
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = [UserBean getUserDictionary][@"token"];
        parameters[@"goods_id"] = _goodsId;
        parameters[@"num"] = _goodsNum;
        parameters[@"postscript"] = _postscriptTF.text;
        parameters[@"address_id"] = _dataDic[@"address_id"];
        _progressHud.label.text = @"正在加载...";
        _progressHud.mode = MBProgressHUDModeIndeterminate;
        [_progressHud showAnimated:YES];
        [ZMCHttpTool postWithUrl:FBAlipayUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject[@"msg"]);
            if ([responseObject[@"status"] isEqualToString:@"1"]){
                NSString *appScheme = @"com.mainlegedan";
                // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *orderString = responseObject[@"orderstr"];
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
                [_progressHud hideAnimated:YES];
                
            }
            else{
                //失败
                _progressHud.label.text = responseObject[@"msg"];
                [_progressHud hideAnimated:YES afterDelay:2];
            }
        } failure:^(NSError *error) {
            
        }];

    }
    else {
        [self showAlert:@"请选择支付方式"];
    }
    
}


-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_payOrderView removeFromSuperview];
    _tableView.userInteractionEnabled = YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }
    else {
        return 3;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (_dataDic){
            CartSubmitAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartSubmitAddressTableViewCell" forIndexPath:indexPath];
            if (cell == nil){
                cell = [[CartSubmitAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CartSubmitAddressTableViewCell"];
            }
            cell.phoneNumLb.text = _dataDic[@"mobile"];
            cell.consigneeLb.text = [NSString stringWithFormat:@"收件人: %@",_dataDic[@"consignee"]];
            cell.receiveAddressLb.text  = [NSString stringWithFormat:@"收货地址: %@%@%@%@",_dataDic[@"province_name"],_dataDic[@"city_name"],_dataDic[@"district_name"],_dataDic[@"address"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
            if (cell == nil){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell"];
            }
            cell.textLabel.text = @"抱歉您还没有添加收货地址，点击添加";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else {
        if (indexPath.row == 0){
            CommitOrderVCTbCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"CommitOrderVCTbCell" forIndexPath:indexPath];
            if (cell2 == nil){
                cell2 = [[CommitOrderVCTbCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommitOrderVCTbCell"];
            }
            cell2.goodsNumLb.text = _goodsNum;
            cell2.goodsNameLb.text = _goodsName;
            cell2.goodsPriceLb.text = _goodsprice;
            [cell2.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell2.subtractBtn addTarget:self action:@selector(subtractBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell2.goodsThumbImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,_goodsThumbUrl]]];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell2;
        }
        else if (indexPath.row == 1){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.textLabel.text = @"买家留言";
                _postscriptTF.placeholder = @"选填:对本次交易的说明";
                _postscriptTF.delegate = self;
                //因为肯定只有一行 所以可以把cell上的_postScriptTF 拿出来
                [cell.contentView addSubview:_postscriptTF];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else {
            UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (cell2 == nil) {
                cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
            }
            cell2.detailTextLabel.textColor = [UIColor orangeColor];
            cell2.detailTextLabel.text = [NSString stringWithFormat:@"共计%@件商品 小计: ￥%.2f",_goodsNum,_goodsNum.floatValue * _goodsprice.floatValue];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell2;
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        //点击跳转收货地址列表
        AddressViewController *addressVC= [[AddressViewController alloc]init];
        [self.navigationController pushViewController:addressVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 100;
    }
    else {
        if (indexPath.row == 0){
            return 85;
        }
        else{
            return 44;
        }
    }
    
}
//加
-(void)addBtnClick{
    _goodsNum = [NSString stringWithFormat:@"%ld",_goodsNum.integerValue + 1];
    [_tableView reloadData];
}
//减
-(void)subtractBtnClick{
    NSInteger num = _goodsNum.integerValue;
    if (num > 0){
        _goodsNum = [NSString stringWithFormat:@"%d",num - 1];
    }
    else {
        _goodsNum = @"0";
    }
    [_tableView reloadData];
}

//UITextFieldDelgate协议方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
