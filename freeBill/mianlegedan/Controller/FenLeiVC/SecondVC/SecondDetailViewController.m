//
//  SecondDetailViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/10.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "SecondDetailViewController.h"
#import "ViewUtil.h"
#import "SecondNavView.h"
#import "SecondDetailCell.h"
#import "ZMCHttpTool.h"
#import "CommonUrl.h"
#import "ShopDetailViewController.h"
#import "SearchViewController.h"
#import "UIImageView+WebCache.h"
#import "DOPDropDownMenu.h"
#import "MJRefresh.h"

@interface SecondDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>

@property (nonatomic,weak) DOPDropDownMenu *menu;

@end

@implementation SecondDetailViewController{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    int _pageNo;
//    bool flag;
    NSArray *_zongHeArr;
    NSArray *_priceArr;
    NSArray *_sale_numArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self setDropDownMenu];
    // Do any additional setup after loading the view.
    [self setTableView];
    _pageNo = 0;
//    flag = true;
    [self loadData:nil shopType:nil];
}
-(void)setNav{
    SecondNavView *navView = [[[NSBundle mainBundle]loadNibNamed:@"SecondNavView" owner:self options:nil]lastObject];
    navView.frame = CGRectMake(0, 0, screen_width,64);
    [navView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
}

-(void)setDropDownMenu{
    _zongHeArr = @[@"综合",@"由高到低",@"由低到高"];
    _priceArr = @[@"价格",@"由高到低",@"由低到高"];
    _sale_numArr = @[@"销量",@"由高到低",@"由低到高"];
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    _menu = menu;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, screen_width, screen_height - 108) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    //下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNo = 0;
        [_dataArr removeAllObjects];
        [self LoadNextPageData];
    }];
    //上拉加载
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageNo +=1;
        [self LoadNextPageData];
    }];

    
    [self.view addSubview:_tableView];
}

-(void)LoadNextPageData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"cat_id"] = _catId;
    parameters[@"pageNo"] = [NSString stringWithFormat:@"%d",_pageNo];
    parameters[@"pageSize"] = @"10";
    [ZMCHttpTool postWithUrl:FBShopShangPinUrl parameters:parameters success:^(id responseObject) {
        NSLog(@"=====%@",responseObject);
        // 此处应为responseObject[@"data"]下面具体的cell项 这样好遍历
        NSArray * tempArr = responseObject[@"data"];
        [_dataArr addObjectsFromArray:tempArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [self endRefresh];
        });
    } failure:^(NSError *error) {
    }];
}

-(void)endRefresh{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}


-(void)loadData: (NSString *) upOrDown shopType:(NSString *) type{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"cat_id"] = _catId;
    if (type && upOrDown) {
        parameters[type] = upOrDown;
    }
    parameters[@"pageNo"] = @"0";
    parameters[@"pageSize"] = @"10";
     [ZMCHttpTool postWithUrl:FBShopShangPinUrl parameters:parameters success:^(id responseObject) {
         NSLog(@"=====%@",responseObject);
         _dataArr =  [[NSMutableArray alloc] init];;
         // 此处应为responseObject[@"data"]下面具体的cell项 这样好遍历
         NSArray * tempArr = responseObject[@"data"];
         [_dataArr addObjectsFromArray:tempArr];
         [_tableView reloadData];
     } failure:^(NSError *error) {
     }];
}

#pragma tableView 的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *cellIndetif = @"secondCell";
    SecondDetailCell *secondCell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
    if (!secondCell) {
        secondCell = [[[NSBundle mainBundle]loadNibNamed:@"SecondDetailCell" owner:self options:nil]lastObject];
    }
    [secondCell.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,_dataArr[indexPath.row][@"goods_thumb"]]] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    secondCell.titleLabel.text = _dataArr[indexPath.row][@"goods_name"];
//NSNumber *saleNum = _dataArr[indexPath.row][@"saleNum"];
    secondCell.comentNumLabel.text = [NSString stringWithFormat:@"%@条评论",_dataArr[indexPath.row][@"comment_info"][@"num"]];
    secondCell.priceLabel.text  = [NSString stringWithFormat:@"￥%@元",_dataArr[indexPath.row][@"shop_price"]];
    
    
    NSString *pingfen = _dataArr[indexPath.row][@"star"];
    UIImageView *starImg = [[UIImageView alloc]initWithFrame:secondCell.star_ImgView.frame];
    starImg.contentMode = UIViewContentModeScaleAspectFill;
    starImg.clipsToBounds = YES;
    starImg.image = [UIImage imageNamed:@"star"];
    CGRect starFrame = starImg.frame;
    starFrame.size.width = starFrame.size.width*(pingfen.doubleValue/5);
    starImg.frame =starFrame;
    [secondCell.contentView addSubview:starImg];
    secondCell.pingfenLabel.text  = [NSString stringWithFormat:@"%.lf星",pingfen.doubleValue];
    return secondCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc]init];
    shopDetailVC.goodsId = _dataArr[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

#pragma DOPDropDownMenuDataSource

-(NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 3;
}

-(NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    return 3;
}

-(NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    if (indexPath.column == 0) {
        return _zongHeArr[indexPath.row];
    }
    else if (indexPath.column == 1) {
        return _priceArr[indexPath.row];
    }
    else {
        return _sale_numArr[indexPath.row];
    }
}
#pragma DOPDropDownMenuDelegate 

-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    [_dataArr removeAllObjects];
    
    switch (indexPath.column) {
            case 0:
            //点击了综合类
            switch (indexPath.row) {
                case 0:
                    //综合
                    [self loadData:nil shopType:nil];
                    break;
                case 1:
                    //由高到低
                    [self loadData:@"up_down" shopType:@"zonghe"];
                    break;
                case 2:
                    //由低到高
                    [self loadData:@"down_up" shopType:@"zonghe"];
                    break;
                default:
                    break;
            }
            break;
            
            case 1:
            //点击了价格
            switch (indexPath.row) {
                case 0:
                    //综合
                    [self loadData:nil shopType:nil];
                    break;
                case 1:
                    //由高到低
                    [self loadData:@"up_down" shopType:@"price"];
                    break;
                case 2:
                    //由低到高
                    [self loadData:@"down_up" shopType:@"price"];
                    break;
                default:
                    break;
            }
            break;
            
            case 2:
            //点击了销量
            switch (indexPath.row) {
                case 0:
                    //综合
                    [self loadData:nil shopType:nil];
                    break;
                case 1:
                    //由高到低
                    [self loadData:@"up_down" shopType:@"Sale_num"];
                    break;
                case 2:
                    //由低到高
                    [self loadData:@"down_up" shopType:@"Sale_num"];
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
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
