//
//  AutherAbleViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/12.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "AutherAbleViewController.h"
#import "ViewUtil.h"
@interface AutherAbleViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation AutherAbleViewController{
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"实名认证";
    [self setTableView];
}

-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    //    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width -250, 10, 220, 21)];
    messageLabel.textAlignment = NSTextAlignmentRight;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.contentView addSubview:messageLabel];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"姓名：";
        messageLabel.text = @"hahahhaahha";
    } else  if (indexPath.row == 1) {
        cell.textLabel.text = @"身份证号：";
        messageLabel.text = @"1111112516271361823";
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
