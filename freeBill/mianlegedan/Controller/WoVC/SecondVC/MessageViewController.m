//
//  messageViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/5.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "MessageViewController.h"
#import "ViewUtil.h"
#import "MessageTableViewCell.h"
@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MessageViewController{
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    self.navigationController.navigationBarHidden = false;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setTableView];
}

-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetif = @"messageCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageTableViewCell" owner:self options:nil]lastObject];
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
