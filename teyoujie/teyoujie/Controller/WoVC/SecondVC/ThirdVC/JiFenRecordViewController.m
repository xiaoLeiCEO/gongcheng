//
//  JiFenRecordViewController.m
//  teyoujie
//
//  Created by 王长磊 on 2017/6/29.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "JiFenRecordViewController.h"
#import "UserBean.h"
#import "ZMCHttpTool.h"
#import "ViewUtil.h"
#import "CommonUrl.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
@interface JiFenRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataSource;
    NSInteger page;
}
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation JiFenRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
    [self loadData:@"1"];
}
-(void)createUI{
    page = 1;
    _dataSource = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataSource removeAllObjects];
        page = 1;
        [self loadData:@"1"];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page += 1;
        [self loadData:[NSString stringWithFormat:@"%ld",(long)page]];
    }];
    [self.view addSubview:_tableView];
}

-(void)loadData:(NSString *)pages{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"token"] = [UserBean getUserDictionary][@"token"];
    parameters[@"page"] = pages;
    parameters[@"page_ize"] = @"10";
    [ZMCHttpTool postWithUrl:FBjiFenDuiHuanJiLu parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            NSMutableArray *arr = responseObject[@"data"];
            [_dataSource addObjectsFromArray:arr];
            [_tableView reloadData];
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_header endRefreshing];
        }
        else {
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _dataSource[indexPath.row][@"goods_name"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,_dataSource[indexPath.row][@"goods_thumb"]]] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
