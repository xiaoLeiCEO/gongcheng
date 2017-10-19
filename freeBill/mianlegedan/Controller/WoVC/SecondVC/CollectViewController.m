//
//  collectViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/5.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "CollectViewController.h"
#import "ViewUtil.h"
#import "UserBean.h"
#import "ZMCHttpTool.h"
#import "SecondDetailCell.h"
#import "ShopDetailViewController.h"
@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CollectViewController{
    UITableView *_tableView;
    NSMutableArray *dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    self.navigationController.navigationBarHidden = false;
    [self setTableView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];

}

-(void)loadData{
        //
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"act"] = @"chakan";
            parameters[@"token"] = [UserBean getUserDictionary][@"token"];
            [ZMCHttpTool postWithUrl:FBCollectUrl parameters:parameters success:^(id responseObject) {
                NSDictionary *dict = responseObject;
                if ([dict[@"status"]  isEqualToString:@"2"]) {
                    //
                    dataSource = [[NSMutableArray alloc]init];
                    NSMutableArray * tempArr = dict[@"data"];
                    [dataSource addObjectsFromArray:tempArr];
                    NSLog(@"%@",dataSource);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_tableView reloadData];
                    });
                }else {
                    NSLog(@"%@",dict[@"msg"]);
    
                }
            } failure:^(NSError *error) {
            }];

}


-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetif = @"detailCell";
    SecondDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SecondDetailCell" owner:self options:nil]lastObject];
    }
    [cell.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,dataSource[indexPath.row][@"goods_thumb"]]] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    cell.titleLabel.text = dataSource[indexPath.row][@"goods_name"];
    //以后等后台不为null时在调用
//    cell.comentNumLabel.text = [NSString stringWithFormat:@"%@条评论",dataSource[indexPath.row][@"allPinglun"]];
    cell.comentNumLabel.text = @"0条评论";

    cell.priceLabel.text  = [NSString stringWithFormat:@"￥%@元",dataSource[indexPath.row][@"shop_price"]];
    NSString *pingfen = dataSource[indexPath.row][@"pingfen"];
    
    UIImageView *starImg = [[UIImageView alloc]initWithFrame:cell.star_ImgView.frame];
    starImg.contentMode = UIViewContentModeScaleAspectFill;
    starImg.clipsToBounds = YES;
    starImg.image = [UIImage imageNamed:@"star"];
    CGRect starFrame = starImg.frame;
    starFrame.size.width = starFrame.size.width*(pingfen.doubleValue/5);
    starImg.frame =starFrame;
    [cell.contentView addSubview:starImg];
    cell.pingfenLabel.text  = [NSString stringWithFormat:@"%.lf分",pingfen.doubleValue];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc]init];
    shopDetailVC.goodsId = dataSource[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"act"] = @"shanchu";
    parameters[@"token"] = [UserBean getUserDictionary][@"token"];
    parameters[@"goods_id"] = dataSource[indexPath.row][@"goods_id"];
    [ZMCHttpTool postWithUrl:FBCollectUrl parameters:parameters success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"status"]  isEqualToString:@"4"]) {
            //删除收藏成功
            NSLog(@"%@",dict[@"msg"]);
        }else {
            NSLog(@"%@",dict[@"msg"]);
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    // 删除模型
    [dataSource removeObjectAtIndex:indexPath.row];
    
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

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
