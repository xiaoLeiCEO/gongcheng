//
//  SettingViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/5.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "SettingViewController.h"
#import "ViewUtil.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
#import "LoginViewController.h"
#import "MyInfoViewController.h"
#import "AboutViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SettingViewController{
    UITableView *_tableView;
    UIButton *_logoutBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = RGB(243, 243, 243);
    self.navigationController.navigationBarHidden = false;

    [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [self setTableView];
    // Do any additional setup after loading the view.
}
-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGB(243, 243, 243);
    [self.view addSubview:_tableView];
}

#pragma tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
         return 50;
    }
    else {
        return 0.1;
    }
}
-(void)logoutAction{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *dict = [UserBean getUserDictionary];
    parameters[@"token"] = dict[@"token"];
        __weak SettingViewController *weakSelf = self;
        [ZMCHttpTool postWithUrl:FBLogoutUrl parameters:parameters success:^(id responseObject) {
            [UserBean setSignIn:false];
            [UserBean setUserInfo:nil];
            [self showHUDmessage:@"已退出登录"];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.tabBarController.selectedIndex = 0;
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
                nav.title = @"登录";
                [weakSelf presentViewController:nav animated:YES completion:nil];
                [self.navigationController popToRootViewControllerAnimated:NO];

            });
            
        } failure:^(NSError *error) {
            
        }];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 50)];
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutBtn.frame  = CGRectMake(10, 10, screen_width-20, 40);
        _logoutBtn.backgroundColor = [UIColor whiteColor];
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        footerView.backgroundColor = RGB(243, 243, 243);
        [footerView addSubview:_logoutBtn];
        return footerView;

    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 0.5)];
    return lineView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *cellIdenti = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenti];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenti];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //显示最右边的箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;     if (indexPath.section == 0) {
        if (indexPath.row == 0) {
             cell.textLabel.text = @"个人信息";
        }

    } else {
        cell.textLabel.text = @"关于我们";

    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            MyInfoViewController *myInfoVC = [[MyInfoViewController alloc]init];
            [self.navigationController pushViewController:myInfoVC animated:YES];
            
        }
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        
        AboutViewController *aboutVC= [[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
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
