//
//  EditUserInfoViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/17.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "ZMCHttpTool.h"
#import "ViewUtil.h"
#import "UserBean.h"
@interface EditUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameTeid;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (nonatomic, copy) NSString *sexFlag;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTeid;

@end

@implementation EditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_sexBtn addTarget:self action:@selector(sexSelectAction) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nickNameTeid.text = self.nickName;
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton addTarget:self
                    action:@selector(editFinishAction)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
-(void)sexSelectAction{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"男" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _sexLabel.text = @"男";
        _sexFlag = @"1";
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"女" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        _sexLabel.text = @"女";
        _sexFlag = @"2";
    }]];
    //[alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNumTeid resignFirstResponder];
    [_nickNameTeid resignFirstResponder];
}
-(void)editFinishAction{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *dict = [UserBean getUserDictionary];
    parameters[@"act"] = @"edit_info";
    parameters[@"token"] = dict[@"token"];
    parameters[@"set_name"] = @"nick_name";
    parameters[@"set_value"] = _nickNameTeid.text;
    parameters[@"sign"] = [ViewUtil getSign:parameters];
    [self startHUDmessage:@"正在修改中..."];
   [ZMCHttpTool postWithUrl:FBEditUserInfoUrl parameters:parameters success:^(id responseObject) {
       parameters[@"set_name"] = @"sex";
       parameters[@"set_value"] = _sexFlag;
       parameters[@"sign"] = [ViewUtil getSign:parameters];
       [ZMCHttpTool postWithUrl:FBEditUserInfoUrl parameters:parameters success:^(id responseObject) {
           parameters[@"set_name"] = @"real_phone";
           parameters[@"set_value"] = _phoneNumTeid.text;
           parameters[@"sign"] = [ViewUtil getSign:parameters];
           [ZMCHttpTool postWithUrl:FBEditUserInfoUrl parameters:parameters success:^(id responseObject) {
               [self showHUDmessage:responseObject[@"msg"]];
               [self stopHUDmessage];
               [self.navigationController popViewControllerAnimated:YES];
               NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
               parameters[@"act"] = @"user_info";
               parameters[@"token"] = [UserBean getUserDictionary][@"token"];
               NSLog(@"%@",parameters[@"token"]);
               NSString *sign =  [ViewUtil getSign:parameters];
               parameters[@"sign"] = sign;
              
               [ZMCHttpTool postWithUrl: FBGetUserInfo parameters:parameters success:^(id responseObject) {
                   NSDictionary *userinfo = [[NSDictionary alloc]init];
                   
                   userinfo = responseObject[@"data"][@"info"];
                   [UserBean setUserInfo:userinfo];
                   //NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                   //dict[@"nickName"] = _nickNameTeid.text;
                   //创建通知
                   NSNotification *notification =[NSNotification notificationWithName:@"editUserInfo" object:nil userInfo:dict];
                   //通过通知中心发送通知
                   [[NSNotificationCenter defaultCenter] postNotification:notification];
               } failure:^(NSError *error) {
                   [self showHUDmessage:@"获取用户信息失败！"];
               }];
               
           } failure:^(NSError *error) {
               
           }];
           
       } failure:^(NSError *error) {
           
       }];
    } failure:^(NSError *error) {
       
   }];
    
    
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
