//
//  AutherUnAbleViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/12.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "AutherUnAbleViewController.h"
#import "ZMCHttpTool.h"
#import "ViewUtil.h"
#import "UserBean.h"
@interface AutherUnAbleViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTexField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation AutherUnAbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   self.title = @"实名认证";
    [_commitBtn addTarget:self action:@selector(validateAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)validateAction{
    [self validate];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_nameTexField resignFirstResponder];
    [_cardNumTextField resignFirstResponder];
}
-(void)docheck{
    if ([_nameTexField.text isEqualToString:@""]) {
        [self alert:@"姓名不能为空"];
        return;
    } else if([_cardNumTextField.text isEqualToString:@""] || _cardNumTextField.text.length < 18 ||_cardNumTextField.text.length > 18){
        [self alert:@"请输入有效的身份证号！"];
        return;
    }
}

-(void)validate{
    [self docheck];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *dict = [UserBean getUserDictionary];
    parameters[@"act"] = @"name_auth";
    parameters[@"token"] = dict[@"token"];
    parameters[@"id_card"] = _cardNumTextField.text;
    parameters[@"realname"] = _nameTexField.text;
    parameters[@"sign"] = [ViewUtil getSign:parameters];
    
    [ZMCHttpTool postWithUrl:FBNameCardUrl parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
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
