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
#import "DetailViewController.h"
#import "IndexViewController.h"
#import "SecondDetailCell.h"
#import "ShopDetailViewController.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@end

@implementation SearchViewController{
    UITableView *_tableView;
    SearchHeaderView *_headerView;
    NSMutableArray *searchArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    searchArr = [[NSMutableArray alloc]init];
    
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
    _headerView.frame = CGRectMake(0, 0, screen_width, 64);
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isZhiYing){
    return 100;
    }
    else {
    return 120;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (_isZhiYing){
        NSLog(@"%@", searchArr);
        NSLog(@"%@", searchArr[indexPath.row][@"goods_thumb"]);
        static NSString *cellIndetif = @"secondCell";
        SecondDetailCell *secondCell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
        if (!secondCell) {
            secondCell = [[[NSBundle mainBundle]loadNibNamed:@"SecondDetailCell" owner:self options:nil]lastObject];
        }
        [secondCell.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,searchArr[indexPath.row][@"goods_thumb"]]] placeholderImage:[UIImage imageNamed:@"placeImg"]];
        secondCell.titleLabel.text = searchArr[indexPath.row][@"goods_name"];
        //NSNumber *saleNum = _dataArr[indexPath.row][@"saleNum"];
        secondCell.comentNumLabel.text = [NSString stringWithFormat:@"%@条评论",searchArr[indexPath.row][@"comment_info"][@"num"]];
        secondCell.priceLabel.text  = [NSString stringWithFormat:@"￥%@元",searchArr[indexPath.row][@"shop_price"]];
        
        
        NSString *pingfen = searchArr[indexPath.row][@"star"];
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
    else {
        static NSString *cellIndentifier = @"searchcell";
        ShopRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[ShopRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        
        if(searchArr.count!=0){
            ShopInfoModel *recommend = searchArr[indexPath.row];
            [cell setShopRecM:recommend];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isZhiYing){
        ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc]init];
        shopDetailVC.goodsId = searchArr[indexPath.row][@"goods_id"];
        IndexViewController *indexVC = (IndexViewController*)[self presentingViewController];
        [self dismissViewControllerAnimated:YES completion:^{
            [indexVC.selectedViewController pushViewController:shopDetailVC animated:YES];
            
        }];
    }
    else {
        DetailViewController *detailVC = [[DetailViewController alloc]init];
        ShopInfoModel *shopModel = searchArr[indexPath.row];
        detailVC.fuwuId = shopModel.shop_id;
        detailVC.goodsId = shopModel.goods_id;
        detailVC.goodsThumb = shopModel.goods_thumb;
        
        IndexViewController *indexVC = (IndexViewController*)[self presentingViewController];
        [self dismissViewControllerAnimated:YES completion:^{
            [indexVC.selectedViewController pushViewController:detailVC animated:YES];
            
        }];
    }

}

#pragma mark - 实现取消按钮的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"您点击了取消按钮");
    [searchBar resignFirstResponder]; // 丢弃第一使用者
}
#pragma mark - 实现键盘上Search按钮的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    if (_isZhiYing) {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        parameters[@"search_type"] = @"1";
        parameters[@"content"] = searchBar.text;
        parameters[@"token"] = [UserBean getUserDictionary][@"token"];
        [ZMCHttpTool postWithUrl:FBZhiYingSearchUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]){
                    searchArr = responseObject[@"data"];
                
                [_tableView reloadData];
            }
            else {
                
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else{
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        parameters[@"search_type"] = @"1";
        parameters[@"content"] = searchBar.text;
        parameters[@"token"] = [UserBean getUserDictionary][@"token"];
        [ZMCHttpTool postWithUrl:FBFuWuSearchUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]){
                NSArray *arr = [[NSArray alloc]init];
                arr = responseObject[@"data"];
                for (NSDictionary *dic in arr){
                    ShopInfoModel *shopInfoModel = [[ShopInfoModel alloc]init];
                    [shopInfoModel setValuesForKeysWithDictionary:dic];
                    [searchArr addObject:shopInfoModel];
                }
                [_tableView reloadData];
            }
            else {
                
            }
        } failure:^(NSError *error) {
            
        }];    }
    

}


//#pragma mark - 实现监听开始输入的方法
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    
//    return YES;
//}
//
////- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
////    NSLog(@"%@", searchText);
////    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
////    parameters[@"search_type"] = @"2";
////    parameters[@"content"] = searchText;
////    parameters[@"token"] = [UserBean getUserDictionary][@"token"];
////    [ZMCHttpTool postWithUrl:FBFuWuSearchUrl parameters:parameters success:^(id responseObject) {
////        NSLog(@"%@", responseObject);
////        if ([responseObject[@"status"] isEqualToString:@"1"]){
////            
////        }
////        else {
////            
////        }
////    } failure:^(NSError *error) {
////        
////    }];
////}
//
//#pragma mark - 实现监听输入完毕的方法
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
//    // 此处搜索历史记录
//    NSLog(@"输入完毕");
//
//    return YES;
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
