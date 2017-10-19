//
//  WoViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/1.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "WoViewController.h"
#import "UserBean.h"
#import "LoginViewController.h"
#import "ZMCHttpTool.h"
#import "ViewUtil.h"
#import "btnView.h"
#import "wo_headView.h"
#import "woTableViewCell.h"
#import "SettingViewController.h"
#import "MessageViewController.h"
#import "CollectViewController.h"
#import "FreeQuanViewController.h"
#import "MyOrderViewController.h"
#import "MyBalanceViewController.h"
#import "MyCommentViewController.h"
#import "GoodsCarViewController.h"
#import "MallViewController.h"
#import "UploadImg.h"
#import "UIImageView+WebCache.h"
#import "MyInfoViewController.h"
#import "AddressViewController.h"
#import "UserBean.h"
@interface WoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIImageView *headImgView;
@end

@implementation WoViewController{
    
    NSDictionary *_userinfo;
    UITableView *_tableView;
    NSMutableArray *_menuArray;
    NSMutableArray *_dataArray;
    wo_headView *_headerView;
    UIImage *_headImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction:) name:@"uploadImg" object:nil];
    [self loadTableView];
    // Do any additional setup after loading the view.
}
-(void)refreshAction:(NSNotification *)dict{
    [self stopHUDmessage];
    
    if ([dict.userInfo[@"stats"] isEqualToString:@"0"]) {
        [self showHUDmessage:@"上传失败"];
    } else {
        [self showHUDmessage:@"上传成功"];
    }
    [_tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadData];
        
    });
    
}

-(void)loadTableView{
    // 加载个人中心页面
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20,screen_width , screen_height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
-(void)settingAction:(UIButton *)settingBtn{
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
-(void)freequanAction:(UIButton *)freequanBtn{
        FreeQuanViewController *freeVC = [[FreeQuanViewController alloc]init];
        [self.navigationController pushViewController:freeVC animated:YES];
}
-(void)collectAction:(UIButton *)collectBtn{
    CollectViewController *collectVC = [[CollectViewController alloc]init];
    [self.navigationController pushViewController:collectVC animated:YES];
}
// 上传头像
-(void)changeHeadImgAction{
    [self uploadHeadImage];
    self.picker.delegate = self;
}
#pragma tableView 代理方法
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1){
        return 3;
    } else if(section == 2){
        return 4;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 137;
    }else{
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 70;
    } else if (section == 2) {
        return 0.1;
    } else {
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 70)];
        footerView.backgroundColor  = [ViewUtil hexColor:@"#f0f0f0"];
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 60)];
        contentView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i<4; i++) {
            btnView *btn_view = [[[NSBundle mainBundle]loadNibNamed:@"btnView" owner:self options:nil]lastObject];
            btn_view.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushOrderViewController)];
            [btn_view addGestureRecognizer:tap];
            btn_view.frame = CGRectMake(15 +(screen_width*0.25 *i), 0, 60, 60);
            btn_view.BtnImage.image = [UIImage imageNamed:_menuArray[i][@"image"]] ;
            btn_view.btnTitle.text = _menuArray[i][@"title"];
            
            [contentView addSubview:btn_view];
        }
        [footerView addSubview:contentView];
        return footerView;
    } else {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 5)];
        footerView.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
        return footerView;
    }
    
}

-(void)pushOrderViewController{
    MyOrderViewController *myOrder = [[MyOrderViewController alloc]init];
    [self.navigationController pushViewController:myOrder animated:YES];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"wo_headView" owner:self options:nil]lastObject];
        [_headerView.changeHeadImg addTarget:self action:@selector(changeHeadImgAction) forControlEvents:UIControlEventTouchUpInside];
        _headerView.headImage.layer.cornerRadius = _headerView.headImage.frame.size.height*0.5;
        [_headerView.settingBtn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.freequanBtn addTarget:self action:@selector(freequanAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.myInfoBtn addTarget:self action:@selector(myInfoAction:) forControlEvents:UIControlEventTouchUpInside];
        _headerView.headImage.layer.masksToBounds = YES;
        
        _headerView.frame = CGRectMake(0, 0, screen_width, 137);
        NSString *url = [NSString stringWithFormat:@"%@%@",IMGURL,_userinfo[@"photo"]];
        if (_headImg) {
            _headerView.headImage.image = _headImg;
        } else {
            [_headerView.headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeImg"]];
        }
        
        _headerView.userName.text = _userinfo[@"nick_name"];
        return _headerView;
    }else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 5)];
        headerView.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
        return headerView;
    }
    
}
-(void)myInfoAction:(UIButton *)btn{
    MyInfoViewController *myInfoVC = [[MyInfoViewController alloc]init];
    [self.navigationController pushViewController:myInfoVC animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"qoCell";
    woTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"woTableViewCell" owner:self options:nil]lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height -1, screen_width, 1)];
    //    [cell.contentView addSubview:lineView];
    if (indexPath.section == 0) {
        cell.cell_Image.image = [UIImage imageNamed:@"我的订单"];
        cell.cell_title.text = @"我的订单";
        cell.detailLabel.text = @"查看全部订单";
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            cell.cell_Image.image = [UIImage imageNamed:@"余额"];
            cell.cell_title.text = @"余额";
            cell.detailLabel.text = [NSString stringWithFormat:@"¥%@",_userinfo[@"balance"]];
        } else if (indexPath.row == 1) {
            
            cell.cell_Image.image = [UIImage imageNamed:@"dizhi"];
            cell.cell_title.text = @"管理收货地址";
            cell.detailLabel.text = @"";
        }
        else if(indexPath.row == 2) {
            cell.cell_Image.image = [UIImage imageNamed:@"gouwuche_select"];
            cell.cell_title.text = @"我的购物车";
            cell.detailLabel.text = @"";
        }
        //        else {
        //            cell.cell_Image.image = [UIImage imageNamed:@"我的钱包"];
        //            cell.cell_title.text = @"我的钱包";
        //            cell.detailLabel.text = @"";
        //        }
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.cell_Image.image = [UIImage imageNamed:@"我的评价"];
            cell.cell_title.text = @"积分兑换";
            cell.detailLabel.text = [NSString stringWithFormat:@"有%@积分,快来兑换吧",_userinfo[@"jifen"]];
            
        }else  if (indexPath.row == 1) {
            cell.cell_Image.image = [UIImage imageNamed:@"积分商城"];
            cell.cell_title.text = @"积分商城";
            cell.detailLabel.text = @"";
            
        }
        else if (indexPath.row == 2){
            cell.cell_Image.image = [UIImage imageNamed:@"返利记录"];
            cell.cell_title.text = @"积分领取";
            cell.detailLabel.text = [NSString stringWithFormat:@"有%@积分,快来领取吧",_userinfo[@"frozen_jifen"]];
            
        }else if (indexPath.row == 3){
            cell.cell_Image.image = [UIImage imageNamed:@"客服中心"];
            cell.cell_title.text = @"客服中心";
            cell.detailLabel.text = @"";
            
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MyOrderViewController *myOrder = [[MyOrderViewController alloc]init];
        [self.navigationController pushViewController:myOrder animated:YES];
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            //            MyBalanceViewController *myBalanceVC = [[MyBalanceViewController alloc]init];
            //            [self.navigationController pushViewController:myBalanceVC animated:YES];
            [self showHUDmessage:@"请前往PC端操作www.mianlegedan.com"];
            
        } else if (indexPath.row == 1){
            AddressViewController *addrVC = [[AddressViewController alloc]init];
            [self.navigationController pushViewController:addrVC animated:YES];
        }
        else if(indexPath.row == 2){
            GoodsCarViewController *goodCarVC = [[GoodsCarViewController alloc]init];
            [self.navigationController pushViewController:goodCarVC animated:YES];
        }
        //        else {
        //
        //                        MyWalletViewController *myWalletVC = [[MyWalletViewController alloc]init];
        //                        [self.navigationController pushViewController:myWalletVC animated:YES];
        //        }
        
    } else {
        if (indexPath.row == 0) {
            //            MyCommentViewController *myCommentVC = [[MyCommentViewController alloc]init];
            //            [self.navigationController pushViewController:myCommentVC animated:YES];
            
            //积分提现的界面,调到主线程，是为了解决卡顿问题
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:@"每天兑换总积分的1/365"];
            });
        }
        else if(indexPath.row == 1){
            MallViewController *mallVC = [[MallViewController alloc]init];
            [self.navigationController pushViewController:mallVC animated:YES];
        }
        else if(indexPath.row == 2){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert1:@"每天领取冻结积分的1/365"];
            });
        }
        
        else if (indexPath.row == 3){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"客服电话" message:@"10010000" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                UIWebView *webView = [[UIWebView alloc]init];
                NSURL *url = [NSURL URLWithString:@"tel://10010000"];
                [webView loadRequest:[NSURLRequest requestWithURL:url]];
                [self.view addSubview:webView];
            }];
            
            [alert addAction:cancel];
            [alert addAction:confirm];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
        
    }
}

//积分领取
-(void)showAlert1:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"积分兑换" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        parameters[@"token"] = [UserBean getUserDictionary][@"token"];
        [ZMCHttpTool postWithUrl:FBjifenLingQuUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]) {
                [self showAlertView:responseObject[@"msg"]];
            }else {
                [self showHUDmessage:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//积分提现
-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"积分兑换" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        parameters[@"token"] = [UserBean getUserDictionary][@"token"];
        [ZMCHttpTool postWithUrl:FBjifenTiXianUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]) {
                [self showAlertView:responseObject[@"msg"]];
            }else {
                [self showHUDmessage:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)showAlertView:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)loadData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"act"] = @"user_info";
    parameters[@"token"] = [UserBean getUserDictionary][@"token"];
    NSLog(@"%@",parameters[@"token"]);
    NSString *sign =  [ViewUtil getSign:parameters];
    parameters[@"sign"] = sign;
    if ([UserBean isSignIn]) {
        [ZMCHttpTool postWithUrl: FBGetUserInfo parameters:parameters success:^(id responseObject) {
            _userinfo = [[NSDictionary alloc]init];
            _userinfo = responseObject[@"data"][@"info"];
            [UserBean setUserInfo:_userinfo];
            [_tableView reloadData];
        } failure:^(NSError *error) {
            [self showHUDmessage:@"获取用户信息失败！"];
        }];
    }
    _menuArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:@"待付款" forKey:@"title"];
    [dic1 setObject:@"代付款" forKey:@"image"];
    [_menuArray addObject:dic1];
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:@"待发货" forKey:@"title"];
    [dic2 setObject:@"待使用" forKey:@"image"];
    [_menuArray addObject:dic2];
    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] init];
    [dic3 setObject:@"待收货" forKey:@"title"];
    [dic3 setObject:@"待评价" forKey:@"image"];
    [_menuArray addObject:dic3];
    NSMutableDictionary *dic4 = [[NSMutableDictionary alloc] init];
    [dic4 setObject:@"已收货" forKey:@"title"];
    [dic4 setObject:@"退款" forKey:@"image"];
    [_menuArray addObject:dic4];
    
}
#pragma mark UIImagePickerControllerDelegate
//选择图或者拍照后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *orignalImage = [info objectForKey:UIImagePickerControllerOriginalImage];//原图
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
    [self startHUDmessage:@"正在上传.."];
    
    _headImg = editedImage;
    
    
    // 拍照后保存原图片到相册中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && orignalImage) {
        UIImageWriteToSavedPhotosAlbum(orignalImage, self, nil, NULL);
    }
    //上传照片
    [picker dismissViewControllerAnimated:YES completion:^{
        if (editedImage) {
            [UploadImg uploadImage:editedImage withUrl:FBUploadImgUrl];
        }
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
