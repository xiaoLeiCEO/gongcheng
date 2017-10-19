//
//  NearListViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/4.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "NearListViewController.h"
#import "NearHeadView.h"
#import "ViewUtil.h"
#import "NearListTableViewCell.h"
#import "NearHeadView.h"
#import "NearHotBtnView.h"
#import "ShopDetailViewController.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
@interface NearListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NearListViewController{
    UITableView *_tableView;
    NSInteger _hotBtnCount;
    NSArray *_hotArr;
//    NSString *_fuId;
    NSMutableArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHotTitleAction:) name:@"nearListHot" object:nil];
//    NSString *lat = [UserBean getLatitude];
//    if (lat) {
//      [self loadData:@"508"];
//    }
    [self loadData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)setHotTitleAction:(NSNotification *)data{
    _hotArr = data.userInfo[@"list"][@"list"];
//    _fuId = data.userInfo[@"fuid"];
    [self setheadView];
}


-(void)loadData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"cat_id"] = @"508";
    parameters[@"lng"] =@"116.66.214784";
    parameters[@"lat"] =@"39.8929006122";
    [ZMCHttpTool postWithUrl:FBFUWUNearListUrl parameters:parameters success:^(id responseObject) {
        NSLog(@"======%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
        _dataArr = [[NSMutableArray alloc]init];
        _dataArr = responseObject[@"data"];
        NSLog(@"%@",_dataArr);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        }
        else{
            //获取附近商品列表失败
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}




-(void)loadTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-145) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     [self.view addSubview:_tableView];
}
-(void)setheadView{
    NearHeadView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"NearHeadView" owner:self options:nil]lastObject];
    headerView.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
    int height = 30;
   
    _hotBtnCount = _hotArr.count;
    
    height = height *(ceilf(_hotBtnCount*0.25)) + 10*(ceilf(_hotBtnCount*0.25)+1);

    
    headerView.frame = CGRectMake(0, 0, screen_width,height);
    int margin = 10;
    int Ymargin = 10;
    int btnWidth = (screen_width-50) *0.25;
     int rows = 1;
    for (int i = 0; i<_hotBtnCount; i++) {
        NearHotBtnView *btn = [[[NSBundle mainBundle]loadNibNamed:@"NearHotBtnView" owner:self options:nil]lastObject];
        rows = ceilf(i*0.25);
        if (i==0) {
            rows = 1;
            btn.hotBtn.selected = YES;
        }
        if (i>0 && (i%4)== 0) {
            rows =ceilf((i +1)*0.25);
        }

        btn.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
        [btn.hotBtn setTitle:_hotArr[i][@"name"] forState:UIControlStateNormal];
        [btn.hotBtn addTarget:self action:@selector(hotAction:) forControlEvents:UIControlEventTouchUpInside];
        NSNumber *ziid = _hotArr[i][@"ziid"];
        btn.hotBtn.tag = ziid.integerValue;
        btn.hotBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.hotBtn.showsTouchWhenHighlighted = YES;
        btn.frame = CGRectMake(10+(btnWidth+margin) *(i%4), Ymargin+(30 +Ymargin)*(rows-1), btnWidth, 30);
        [headerView addSubview:btn];
    }
    _tableView.tableHeaderView = headerView;
}

//热门按钮点击事件
-(void)hotAction:(UIButton *)sender{
    for (int i=0;i<_hotArr.count;i++) {
        NSNumber *ziid = _hotArr[i][@"ziid"];
        UIButton *btn = [self.view viewWithTag:ziid.integerValue];
        if (sender == [self.view viewWithTag:ziid.integerValue]){
                sender.selected = YES;
//            NSString *catId = _hotArr[i][@"fuid"];
            //今后会用到catId 目前先用固定值
            [self loadData];
        }
        else{
        btn.selected = NO;
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
    
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 5)];
    footerView.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
    return footerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 5)];
    //    headerView.backgroundColor = RGB(239, 239, 244);
    headerView.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentif = @"nearCell";
    NearListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentif];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NearListTableViewCell" owner:self options:nil ]lastObject];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMGURL,_dataArr[indexPath.row][@"shop_logo"]];
    [cell.fuwuImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    cell.fuwuName.text = _dataArr[indexPath.row][@"shop_name"];
      NSString *pingfen = _dataArr[indexPath.row][@"pingfen"];
    NSInteger fenshu = pingfen.integerValue;
    cell.fuwu_PingFen.text = [NSString stringWithFormat: @"%.1ld分",(long)fenshu];
    cell.fuwuContentLabel.text = _dataArr[indexPath.row][@"GoodsBrief"];
//    cell.numLbael.text = [NSString stringWithFormat:@"%@人消费",_dataArr[indexPath.row][@"saleNum"]];
//    NSString *string = _dataArr[indexPath.row][@"juli"];
//    string =[string substringToIndex:4];
//    cell.locationLabel.text = [NSString stringWithFormat:@"%@m",string];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"goodsId"] = _dataArr[indexPath.row][@"goods_id"];
    dict[@"shopId"] = _dataArr[indexPath.row][@"shop_id"];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"TODetailView" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
   /* ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc]init];
    [self.navigationController pushViewController:shopDetailVC animated:YES];
    */
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
