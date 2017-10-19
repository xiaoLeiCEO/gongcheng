//
//  PswdReSetViewController.m
//  playboy
//
//  Created by 张梦川 on 16/1/7.
//  Copyright © 2016年 yaoyu. All rights reserved.
//

#import "PswdReSetViewController.h"
#import "ZMCHttpTool.h"
#import "ViewUtil.h"
@interface PswdReSetViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

@property (weak, nonatomic) IBOutlet UITextField *testcode;
@property (weak, nonatomic) IBOutlet UIButton *testcodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *secondText;
@property (nonatomic, copy) NSString *smsCode;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTf;

@end

@implementation PswdReSetViewController{
    int _secondsCountDown;
    NSTimer *_countDownTimer;
    NSString *_testCodeText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    _phoneNum.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_commitBtn setBackgroundColor:[ViewUtil hexColor:@"#ed6d4d"]];
}
- (IBAction)testcodeAction:(id)sender {
    [self giveUpFirst];
    if (![self isEmpty:self.phoneNum.text]) {
        if ([ViewUtil valiMobile:_phoneNum.text] == true) {
            _secondsCountDown = 60;
            
            _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(cancelTimer) userInfo:nil repeats:true];
            [_countDownTimer fire];
            [self.testcodeBtn setBackgroundImage:[UIImage imageNamed:@"code2"] forState:UIControlStateNormal];
            self.testcodeBtn.enabled = false;
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"telephone"] = self.phoneNum.text;
            //            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            parameters[@"mobile"] = self.phoneNum.text;
            // 1注册 ，2忘记密码
            NSString *send_type = @"2";
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
    [self.testcodeBtn setTitle:@"重新获取(     )" forState:UIControlStateNormal];
    self.secondText.text = [NSString stringWithFormat:@"%d",_secondsCountDown];
    if (_secondsCountDown == 0) {
        [self.testcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.secondText.text = @"";
        [self.testcodeBtn setBackgroundImage:[UIImage imageNamed:@"code"]forState:UIControlStateNormal];
        [_countDownTimer invalidate];
        self.testcodeBtn.enabled = true;
        
    }
}

- (IBAction)retrievePasswordClick:(UIButton *)sender {
    [self giveUpFirst];

    if ([self docheck]) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"mobile"] = _phoneNum.text;
        parameters[@"act"] = @"reset_pass";
        parameters[@"verify"] = _testcode.text;
        parameters[@"password"] = self.passwordTf.text;
        parameters[@"confirm_password"] = self.rePasswordTf.text;
        parameters[@"sign"] = [ViewUtil getSign:parameters];
        [ZMCHttpTool postWithUrl:FBForgetUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject[@"msg"]);
            if ([responseObject[@"status"] isEqualToString:@"1"]) {
                [self showHUDmessage:responseObject[@"msg"]];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [self alert:responseObject[@"msg"]];
                
            }
            
        } failure:^(NSError *error) {
            // [self alert:error];
        }];
    }
}


-(BOOL)docheck{
    if (![self isEmpty:self.phoneNum.text]) {
        if ([ViewUtil valiMobile:_phoneNum.text] == true) {
            if (![self isEmpty:self.testcode.text]) {
                
                if (![self isEmpty:self.passwordTf.text]) {
                    if (self.passwordTf.text.length < 6) {
                        [self alert:@"密码长度不能少于6位!"];
                        return NO;
                    } else {
                        if (![self isEmpty:self.rePasswordTf.text]) {
                            if ([self.passwordTf.text isEqualToString:self.rePasswordTf.text]) {
                                return YES;
                            } else {
                                
                                [self alert:@"密码不一致!"];
                                return NO;
                            }
                            
                        } else {
                            [self alert:@"再次输入密码为空!"];
                            return NO;
                        }
                    }
                    
                } else {
                    [self alert:@"密码为空!"];
                    return NO;
                }
                
            } else {
                [self alert:@"验证码为空!"];
                return NO;
            }
            
        } else {
            [self alert:@"手机格式不正确!"];
            return NO;
        }
        
    } else {
        [self alert:@"手机号不能为空!"];
        return NO;
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self giveUpFirst];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_countDownTimer invalidate];
    
}
-(void)giveUpFirst{
    [self.phoneNum resignFirstResponder];
    [self.testcode resignFirstResponder];
    [self.passwordTf resignFirstResponder];
    [self.rePasswordTf resignFirstResponder];
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
