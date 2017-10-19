//
//  SearchViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/18.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHeaderView.h"
#import "ViewUtil.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
#import "CommonUrl.h"
#import "ShopRecommendCell.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@end

@implementation SearchViewController{
    UITableView *_tableView;
    SearchHeaderView *_headerView;
    NSArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self loadHeaderView];
    self.view.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
    [self setTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
-(void)loadHeaderView{
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"SearchHeaderView" owner:self options:nil]lastObject];
    _headerView.search.delegate = self;
    [_headerView.search becomeFirstResponder];
    [_headerView.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
}
-(void)cancelAction{
    [_headerView.search resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setTableView{
    // 加载个人中心页面
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,screen_width , screen_height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

#pragma tabelView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (!_dataArr) {
         return @"历史记录";
    } else {
        return @"";
    }
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

#pragma mark - 实现取消按钮的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"您点击了取消按钮");
    [searchBar resignFirstResponder]; // 丢弃第一使用者
}
#pragma mark - 实现键盘上Search按钮的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mingCheng"] = _headerView.search.text;
    parameters[@"pageNo"] = @"1";
    parameters[@"pageSize"] = @"10";
   
//    parameters[@"Lng"] =  [UserBean getLongitude];
//    parameters[@"Lat"] = [UserBean getLatitude];
    [ZMCHttpTool postForJavaWithUrl:FBFUWUNearLikeSearchUrl parameters:parameters success:^(id responseObject) {
        _dataArr = responseObject[@"data"][@"shangpin"];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"searchcell";
    ShopRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[ShopRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    //            if(_recommendArray.count!=0){
    //                ShopInfoModel *recommend = _recommendArray[indexPath.row-1];
    //                [cell setShopRecM:recommend];
    //            }
    // 测试用，要修改
    ShopInfoModel *recommend = _dataArr[indexPath.row];
    [cell setShopRecM:recommend];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - 实现监听开始输入的方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    return YES;
}
#pragma mark - 实现监听输入完毕的方法
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    // 此处搜索历史记录
    NSLog(@"输入完毕");
    return YES;
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
