//
//  HomeDetailViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/14.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "HomeDetailTableViewCell.h"
#import "DOPDropDownMenu.h"
#import "ViewUtil.h"
#import "ZMCHttpTool.h"
#import "CommonUrl.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "UserBean.h"
#import "MBProgressHUD/MBProgressHUD.h"
@interface HomeDetailViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic,strong) UIImageView *backgroundImg;

@property (nonatomic, strong) NSArray *sorts;
@property (nonatomic, strong) NSArray *select;
@property (nonatomic, weak) DOPDropDownMenu *menu;

@end

@implementation HomeDetailViewController{
    UITableView *_tableView;
    NSArray *_dataArr;
    MBProgressHUD *progressHUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setTableView];
    [self loadData];
    // 数据
    //    self.select = @[@"筛选",@"便宜的",@"贵的"];
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    _menu = menu;
    // 创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
//    [menu selectDefalutIndexPath];
}

-(UIImageView *)backgroundImg{
    if (!_backgroundImg){
        _backgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 108, screen_width, screen_height-64)];
        _backgroundImg.image = [UIImage imageNamed:@"contentDef"];
    }
    return _backgroundImg;
}

-(void)loadData{
    self.areas = @[@"附近",@"5km",@"10km",@"15km",@"20km",@"25km"];
    self.sorts = @[@"智能排序",@"离我最近",@"好评优先",@"人气优先"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"catId"] = _catId;
    parameters[@"parentId"] = @"1";
    parameters[@"pageNo"] = @"1";
    parameters[@"pageSize"] = @"10";
    //以后要改
    parameters[@"Lng"] =@"-122.406417";
    parameters[@"Lat"] =@"-37.785834";
//    37.785834,-122.406417
    NSLog(@"%@,%@",_lat,_lng);

    [self showHUD];
    
    [ZMCHttpTool postForJavaWithUrl:FBHomeHotListUrl parameters:parameters success:^(id responseObject) {
        NSLog(@"======%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            _dataArr = responseObject[@"data"][@"list"];
            if (_dataArr.count==0||!_dataArr){
                [self.view addSubview:self.backgroundImg];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                [progressHUD hideAnimated:YES];
            });
        }
        else {
            [self.view addSubview:self.backgroundImg];

        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)showHUD {
    progressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    progressHUD.delegate = self;
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:progressHUD];
    [progressHUD showAnimated:YES];
}
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud = nil;
}


-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, screen_width, screen_height-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
}

#pragma tableView 的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
   // headerView.backgroundColor = [UIColor yellowColor];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetif = @"homeDetailCell";
    HomeDetailTableViewCell *homeDetailCell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
    if (!homeDetailCell) {
        homeDetailCell = [[[NSBundle mainBundle]loadNibNamed:@"HomeDetailTableViewCell" owner:self options:nil]lastObject];
    }
    [homeDetailCell.shopImgView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",IMGURL,_dataArr[indexPath.row][@"goodsThumb"]]] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    
    homeDetailCell.shopTitleLabel.text = _dataArr[indexPath.row][@"GoodsName"];
    homeDetailCell.contentLabel.text = _dataArr[indexPath.row][@"GoodsBrief"];
    
    NSString *saleStr = [NSString stringWithFormat:@"已售: %@",_dataArr[indexPath.row][@"saleNum"]];
  
   homeDetailCell.caleNum.text = saleStr;
    
    homeDetailCell.priceLabel.text = [NSString stringWithFormat:@"￥%@元",_dataArr[indexPath.row][@"shopPrice"]];
   
//    NSString *juli = _dataArr[indexPath.row][@"juli"];
//    NSInteger localjuli =  (juli.integerValue)/1000 ;
//    homeDetailCell.locationLabel.text = [NSString stringWithFormat:@"%ldkm",(long)localjuli];
    
    homeDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return homeDetailCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.fuwuId = _dataArr[indexPath.row][@"ShopId"];

    detailVC.goodsId = _dataArr[indexPath.row][@"GoodsId"];
    NSString *juli = _dataArr[indexPath.row][@"juli"];
    NSInteger localjuli =  (juli.integerValue)/1000 ;
    detailVC.location= [NSString stringWithFormat:@"%ldkm",(long)localjuli];;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//- (IBAction)selectIndexPathAction:(id)sender {
//    [_menu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:2 item:2]];
//}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.classifys.count;
    }else if (column == 1){
        return self.areas.count;
    }else  {
        return self.sorts.count;
    }
        
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.classifys[indexPath.row];
    } else if (indexPath.column == 1){
        return self.areas[indexPath.row];
    } else {
        return self.sorts[indexPath.row];
    }
}

// new datasource

//- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForRowAtIndexPath:(DOPIndexPath *)indexPath
//{
//    if (indexPath.column == 0 || indexPath.column == 1) {
//        return [NSString stringWithFormat:@"ic_filter_category_%ld",indexPath.row];
//    }
//    return nil;
//}

//- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
//{
//    if (indexPath.column == 0 && indexPath.item >= 0) {
//        return [NSString stringWithFormat:@"ic_filter_category_%ld",indexPath.item];
//    }
//    return nil;
//}

// new datasource

//- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForRowAtIndexPath:(DOPIndexPath *)indexPath
//{
//    if (indexPath.column < 2) {
//        return [@(arc4random()%1000) stringValue];
//    }
//    return nil;
//}

//- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
//{
//    return [@(arc4random()%1000) stringValue];
//}

//- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
//{
//    if (column == 0) {
//        if (row == 0) {
//           return self.cates.count;
//        } else if (row == 2){
//            return self.movices.count;
//        } else if (row == 3){
//            return self.hostels.count;
//        }
//    }
//    return 0;
//}

//- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
//{
//    if (indexPath.column == 0) {
//        if (indexPath.row == 0) {
//            return self.cates[indexPath.item];
//        } else if (indexPath.row == 2){
//            return self.movices[indexPath.item];
//        } else if (indexPath.row == 3){
//            return self.hostels[indexPath.item];
//        }
//    }
//    return nil;
//}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    NSString *orderType;
    if (indexPath.row >0) {
        if (indexPath.column == 1) {
            orderType = self.areas[indexPath.row];
        } else if(indexPath.column == 2) {
            orderType = self.sorts[indexPath.row];
        } else {
            orderType = self.classifys[indexPath.row];
        }
    }
    // 传入type进行数据刷新
    [self loadData];
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
    }
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
