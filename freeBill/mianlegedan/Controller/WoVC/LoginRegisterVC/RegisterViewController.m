//
//  RegisterViewController.m
//  playboy
//
//  Created by 张梦川 on 16/1/7.
//  Copyright © 2016年 yaoyu. All rights reserved.
//

#import "RegisterViewController.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
#import "ProtocolViewController.h"
#import "ViewUtil.h"
@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *testCode;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;
@property (weak, nonatomic) IBOutlet UIButton *testCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UILabel *secondText;

@end

@implementation RegisterViewController{
    int _secondsCountDown;
    NSTimer *_countDownTimer;
    NSString *_testCodeText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    // Do any additional setup after loading the view from its nib.
    self.phoneNum.delegate = self;
    self.password.delegate = self;
    self.testCode.delegate = self;
}

// 验证码
- (IBAction)testCodeAction:(id)sender {
    [self giveUpFirst];
//    if (WIDTH == 320) {
//        if (self.view.frame.origin.y < 64) {
//            [self animateTextField:self.phoneNum up:NO];
//        }
//    }
   
    if (![self isEmpty:self.phoneNum.text]) {
        if ([ViewUtil valiMobile:_phoneNum.text] == true) {
            _secondsCountDown = 60;

            _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(cancelTimer) userInfo:nil repeats:true];
            [_countDownTimer fire];
            [self.testCodeBtn setBackgroundImage:[UIImage imageNamed:@"code2"] forState:UIControlStateNormal];
            self.testCodeBtn.enabled = false;
            
             NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
           
            parameters[@"mobile"] = self.phoneNum.text;
            // 1注册 ，2忘记密码
            NSString *send_type = @"1";
            parameters[@"send_type"] = send_type;
            NSString *sign = [ViewUtil getSign:parameters];
            parameters[@"sign"] = sign;
            [ZMCHttpTool postWithUrl:FBSmsCode parameters:parameters success:^(id responseObject) {
                
            } failure:^(NSError *error) {
                NSLog(@"=======%@",error);
                
            }];
            
        } else {
            [self alert:@"手机号格式不正确!"];
        }
        
    } else {
        [self alert:@"手机号不能为空!"];
    }
    
}

-(void) cancelTimer{
    _secondsCountDown = _secondsCountDown-1;
    [self.testCodeBtn setTitle:@"重新获取(     )" forState:UIControlStateNormal];
    self.secondText.text = [NSString stringWithFormat:@"%d",_secondsCountDown];
    if (_secondsCountDown == 0) {
        [self.testCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.secondText.text = @"";
        [self.testCodeBtn setBackgroundImage:[UIImage imageNamed:@"code"]forState:UIControlStateNormal];
        [_countDownTimer invalidate];
        self.testCodeBtn.enabled = true;
        
    }
}

- (void)giveUpFirst{
    [self.phoneNum resignFirstResponder];
    [self.password resignFirstResponder];
    [self.passwordAgain resignFirstResponder];
    [self.testCode resignFirstResponder];
}
// 注册
- (IBAction)registerAction:(id)sender {
    [self giveUpFirst];
//    if (WIDTH == 320) {
//        if (self.view.frame.origin.y < 64) {
//            [self animateTextField:self.password up:NO];
//        }
//    }
    
    if ([self docheck] == true) {
       NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = self.phoneNum.text;
        //NSString *pwd = [self md5:self.password.text];
        parameters[@"password"] = self.password.text;
        parameters[@"verify"] = self.testCode.text;
        parameters[@"confirm_password"] = self.password.text;
        NSString *sign = [ViewUtil getSign:parameters];
        parameters[@"sign"] = sign;
        __weak RegisterViewController *weakSelf = self;
        [ZMCHttpTool postWithUrl:FBRegUrl parameters:parameters success:^(id responseObject) {
            NSDictionary *dict = responseObject;
            if([dict[@"status"] isEqualToString:@"111"]){
              [self alert:dict[@"msg"]];
            } else if([dict[@"status"] isEqualToString:@"1"]){
                [weakSelf showHUDmessage:@"注册成功!"];
             
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [weakSelf.navigationController popViewControllerAnimated:YES];
//                    [UserBean setAccount:self.phoneNum.text];
//                    [UserBean setSignIn:YES];
//                    [UserBean setUserDictionary:dict[@"data"]];
                });
            }

        } failure:^(NSError *error) {
            NSLog(@"======%@",error);
            [weakSelf showHUDmessage:@"网络错误"];
        }];

    }
}
-(BOOL)docheck{
  
        if (![self isEmpty:self.phoneNum.text]) {
            
            if ([ViewUtil valiMobile:_phoneNum.text] == YES) {
                if (![self isEmpty:self.testCode.text]) {
                   
                        if (![self isEmpty:self.password.text]) {
                            if (self.password.text.length < 6) {
                                [self alert:@"密码不能少于6位!"];
                                return NO;
                            } else {
                                if(![self isEmpty:self.passwordAgain.text]){
                                    if ([self.password.text isEqualToString:self.passwordAgain.text]) {
                                        return YES;
                                    } else {
                                        [self alert:@"两次输入密码不一致!"];
                                        return NO;
                                    }
                                } else {
                                    [self alert:@"请再次输入密码!"];
                                    return NO;
                                    
                                }
                                return YES;
                            }
                            
                        } else {
                            [self alert:@"密码不能为空!"];
                            return NO;
                            
                        }
                    
                } else {
                    [self alert:@"验证码为空!"];
                    return NO;
                }
                
            } else {
                [self alert:@"手机号格式不正确!"];
                return NO;
            }
        } else{
           [self alert:@"手机号不能为空!"];
            return NO;
        }
   
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (WIDTH == 320) {
//        if (self.view.frame.origin.y == 64) {
//            [self animateTextField: textField up:YES];
//        }
//    }
    [_commitBtn setBackgroundColor:[ViewUtil hexColor:@"#ed6d4d"]];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (WIDTH == 320) {
//        if (self.view.frame.origin.y < 64) {
//            [self animateTextField: textField up:NO];
//        }
//    }
   
    [textField endEditing:YES];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (WIDTH == 320) {
//        if (self.view.frame.origin.y < 64) {
//            [self animateTextField: self.password up:NO];
//        }
//    }
    
    [self giveUpFirst];
}

// 协议
- (IBAction)protocolAction:(id)sender {
    ProtocolViewController *proVC = [[ProtocolViewController alloc]init];
    [self.navigationController pushViewController:proVC animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
   
    
    if (_secondsCountDown != 0) {
        _secondsCountDown = 0;
        [self.testCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.secondText.text = @"";
        [self.testCodeBtn setBackgroundImage:[UIImage imageNamed:@"code"]forState:UIControlStateNormal];
        [_countDownTimer invalidate];
        self.testCodeBtn.enabled = true;
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
