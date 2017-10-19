//
//  PassWordResetViewController.m
//  playboy
//
//  Created by 张梦川 on 16/1/26.
//  Copyright © 2016年 yaoyu. All rights reserved.
//

#import "PassWordResetViewController.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
#import "ViewUtil.h"
@interface PassWordResetViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation PassWordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _oldpwd.delegate = self;
    self.title = @"修改密码";
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_resetBtn setBackgroundColor:[ViewUtil hexColor:@"#ed6d4d"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self giveUpFist];
}
-(void)giveUpFist{
    [self.oldpwd resignFirstResponder];
    [self.newpwd resignFirstResponder];
    [self.aginNewpwd resignFirstResponder];
}
- (IBAction)sumitAction:(id)sender {
    [self giveUpFist];
    [self check];
    NSDictionary *dict = [UserBean getUserDictionary];
    if (dict == nil) {
        [self alert:@"您还没有登录!"];
        return;
    } else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSDictionary *dict = [UserBean getUserDictionary];
        parameters[@"token"] = dict[@"token"];
        parameters[@"act"] = @"edit_pass";
        parameters[@"old_password"] = self.oldpwd.text;
        parameters[@"password"] = self.newpwd.text;
         parameters[@"confirm_password"] = self.aginNewpwd.text;
        parameters[@"sign"] = [ViewUtil getSign:parameters];
        [ZMCHttpTool postWithUrl:FBResetUrl parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"status"] isEqualToString:@"1"]) {
                [self showHUDmessage:responseObject[@"msg"]];
            } else {
                [self alert:responseObject[@"msg"]];
                
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

-(void)check{
    
    if ([self isEmpty:_oldpwd.text]) {
        [self alert:@"请输入密码"];
    } else {
        if ([self isEmpty:_newpwd.text]) {
             [self alert:@"请输入密码"];
        } else {
            if (![_newpwd.text isEqualToString:_aginNewpwd.text]) {
                [self alert:@"新密码不一致!"];
            }
        }
    }
}
@end
