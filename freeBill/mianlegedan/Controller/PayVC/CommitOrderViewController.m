//
//  CommitOrderViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/11.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "CommitOrderViewController.h"
#import "CommitOrderNav_View.h"
#import "CommitOrderFooterView.h"
#import "ViewUtil.h"
#import "CommonUrl.h"
#import "PayOrderViewController.h"
#import "UserBean.h"
#import "ZMCHttpTool.h"
@interface CommitOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

//服务类生成订单
@implementation CommitOrderViewController{
    UITableView *_tableView;
    UILabel *_label;
    int _num;
    UILabel *_allPriceLabel;
    NSDictionary *dict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dict = [UserBean getUserDictionary];
    [self setNav];
    _num = 0;
    [self setTableView];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

-(void)setNav{
    CommitOrderNav_View *navView = [[[NSBundle mainBundle]loadNibNamed:@"CommitOrderNav_View" owner:self options:nil]lastObject];
    navView.frame = CGRectMake(0, 0, screen_width, 64);
    [navView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
    
     CommitOrderFooterView *footer = [[[NSBundle mainBundle]loadNibNamed:@"CommitOrderFooterView" owner:self options:nil]lastObject];
    footer.frame = CGRectMake(0, 0, screen_width, 50);
    footer.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
    [footer.commitOrderBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableFooterView = footer;
    [self.view addSubview:_tableView];
}

-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

//服务类提交订单
-(void)commitAction{
    if (_label.text.integerValue > 0){
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"goods_id"] = _goodsId;
        parameters[@"num"] = _label.text;
        parameters[@"token"] = dict[@"token"];
        parameters[@"tid"] = @"0";
        parameters[@"act"] = @"done";
        parameters[@"mobile"] = [UserBean getUserInfo][@"mobile_phone"];
        [ZMCHttpTool postWithUrl:FBOrderNumUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"===%@",responseObject);
            if([responseObject[@"status"] isEqualToString:@"1"]) {
                NSDictionary *dic = responseObject[@"data"];
                PayOrderViewController *payOrderVC = [[PayOrderViewController alloc]init];
                payOrderVC.isZhiYing = NO;
                payOrderVC.orderNum = dic[@"order_sn"];
                payOrderVC.goodsId = _goodsId;
                payOrderVC.goodsNum = _label.text;
                payOrderVC.goodsThumbImgUrl = self.goodsThumb;
                payOrderVC.goodsName = self.fuwuName;
                payOrderVC.goodsPrice = _allPriceLabel.text;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:payOrderVC animated:YES];
                });
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
    else {
        [self showAlert:@"请选择商品数量"];
    }
}


#pragma tableView 的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return  2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
//    else if(section == 1){
//        return 2;
//    }
    return 2;
}
    
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIndentif = @"commitCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentif];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentif];
    }
    if (indexPath.section == 0) {

        if (indexPath.row == 0) {
            cell.textLabel.text = _fuwuName;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [ViewUtil hexColor:@"#666666"];
            
            UILabel *priceLabel= [[UILabel alloc]initWithFrame:CGRectMake(screen_width -150, 15, 150, 20)];
            priceLabel.text = [NSString stringWithFormat:@"%@元",_price];
            priceLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:priceLabel];

        } else if(indexPath.row == 1){
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 20)];
            lable.textColor = [ViewUtil hexColor:@"#666666"];
            lable.text = @"数量：";
            [cell.contentView addSubview:lable];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width - 116, 10, 106, 32)];
            
                    imageView.image = [UIImage imageNamed:@"jiajian"];
            
            _label = [[UILabel alloc]initWithFrame:CGRectMake(screen_width -116, 15, 106, 20)];
            _label.font = [UIFont systemFontOfSize:15];
            _label.text = [NSString stringWithFormat:@"%d",_num];
            _label.textAlignment = NSTextAlignmentCenter;
            
        UIButton *jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jianBtn.frame = CGRectMake(screen_width -116, 0, 30, cell.frame.size.height);
        [jianBtn addTarget:self action:@selector(jianAction) forControlEvents:UIControlEventTouchUpInside];
//        [jianBtn setBackgroundColor:[UIColor redColor]];
        UIButton *jiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            jiaBtn.frame = CGRectMake(screen_width - 45, 0, 30, cell.frame.size.height);
//        [jiaBtn setBackgroundColor:[UIColor yellowColor]];
        [jiaBtn addTarget:self action:@selector(jiaAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:imageView];
            [cell.contentView addSubview:_label];
            [cell.contentView addSubview:jianBtn];
            [cell.contentView addSubview:jiaBtn];

        } else {
            cell.textLabel.text = @"小计";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [ViewUtil hexColor:@"#666666"];
            _allPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 120, 15, 110, 20)];
            _allPriceLabel.textColor = [ViewUtil hexColor:@"#ed6d4d"];
            _allPriceLabel.text = @"￥0.00";
            _allPriceLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_allPriceLabel];
        }
        
        // 暂时去掉，随便写的个数字做隐藏
    }
//    else if (indexPath.section == 4){
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"抵用券";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
////            UILabel *tipLabel = [[UILabel alloc]init];
////            tipLabel.frame  = CGRectMake(screen_width - 150, 20, 120, 21);
//            UILabel *diyongLabel = [[UILabel alloc]init];;
//            diyongLabel.frame = CGRectMake(screen_width -120, 12, 110, 21);
//            diyongLabel.font = [UIFont systemFontOfSize:15];
//            diyongLabel.text = @"使用抵用券";
//            [cell.contentView addSubview:diyongLabel];
////            [cell.contentView addSubview:tipLabel];
//        } else if(indexPath.row == 1){
//            cell.textLabel.text = @"使用积分";
//            UIImageView *tipImgView = [[UIImageView alloc]init];
//            tipImgView.frame = CGRectMake(90, 20, 15, 15);
//            tipImgView.image = [UIImage imageNamed:@"zhuyi"];
//            UILabel *dikouLabel = [[UILabel alloc]init];;
//            dikouLabel.frame = CGRectMake(screen_width -150, 5, 140, 21);
//            dikouLabel.font = [UIFont systemFontOfSize:15];
//            dikouLabel.text = @"本单不可使用抵扣券";
//            dikouLabel.textAlignment = NSTextAlignmentRight;
//            UILabel *goldLabel = [[UILabel alloc]init];
//            goldLabel.text = @"现有积分54";
//            goldLabel.textAlignment = NSTextAlignmentRight;
//            goldLabel.font = [UIFont systemFontOfSize:13];
//            goldLabel.textColor = [UIColor lightGrayColor];
//            goldLabel.frame = CGRectMake(dikouLabel.frame.origin.x, dikouLabel.frame.origin.y + 25, dikouLabel.frame.size.width, 15);
//            [cell.contentView addSubview:dikouLabel];
//            [cell.contentView addSubview:goldLabel];
//            [cell.contentView addSubview:tipImgView];
//        } else {
//            cell.textLabel.text = @"订单总价";
//            UILabel *priceLabel = [[UILabel alloc]init];
//            priceLabel.textColor  = [UIColor redColor];
//            priceLabel.font = [UIFont systemFontOfSize:13];
//            priceLabel.frame = CGRectMake(screen_width - 90, 15, 80, 21);
//            priceLabel.text = @"¥128";
//            priceLabel.textAlignment = NSTextAlignmentRight;
//            UILabel *numLabel = [[UILabel alloc]init];
//            numLabel.font = [UIFont systemFontOfSize:11];
//            numLabel.textColor = [UIColor lightGrayColor];
//            numLabel.text = @"(共1张)";
//            numLabel.frame = CGRectMake(screen_width-100, 18, 55, 15);
//            [cell.contentView addSubview:numLabel];
//            
//            [cell.contentView addSubview:priceLabel];
//            
//            
//        }
//      
//    }
    
    else if(indexPath.section == 1) {
        if (indexPath.row == 0) {
             cell.textLabel.text = @"当前手机号码";
        } else {
            //这个地方需要判断是手机注册还是电脑注册
            NSString *phone = [UserBean getUserInfo][@"mobile_phone"];
            if ([ViewUtil valiMobile:phone] == YES){
            phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            cell.textLabel.text = phone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *newPhoneLabel = [[UILabel alloc]init];
            newPhoneLabel.frame = CGRectMake(screen_width - 150, 20, 120, 21);
            newPhoneLabel.text = @"更换新手机号";
            [cell.contentView addSubview:newPhoneLabel];
            }
            else {
                
            }
        }
       
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



-(void)jiaAction{
    _num++;
    _label.text = [NSString stringWithFormat:@"%d",_num];
//    [_tableView reloadData];
    float allpirce = (_price.floatValue) *_num;
    _allPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",allpirce];
}
-(void)jianAction{
    if (_num ==0) {
        return;
    }
    _num--;
    _label.text = [NSString stringWithFormat:@"%d",_num];
//    [_tableView reloadData];
    float allpirce = (_price.floatValue) *_num;
    _allPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",allpirce];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else if(indexPath.section == 1){
        if (indexPath.row == 1) {
            return 55;
        }
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section== 2) {
//        return 50;
//    }
//    return 0.1;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 2) {
//        CommitOrderFooterView *footer = [[[NSBundle mainBundle]loadNibNamed:@"CommitOrderFooterView" owner:self options:nil]lastObject];
//        return footer;
//    }
//    UIView *lineView = [[UIView alloc]init];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    return lineView;
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
