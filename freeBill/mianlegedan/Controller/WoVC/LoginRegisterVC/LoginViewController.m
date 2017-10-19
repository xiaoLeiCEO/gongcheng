//
//  LoginViewController.m
//  playboy
//
//  Created by 张梦川 on 16/1/6.
//  Copyright © 2016年 yaoyu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PswdReSetViewController.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
#import "ViewUtil.h"
@interface LoginViewController ()<UITextFieldDelegate,registerDelegate,mainViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *forgetpwdBtn;



@end

@implementation LoginViewController{
   
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"登录";
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
    [rightButton setFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton addTarget:self
                    action:@selector(registerAction)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem.accessibilityElementsHidden = YES;
    if ([UserBean getAccount]){
        self.phoneNum.text = [UserBean getAccount];
    }
        _password.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
-(void)goback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"isLogin"] = @"isLogin";
        //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
-(void)alertMsg:(NSString *)message{
    
    [self alertMessage:message];
}

-(void)doclick{
    
}

// 登录
- (IBAction)loginAction:(id)sender {
    [self giveUpFrist];
    if ([self docheck] == true) {
        // 网络请求
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"user_name"] = self.phoneNum.text;
        //NSString *pwd = [self md5:self.password.text];
        parameters[@"password"] = self.password.text;
        NSString *sign = [ViewUtil getSign:parameters];
        parameters[@"sign"] = sign;
        [self startHUDmessage:@"正在登录..."];
        [ZMCHttpTool postWithUrl:FBLoginUrl parameters:parameters success:^(id responseObject) {
            [self stopHUDmessage];
            NSDictionary *dict = responseObject;
            NSLog(@"%@",dict);
            if ([dict[@"status"] isEqualToString:@"1"]) {
               
                [UserBean setSignIn:YES];
                [UserBean setAccount:self.phoneNum.text];
                [UserBean setPassword:self.password.text];
                NSDictionary *tokenData = dict[@"data"];
                [UserBean setUserDictionary:tokenData];
                [self dismissViewControllerAnimated:YES completion:nil];
//                self.tabBarController.selectedIndex = 0;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"showWoVC" object:nil];
            } else {
                [self alert:dict[@"msg"]];
            }
           
           
        } failure:^(NSError *error) {
            [self showHUDmessage:@"网络错误"];
        }];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_loginBtn setBackgroundColor:[ViewUtil hexColor:@"#ed6d4d"]];
}



-(BOOL)docheck{
    NSLog(@"%@", self.phoneNum.text);
    if (![self isEmpty:self.phoneNum.text]) {
            if (![self isEmpty:self.password.text]) {
                return YES;
            } else {
                [self alert:@"密码为空!"];
                return NO;
            }
                    
    } else {
        [self alert:@"手机号为空"];
        return NO;
    }
}

-(void)registerAction{
    
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    registerVC.regDelegate = self;
    [self.navigationController pushViewController:registerVC animated:YES];
    
}


- (IBAction)forgetPwdAction:(id)sender {
    PswdReSetViewController *pwdReSetVC = [[PswdReSetViewController alloc]init];
    [self.navigationController pushViewController:pwdReSetVC animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self giveUpFrist];
}

-(void)giveUpFrist{
    
    [self.phoneNum resignFirstResponder];
    [self.password resignFirstResponder];
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
