//
//  MyInfoViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/12.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "MyInfoViewController.h"
#import "ViewUtil.h"
#import "AutherAbleViewController.h"
#import "AutherUnAbleViewController.h"
#import "PassWordResetViewController.h"
#import "UserBean.h"
#import "EditUserInfoViewController.h"
@interface MyInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyInfoViewController{
    UITableView *_tableView;
    NSDictionary *_userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    self.navigationController.navigationBarHidden = false;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightButton setFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton addTarget:self
                    action:@selector(editUserInfoAction)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reSetNickName:) name:@"editUserInfo" object:nil];

    self.navigationItem.rightBarButtonItem = rightItem;
    [self setTableView];
}
-(void)reSetNickName:(NSNotification *)dict{
    [_tableView reloadData];
}
-(void)editUserInfoAction{
    EditUserInfoViewController *editVC = [[EditUserInfoViewController alloc]init];
    editVC.nickName = _userInfo[@"nick_name"];
    [self.navigationController pushViewController:editVC animated:YES];
}
-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width -230, 10, 200, 21)];
    messageLabel.textAlignment = NSTextAlignmentRight;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.contentView addSubview:messageLabel];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height -1, screen_width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lineView];
    _userInfo = [UserBean getUserInfo];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"昵称";
        messageLabel.text = _userInfo[@"nick_name"];
    } else  if (indexPath.row == 1) {
        cell.textLabel.text = @"实名认证";
        if (![_userInfo[@"id_card"] isEqualToString:@""]) {
            messageLabel.text = @"已认证";
        } else {
            messageLabel.text = @"未认证";
        }
        
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"修改登录密码";
        messageLabel.text = @"";
    } else  if (indexPath.row == 3) {
        cell.textLabel.text = @"邀请码";
        messageLabel.text = _userInfo[@"rcode"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 1) {
        if (![_userInfo[@"id_card"] isEqualToString:@""]) {
            AutherAbleViewController *autherVC = [[AutherAbleViewController alloc]init];
            [self.navigationController pushViewController:autherVC animated:YES];
        } else{
            AutherUnAbleViewController *autherVC = [[AutherUnAbleViewController alloc]init];
            [self.navigationController pushViewController:autherVC animated:YES];
        }
        
    } else if(indexPath.row == 2){
        PassWordResetViewController *pwdVC = [[PassWordResetViewController alloc]init];
        [self.navigationController pushViewController:pwdVC animated:YES];
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
