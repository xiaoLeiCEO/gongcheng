//
//  HomeViewController.m
//  mianlegedan
//
//  Created by 王长磊 on 2017/5/18.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "ZMCHttpTool.h"
#import "CommonUrl.h"
#import "ViewUtil.h"
#import "UIImageView+WebCache.h"
#import "SearchViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UserBean.h"
#import "LoginViewController.h"
#import "ShopDetailViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    NSMutableArray *_dataSource;
    UIButton *_cityBtn;
    NSString *_lng;
    NSString*_lat;
    NSString *_city;
    MBProgressHUD *proHud;
}
@property (nonatomic,strong) UITableView *tb;
@property(nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self createUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UploginVC:) name:@"notLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back:) name:@"tongzhi" object:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [self initializeLocationService];
}

-(void)createUI{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"64x1"]];
    [self.view addSubview:backView];
    //城市
    _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityBtn.frame = CGRectMake(10, 30, 40, 25);
    _cityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    // [_cityBtn setTitle:@"北京" forState:UIControlStateNormal];
    [backView addSubview:_cityBtn];
    //
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cityBtn.frame), 30, 20, 20)];
    [arrowImage setImage:[UIImage imageNamed:@"dingwei"]];
    [backView addSubview:arrowImage];
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
    [backView addSubview:searchView];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame =tipLabel.frame;
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    
    
    _tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64 - 44) style:UITableViewStylePlain];
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    UINib *nib = [UINib nibWithNibName:@"HomeTableViewCell" bundle:nil];
    [_tb registerNib:nib forCellReuseIdentifier:@"homecell"];
    [self.view addSubview:_tb];
    
    proHud= [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:proHud];
}

-(void)searchAction{
//    SearchViewController *searchVC = [[SearchViewController alloc]init];
//    [self presentViewController:searchVC animated:YES completion:nil];
    proHud.mode = MBProgressHUDModeText;
    proHud.label.text = @"敬请期待";
    [proHud showAnimated:YES];
    [proHud hideAnimated:YES afterDelay:1];
}


-(void)loadData{
    proHud.mode = MBProgressHUDModeIndeterminate;
    [proHud showAnimated:YES];
    proHud.label.text = @"正在加载";
    [ZMCHttpTool postWithUrl:FBHomeGoodsListUrl parameters:nil success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            //获取商品列表成功
            _dataSource = responseObject[@"data"];
            [_tb reloadData];
            [_tb.mj_header endRefreshing];
            [proHud hideAnimated:YES];
        }
        else{
            //获取商品列表失败
        }
    } failure:^(NSError *error) {
        
    }];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homecell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc]init];
    }
    [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,_dataSource[indexPath.row][@"goods_img"]]]];
    cell.goodsNameLb.text = _dataSource[indexPath.row][@"goods_name"];
    cell.goodsPriceLb.text = [NSString stringWithFormat:@"￥%@",_dataSource[indexPath.row][@"shop_price"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc]init];
    shopDetailVC.goodsId = _dataSource[indexPath.row][@"goods_id"];

    [self.navigationController  pushViewController:shopDetailVC animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
