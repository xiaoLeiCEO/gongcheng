//
//  PayOrderViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/11.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "PayOrderViewController.h"
#import "ViewUtil.h"
#import "CommonUrl.h"
#import "CommitOrderNav_View.h"
#import "PayOrder_View.h"
#import "OrderResultViewController.h"
#import "WXApi.h"
#import "UIImageView+WebCache.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
@interface PayOrderViewController ()

@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNav];
    [self loadmainView];
}

-(void)loadmainView{
    PayOrder_View *mainView = [[[NSBundle mainBundle]loadNibNamed:@"PayOrder_View" owner:self options:nil]lastObject];
    [mainView.finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    mainView.frame =CGRectMake(0, 70, screen_width, 400);
    self.view.backgroundColor =[UIColor lightGrayColor];
    //微信支付
    [mainView.weixinPayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    mainView.weixinPayBtn.showsTouchWhenHighlighted = YES;
    //支付宝支付
    [mainView.zhiFuBaoPayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    mainView.zhiFuBaoPayBtn.showsTouchWhenHighlighted = YES;
    //银行卡支付
    [mainView.bankPayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    mainView.bankPayBtn.showsTouchWhenHighlighted = YES;
   [mainView.goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,_goodsThumbImgUrl]] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    mainView.goodsPrice.text = self.goodsPrice;
    mainView.goodsName.text = self.goodsName;
    [self.view addSubview:mainView];
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
    }
    else if (tag == 101){
        //微信支付
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"goods_id"] = _goodsId;
        parameters[@"num"] = _goodsNum;
        parameters[@"token"] = [UserBean getUserDictionary][@"token"];
        parameters[@"text"] = @"可选";

        
        if (!_isZhiYing){
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
                }
            } failure:^(NSError *error) {
                
            }];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showOrderResultViewController) name:@"orderNo" object:nil];
        }
        else {
            NSMutableDictionary *parameters1 = [NSMutableDictionary dictionary];
            parameters1[@"token"] = [UserBean getUserDictionary][@"token"];
            //获取默认收货地址
            [ZMCHttpTool postWithUrl:FBGetAdressUrl parameters:parameters1 success:^(id responseObject) {
                if ([responseObject[@"status"] isEqualToString:@"1"]){
                    parameters[@"address_id"] = responseObject[@"data"][@"address_id"];
                    [ZMCHttpTool postWithUrl:FBOrderZhiYingUrl parameters:parameters success:^(id responseObject) {
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
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                }
                else {
                    //获取默认收货地址失败，请设置默认收货地址
                    
                }
                
                
            } failure:^(NSError *error) {
                
            }];
        }
        

    }
    else if (tag == 102) {
        //支付宝支付
    }
    else {
        [self showAlert:@"请选择支付方式"];
    }
    
    if (!_isZhiYing){
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showOrderResultViewController) name:@"orderNo" object:nil];
    }
}
//显示服务类商品支付成功的页面
-(void)showOrderResultViewController{
    OrderResultViewController *orderVC = [[OrderResultViewController alloc]init];
    //需要服务器返回订单号
    orderVC.orderNo = _orderNum;
    orderVC.goodsName = _goodsName;
    orderVC.goodsThumb = _goodsThumbImgUrl;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:orderVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)setNav{
    CommitOrderNav_View *navView = [[[NSBundle mainBundle]loadNibNamed:@"CommitOrderNav_View" owner:self options:nil]lastObject];
    navView.titleLabel.text = @"支付订单";
    navView.frame = CGRectMake(0, 0, screen_width, 64);
    [navView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"orderNo" object:self];

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
