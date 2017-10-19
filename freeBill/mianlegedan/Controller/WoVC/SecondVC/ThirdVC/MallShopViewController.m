//
//  MallShopViewController.m
//  freeBill
//
//  Created by 张梦川 on 17/4/4.
//  Copyright © 2017年 mianlegedan. All rights reserved.
//

#import "MallShopViewController.h"
#import "ViewUtil.h"
#import "MallShopCell.h"
@interface MallShopViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MallShopViewController{
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"积分商城";
    [self setTableView];
}
-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetif = @"mallShopCell";
    MallShopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MallShopCell" owner:self options:nil]lastObject];
    }
    return cell;
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
