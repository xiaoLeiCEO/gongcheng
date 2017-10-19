//
//  HomeViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/1.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "UserBean.h"
#import "ViewUtil.h"

#import "MJRefresh.h"
#import "DiscountViewForCell.h"
#import "HomeMenuCell.h"
#import "ShopRecommendCell.h"
#import "ShopInfoModel.h"
#import "RushCell.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "HomeDetailViewController.h"
#import "SearchViewController.h"
#import "ZMCHttpTool.h"
#import "MessageViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD/MBProgressHUD.h"
@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate>
    {
        NSMutableArray *_dataSource;
        NSMutableArray *_menuArray;//
//        NSMutableArray *_rushArray;//抢购数据
        NSMutableArray *_discountArray;
        NSString *_lng;
        NSString*_lat;
        NSString *_city;
        UIButton *_cityBtn;
        Boolean flag;
    }
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self setNav];
    [self initTableView];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back:) name:@"tongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuClickAction:) name:@"menuClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UploginVC:) name:@"notLogin" object:nil];
          // Do any additional setup after loading the view.
     flag = true;
    [self loadData];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    self.navigationController.navigationBarHidden = YES;
    [self initializeLocationService];
}
-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-49-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//    [self setUpTableView];
    
}
-(void)loadData {
    
    [ZMCHttpTool postWithUrl:FBGuessLikeUrl parameters:nil success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSLog(@"%@",responseObject[@"data"]);
            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                ShopInfoModel *shopInfoModel = [[ShopInfoModel alloc]init];
                [shopInfoModel setValuesForKeysWithDictionary:responseObject[@"data"][i]];
                [_dataSource addObject:shopInfoModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });

        }
    } failure:^(NSError *error) {
        
    }];
}

//-(void)setUpTableView{
//    //设置下拉刷新回调
//    
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//        [_tableView.mj_footer setState:MJRefreshStateIdle];
//        
//    }];
//    
//    //下拉刷新
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        [_tableView.mj_footer setState:MJRefreshStateIdle];
////        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//        [_tableView.mj_header endRefreshing];
//
//        
//    }];
//}

-(void)setNav{
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
//    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"64x1"]];
//    [self.view addSubview:backView];
    //城市
    _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityBtn.frame = CGRectMake(0, 0, 40, 25);
    _cityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
   // [_cityBtn setTitle:@"北京" forState:UIControlStateNormal];
//    [backView addSubview:_cityBtn];
    //
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cityBtn.frame), 8, 13, 10)];
    [arrowImage setImage:[UIImage imageNamed:@"drop_down"]];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 53, 25)];
    [leftView addSubview:_cityBtn];
    [leftView addSubview:arrowImage];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView: leftView];
    self.navigationController.navigationBar.barTintColor = [UIColor yellowColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
//    [backView addSubview:arrowImage];
//    //二维码扫描
//    UIButton *qrCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    qrCodeBtn.frame = CGRectMake(screen_width-80, 30, 40, 30);
//    [qrCodeBtn setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
//    qrCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    
//    [qrCodeBtn addTarget:self action:@selector(OnqQrcodeBtnTap:) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:qrCodeBtn];
//    
//    //消息
//    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    messageBtn.frame = CGRectMake(screen_width-40, 30, 40, 30);
//    [messageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
//    messageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
// 
//    [messageBtn addTarget:self action:@selector(OnMessageBtnTap:) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:messageBtn];
    //搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(arrowImage.frame)+10, 30, screen_width-165, 25)];
//    searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchBar"]];
    UIImageView *serchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, searchView.frame.size.width, searchView.frame.size.height)];
    serchImgView.image = [UIImage imageNamed:@"home_search"];
    [searchView addSubview:serchImgView];
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 13, 13)];
    searchImg.image = [UIImage imageNamed:@"seach"];
    [searchView addSubview:searchImg];
    UILabel *tipLabel =[[UILabel alloc]initWithFrame:CGRectMake(40, 4, screen_width-200, 20)];
    tipLabel.text =@"搜索商家,品类或商圈";
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textColor = [ViewUtil hexColor:@"#999999"];
    [searchView addSubview:tipLabel];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 12;
//    [backView addSubview:searchView];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame =tipLabel.frame;
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    self.navigationItem.titleView = searchView;
}

-(void)searchAction{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    searchVC.isZhiYing = NO;
    [self presentViewController:searchVC animated:YES completion:nil];
    
}

    //初始化数据
-(void)initData{
//    _rushArray = [[NSMutableArray alloc] init];
    _discountArray = [[NSMutableArray alloc] init];
    _menuArray = [[NSMutableArray alloc] init];
    _dataSource = [[NSMutableArray alloc]init];

    /*  写死，固定值
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"Id"] = @"1";
    [ZMCHttpTool postForJavaWithUrl:FBEightCatUrl parameters:nil success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
     */
    [ZMCHttpTool postWithUrl:FBHomeServiceStore parameters:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            _discountArray = responseObject[@"data"];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    dict[@"image"] = @"食";
    dict[@"title"] = @"食物";
    dict[@"ziid"] = @"496";
    [_menuArray addObject:dict];
    NSMutableDictionary *dict1= [NSMutableDictionary dictionary];
    dict1[@"image"] = @"电影";
    dict1[@"title"] = @"电影";
    dict1[@"ziid"] = @"512";
    [_menuArray addObject:dict1];
    NSMutableDictionary *dict2= [NSMutableDictionary dictionary];
    dict2[@"image"] = @"酒店";
    dict2[@"title"] = @"酒店";
    dict2[@"ziid"] = @"505";
    [_menuArray addObject:dict2];
   
    NSMutableDictionary *dict4= [NSMutableDictionary dictionary];
    dict4[@"image"] = @"休闲娱乐";
    dict4[@"title"] = @"休闲娱乐";
    dict4[@"ziid"] = @"514";
    [_menuArray addObject:dict4];
    NSMutableDictionary *dict5= [NSMutableDictionary dictionary];
    dict5[@"image"] = @"KTV";
    dict5[@"title"] = @"KTV";
    dict5[@"ziid"] = @"513";
    [_menuArray addObject:dict5];
    NSMutableDictionary *dict6= [NSMutableDictionary dictionary];
    dict6[@"image"] = @"周边游";
    dict6[@"title"] = @"周边游";
    dict6[@"ziid"] = @"529";
    [_menuArray addObject:dict6];
    NSMutableDictionary *dict8= [NSMutableDictionary dictionary];
    dict8[@"image"] = @"丽人";
    dict8[@"title"] = @"丽人";
    dict8[@"ziid"] = @"566";
    [_menuArray addObject:dict8];
    NSMutableDictionary *dict9= [NSMutableDictionary dictionary];
    dict9[@"image"] = @"生活服务";
    dict9[@"title"] = @"生活服务";
    dict9[@"ziid"] = @"552";
    [_menuArray addObject:dict9];
    //
}
//开始定位服务
-(void)initializeLocationService {

    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
        NSLog(@"定位服务可用");
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"定位失败，请打开定位服务");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:@"定位失败，您没有开启定位服务，请前往设置->隐私，开启定位服务" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
    }
}


// 二维码扫描
-(void)OnqQrcodeBtnTap:(UIButton *)btn{

}
// 消息事件
-(void)OnMessageBtnTap:(UIButton *)btn{
    MessageViewController *messageVC = [[MessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
}


-(void)menuClickAction:(NSNotification *)dict{
    if (flag) {
        flag = false;
       
    } else {
        return;
    }
   
    NSLog(@"%@",dict.userInfo[@"tag"]) ;
    HomeDetailViewController *homedetailVC = [[HomeDetailViewController alloc]init];
    homedetailVC.catId = dict.userInfo[@"tag"];
    homedetailVC.lng = _lng;
    homedetailVC.lat = _lat;
     NSMutableDictionary *parameters2 = [NSMutableDictionary dictionary];
    parameters2[@"Id"] = dict.userInfo[@"tag"];
    
    [ZMCHttpTool postForJavaWithUrl:FBEightCatUrl parameters:parameters2 success:^(id responseObject) {
        NSLog(@"%@",responseObject);
     
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"全部"];

        NSArray *tempArr = responseObject[@"data"][@"list"];
        for (int i =0; i<tempArr.count;i++) {
            [arr addObject:tempArr[i][@"name"]];
        }
        homedetailVC.classifys = arr;
        dispatch_async(dispatch_get_main_queue(), ^{
            flag= true;
             [self.navigationController pushViewController:homedetailVC animated:YES];
        });
       
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)UploginVC:(NSNotification *)NSNotification{
    if(![UserBean isSignIn]){
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        nav.title = @"登录";
        [self presentViewController:nav animated:YES completion:nil];
        
    }

}
-(void)back:(NSNotification *)loginnotifiction{
    NSString *backFalg =  loginnotifiction.userInfo[@"isLogin"];
    if ([backFalg isEqualToString:@"isLogin"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    
}
//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    
//    return UIStatusBarStyleDefault;
//
//}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return 3;
}
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return _dataSource.count + 1;
    }
        return 1;
}
    
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  180;
    } else if(indexPath.section == 1) {
        return screen_width *0.63-1;
    } else if(indexPath.section == 2 && indexPath.row == 0){
        return 45;
    }
    return 120;
}
    

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
 
    return 0.1;
    
}
    
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 0.1)];
    footerView.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
    return footerView;
}
    
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIndentifier = @"menucell";
        HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:_menuArray];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        
            static NSString *cellIndentifier = @"discountcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
            }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_width*0.63-1)];
        for (int i = 0; i<7; i++) {
            DiscountViewForCell *discountView = [[[NSBundle mainBundle]loadNibNamed:@"DiscountViewForCell" owner:self options:nil]lastObject];
            
            discountView.frame = CGRectMake((screen_width*0.33 *i)+3, 0,screen_width*0.33-1,screen_width*0.33);
            if (i>=3) {
                 discountView.frame = CGRectMake((screen_width*0.25 *(i-3))+3, screen_width*0.33+1, screen_width*0.25-1, screen_width*0.30);
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            discountView.userInteractionEnabled = YES;
            [discountView addGestureRecognizer:tap];
            
            view.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
            [view addSubview:discountView];
            [cell.contentView addSubview:view];
            
            if (_discountArray.count == 7) {
            [discountView.imageView sd_setImageWithURL:[NSURL URLWithString:[IMGURL stringByAppendingString:_discountArray[i][@"shop_logo"]]] placeholderImage:[UIImage imageNamed:@"placeImg"]];
            discountView.titleLable.text = _discountArray[i][@"shop_name"];
            
            }
        }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
    }
    else{//推荐
        if(indexPath.row == 0){
            static NSString *cellIndentifier = @"morecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            cell.textLabel.text = @"- 猜你喜欢 -";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [ViewUtil hexColor:@"#333333"];
            cell.textLabel.frame = CGRectMake(0, 0, screen_width, 40);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *cellIndentifier = @"recommendcell";
            ShopRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[ShopRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            if(_dataSource.count!=0){
                ShopInfoModel *dataSource = _dataSource[indexPath.row - 1];
                [cell setShopRecM:dataSource];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
    }
}

-(void) tapAction:(UIGestureRecognizer *)tapgesture{
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    progress.mode = MBProgressHUDModeText;
    progress.label.text = @"敬请期待";
    progress.delegate = self;
    [self.view addSubview:progress];
    [progress showAnimated:YES];
    [progress hideAnimated:YES afterDelay:1];
}
//MBProgressHUD 隐藏时的代理方法
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud = nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 1)];
//    headerView.backgroundColor = RGB(239, 239, 244);
        headerView.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
    return headerView;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2){
        if (indexPath.row != 0) {
            DetailViewController *detailVC = [[DetailViewController alloc]init];
            ShopInfoModel *shopModel = _dataSource[indexPath.row-1];
            detailVC.fuwuId = shopModel.shop_id;
            detailVC.goodsId = shopModel.goods_id;
            detailVC.goodsThumb = shopModel.goods_thumb;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    

}

//实现其中的代理方法。

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //将经度显示到label上
    _lng = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
    //将纬度现实到label上
    _lat = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    [UserBean setLongitude:_lng];
    [UserBean setLatitude:_lat];
    
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            //self.location.text = placemark.name;
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            
            _city = city;
            [UserBean setCityName:_city];
            _cityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [_cityBtn setTitle:city forState:UIControlStateNormal];
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户未选择");
            break;
            // 暂时没用，应该是苹果预留接口
        case kCLAuthorizationStatusRestricted:
            NSLog(@"受限制");
            break;
            // 真正被拒绝、定位服务关闭等影响定位服务的行为都会进入被拒绝状态
        case kCLAuthorizationStatusDenied:
            
            if (![CLLocationManager locationServicesEnabled]) { // 定位服务开启
                NSLog(@"真正被用户拒绝");
                //  跳转到设置界面
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if ([[UIApplication sharedApplication] canOpenURL:url]) {   // url地址可以打开
                    [[UIApplication sharedApplication] openURL:url];
                }
            } else {
                NSLog(@"服务未开启");
            }
            
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"前后台定位授权");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"前台定位授权");
            break;
            
        default:
            break;
    }
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
