//
//  GoodsCarViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/15.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "GoodsCarViewController.h"
#import "ViewUtil.h"
#import "GoodsCarTableViewCell.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
#import "GoodsCarTableViewForFooter.h"
#import "CartSubmitOrderViewController.h"
#import "ShopDetailViewController.h"
@interface GoodsCarViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIImageView *backgroundImg;
@end

@implementation GoodsCarViewController{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    //合计
    UILabel *_hejiePriceLb;
    //全选
    UIButton *_quanxuanBtn;
    //选中的行
    NSMutableArray *_selectArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购物车";
    _selectArr = [[NSMutableArray alloc]init];
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    [self loadData];
    [_selectArr removeAllObjects];
    _hejiePriceLb.text = @"￥0.00";
    _quanxuanBtn.selected = NO;
    [self.backgroundImg removeFromSuperview];
}

-(void)loadData{
    NSMutableDictionary *para = [[NSMutableDictionary alloc]init];
    para[@"token"] = [UserBean getUserDictionary][@"token"];
    para[@"act"] = @"cart";
    [ZMCHttpTool postWithUrl:FBCart parameters:para success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            //获取购物车成功
           _dataSource = [[NSMutableArray alloc]initWithArray:responseObject[@"data"][@"list"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_dataSource.count<1) {
                    [self.view insertSubview:self.backgroundImg belowSubview:[self.view viewWithTag:2000]];
                }
                [_tableView reloadData];
            });
        }
        else{
            //获取购物车失败
            [self.view insertSubview:self.backgroundImg belowSubview:[self.view viewWithTag:2000]];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)createUI{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64 - 60) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    GoodsCarTableViewForFooter *footerView = [[[NSBundle mainBundle]loadNibNamed:@"GoodsCarTableViewForFooter" owner:self options:nil]lastObject];
    footerView.tag = 2000;
    footerView.frame = CGRectMake(0, screen_height - 60, screen_width, 60);
    [footerView.jieSuanBtn addTarget:self action:@selector(jieSuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView.allSelectBtn addTarget:self action:@selector(allSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    _closingLedgerBtn = footerView.jieSuanBtn;
    _hejiePriceLb = footerView.allPriceLb;
   _quanxuanBtn = footerView.allSelectBtn;
    footerView.allPriceLb.text = @"￥0.00";
    [self.view addSubview:footerView];

}

-(UIImageView *)backgroundImg{
    if (!_backgroundImg){
        _backgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
        _backgroundImg.image = [UIImage imageNamed:@"cartDef"];
    }
    return _backgroundImg;
}


//结算按钮点击事件
-(void)jieSuanBtnClick{
    if ([_hejiePriceLb.text isEqualToString:@"￥0.00"]){
        [self showHUDmessage:@"请选择商品"];
    }
    else{
        
        for (int i = 0; i<_dataSource.count;i++){
            UIButton *btn = [self.view viewWithTag:i + 100];
            if (btn.selected){
                [_selectArr addObject:_dataSource[btn.tag - 100]];
                NSLog(@"%@", _selectArr);
            }
        }
        
        CartSubmitOrderViewController *cartSubmitOrderVC = [[CartSubmitOrderViewController alloc]init];
        cartSubmitOrderVC.totalPrice = _hejiePriceLb.text;
        cartSubmitOrderVC.dataSource = _selectArr;
        [self.navigationController pushViewController:cartSubmitOrderVC animated:YES];
    }
}
//全选按钮点击事件
-(void)allSelectBtnClick:(UIButton *)sender{
    float temp = 0.00;

    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    //全选未选中
    if (!sender.selected){
        for (int i =0 ; i< _dataSource.count; i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:_dataSource[i]];
            dic[@"is_select"] = @"1";
            temp = [NSString stringWithFormat:@"%@",dic[@"total_price"]].floatValue + temp;
            [tempArr addObject:dic];
        }
    }
    //全选选中
    else {
        for (int i =0 ; i< _dataSource.count; i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:_dataSource[i]];
            dic[@"is_select"] = @"0";
            [tempArr addObject:dic];
        }
        temp = 0.00;
    }
    _hejiePriceLb.text = [NSString stringWithFormat:@"￥%.2f",temp];
    sender.selected = !sender.selected;
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:tempArr];
    [_tableView reloadData];
    
    
}

#pragma tableView 的代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 10)];
    return lineView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetif = @"goodsCell";
    GoodsCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
    if (!cell) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GoodsCarTableViewCell" owner:self options:nil]lastObject];
    }
    cell.goodsPriceLb.text = _dataSource[indexPath.row][@"goods_price"];
    cell.goodsNumLb.text = [NSString stringWithFormat:@"x%@",_dataSource[indexPath.row][@"goods_number"]];
    cell.goodsNameLb.text = _dataSource[indexPath.row][@"goods_name"];
    [cell.goodsThumbImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,_dataSource[indexPath.row][@"goods_thumb"]]]];
    [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectBtn.tag = indexPath.row + 100;
    if ([_dataSource[indexPath.row][@"is_select"] isEqualToString:@"0"]){
        cell.selectBtn.selected = NO;
    }
    else if ([_dataSource[indexPath.row][@"is_select"]  isEqualToString:@"1"]) {
        cell.selectBtn.selected = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转商品详情页面
    ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc]init];
    shopDetailVC.goodsId = _dataSource[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", (long)indexPath.row);
    NSMutableDictionary *para = [[NSMutableDictionary alloc]init];
    para[@"token"] = [UserBean getUserDictionary][@"token"];
    para[@"act"] = @"del_cart_goods";
    para[@"rec_id"] = _dataSource[indexPath.row][@"rec_id"];
    [ZMCHttpTool postWithUrl:FBCart parameters:para success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            [self loadData];
        }
        else {
            [self showHUDmessage:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//cell上选中按钮的点击事件
-(void)selectBtnClick:(UIButton *)sender{
        if(!sender.selected){
            //加
            NSString *temp = _dataSource[sender.tag - 100][@"total_price"];
            _hejiePriceLb.text = [NSString stringWithFormat:@"￥%.2f",temp.floatValue + _hejiePriceLb.text.floatValue];
        }
        else{
            //减
            NSString *temp = _dataSource[sender.tag - 100][@"total_price"];
            _hejiePriceLb.text = [NSString stringWithFormat:@"￥%.2f",_hejiePriceLb.text.floatValue - temp.floatValue];
        }
    sender.selected = !sender.selected;
    _quanxuanBtn.selected = NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
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
