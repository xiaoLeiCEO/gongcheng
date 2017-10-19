//
//  CommitOrderViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/11.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "CommitOrderViewController.h"
#import "CommitOrderFooterView.h"
#import "ViewUtil.h"
#import "CommonUrl.h"
#import "UserBean.h"
#import "CommitOrderVCTbCell.h"
#import "ZMCHttpTool.h"
#import "UIImageView+WebCache.h"
#import "PayOrder_View.h"
#import "MBProgressHUD.h"
#import "WXApi.h"   
#import <AlipaySDK/AlipaySDK.h>
#import "OrderResultViewController.h"

@interface CommitOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    UILabel *_totalPriceLb;
    UITextField *_postscriptTF;
    NSString *_goodsNum;
    PayOrder_View *_payOrderView;
    NSString *_orderNum;
}

@property (nonatomic,strong) MBProgressHUD *progressHud;
@property (nonatomic,strong) UIView *grayBackground;

@end

//服务类生成订单
@implementation CommitOrderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提交订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _goodsNum = @"1";
    _postscriptTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 12, screen_width - 110, 21)];
    _postscriptTF.font = [UIFont systemFontOfSize:15];
    [self setTableView];
}


-(UIView *)grayBackground{
    if (!_grayBackground) {
        _grayBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
        _grayBackground.backgroundColor = [UIColor blackColor];
        _grayBackground.alpha = 0.3;
    }
    return _grayBackground;
}

-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CommitOrderVCTbCell" bundle:nil] forCellReuseIdentifier:@"CommitOrderVCTbCell"];
    [self.view addSubview:_tableView];
    
    CommitOrderFooterView *footerView = [[NSBundle mainBundle]loadNibNamed:@"CommitOrderFooterView" owner:self options:nil].lastObject;
    footerView.totalPriceLb.text = [NSString stringWithFormat:@"￥%.2f",_goodsNum.floatValue * _price.floatValue];
    _totalPriceLb = footerView.totalPriceLb;
    footerView.frame = CGRectMake(0, screen_height - 50, screen_width, 50);
    [footerView.commitOrderBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footerView];
}

-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

//服务类提交订单
-(void)commitAction{
    if (_goodsNum.integerValue > 0){
        _progressHud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.navigationController.view addSubview:_progressHud];
        _progressHud.label.text = @"正在加载";
        _progressHud.mode = MBProgressHUDModeIndeterminate;
        [_progressHud showAnimated:YES];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"goods_id"] = _goodsId;
        parameters[@"num"] = _goodsNum;
        parameters[@"token"] = [UserBean getUserDictionary][@"token"];
        parameters[@"tid"] = @"0";
        parameters[@"act"] = @"done";
        parameters[@"mobile"] = [UserBean getUserInfo][@"mobile_phone"];
        [ZMCHttpTool postWithUrl:FBOrderNumUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"===%@",responseObject);
            if([responseObject[@"status"] isEqualToString:@"1"]) {
                [_progressHud hideAnimated:YES];
                
                //获取订单号
                _orderNum = responseObject[@"data"][@"order_sn"];
                
                [self.view addSubview:self.grayBackground];
                _payOrderView = [[NSBundle mainBundle]loadNibNamed:@"PayOrder_View" owner:self options:nil].lastObject;
                _payOrderView.frame = CGRectMake(0, screen_height, screen_width, 351);
                [self.view addSubview:_payOrderView];
                
                _payOrderView.goodsPriceLb.text = _totalPriceLb.text;
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
                
                [UIView animateWithDuration:0.5 animations:^{
                    _payOrderView.center = CGPointMake(screen_width / 2, screen_height - 175.5);
                }];


            }
        } failure:^(NSError *error) {
            
        }];
        
    }
    else {
        [self showAlert:@"请选择商品数量"];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showOrderResultViewController) name:@"fuwuPaySuccess" object:nil];
    
}


//显示服务类商品支付成功的页面
-(void)showOrderResultViewController{
    OrderResultViewController *orderVC = [[OrderResultViewController alloc]init];
    orderVC.goodsName = _fuwuName;
    orderVC.goodsThumb = _goodsThumb;
    orderVC.orderNum = _orderNum;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:orderVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
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
        parameters[@"goods_id"] = _goodsId;
        parameters[@"num"] = _goodsNum;
        parameters[@"token"] = [UserBean getUserDictionary][@"token"];
        parameters[@"postscript"] = @"可选";
        _progressHud.label.text = @"正在加载...";
        _progressHud.mode = MBProgressHUDModeIndeterminate;
        [_progressHud showAnimated:YES];
        [ZMCHttpTool postWithUrl:FBOrderFuWuUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"===%@",responseObject);
            if([responseObject[@"status"] isEqualToString:@"1"]) {
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
                //失败
                _progressHud.label.text = responseObject[@"msg"];
                [_progressHud hideAnimated:YES afterDelay:2];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else if (tag == 102) {
        //支付宝支付
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"goods_id"] = _goodsId;
        parameters[@"num"] = _goodsNum;
        parameters[@"token"] = [UserBean getUserDictionary][@"token"];
        parameters[@"postscript"] = @"可选";
        _progressHud.label.text = @"正在加载...";
        _progressHud.mode = MBProgressHUDModeIndeterminate;
        [_progressHud showAnimated:YES];
        [ZMCHttpTool postWithUrl:FBAlipayUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject[@"msg"]);
            if ([responseObject[@"status"] isEqualToString:@"1"]){
                NSString *appScheme = @"dashixian.teyoujieshop";
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [UIView animateWithDuration:0.5 animations:^{
        _payOrderView.center = CGPointMake(screen_width / 2, screen_height + 175.5);

    } completion:^(BOOL finished) {
        [_grayBackground removeFromSuperview];
        [_payOrderView removeFromSuperview];
        //跳转订单详情
    }];
}

#pragma tableView 的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 2;
    }
    else {
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phoneCell"];
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"phoneCell"];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"当前手机号码";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            NSString *phone = [UserBean getUserInfo][@"mobile_phone"];
            if ([ViewUtil valiMobile:phone] == YES){
                phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                cell.textLabel.text = phone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = @"更换新手机号";
            }
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
            cell2.goodsNameLb.text = _fuwuName;
            cell2.goodsPriceLb.text = _price;
            [cell2.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell2.subtractBtn addTarget:self action:@selector(subtractBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell2.goodsThumbImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,_goodsThumb]]];
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
            cell2.detailTextLabel.text = [NSString stringWithFormat:@"共计%@件商品 小计: ￥%.2f",_goodsNum,_goodsNum.floatValue * _price.floatValue];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell2;
        }
    }

}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 44;
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
    _totalPriceLb.text = [NSString stringWithFormat:@"￥%.2f",_goodsNum.floatValue * _price.floatValue];
    [_tableView reloadData];
}
//减
-(void)subtractBtnClick{
    NSInteger num = _goodsNum.integerValue;
    if (num > 0){
        _goodsNum = [NSString stringWithFormat:@"%ld",num - 1];
        _totalPriceLb.text = [NSString stringWithFormat:@"￥%.2f",_goodsNum.floatValue * _price.floatValue];
    }
    else {
        _goodsNum = @"0";
        _totalPriceLb.text = @"￥0.00";
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


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fuwuPaySuccess" object:nil];
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
