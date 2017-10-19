//
//  AddressEditViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/15.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "AddressEditViewController.h"
#import "Picker_ForheadView.h"
#import "ViewUtil.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
@interface AddressEditViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *addrTextFild;
@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *detailAddr;

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UIImageView *tipImg;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@property (nonatomic,strong) UIPickerView* pick;
@end

@implementation AddressEditViewController {
    NSArray *_provinceArr;
    NSArray *_cityArr;
    NSArray *_districtArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建收货地址";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAddrAction)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self createUI];
    [self loadData];

    // Do any additional setup after loading the view from its nib.
    
}

-(void)createUI{
    _pick = [[UIPickerView alloc]init];
    _pick.dataSource = self;
    _pick.delegate = self;
    _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    Picker_ForheadView *doneToolbar = [[[NSBundle mainBundle]loadNibNamed:@"Picker_ForheadView" owner:self options:nil]lastObject];
    _addrTextFild.inputAccessoryView = doneToolbar;
    [doneToolbar.OKBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    _addrTextFild.inputView =_pick;
    _addrTextFild.tag = 2017;
    _addrTextFild.delegate = self;
}

-(BOOL)docheck{

    if ([_addrTextFild.text isEqualToString:@""]) {
        [self alert:@"请输入正确的地址"];
        return NO;
    } else if ([_userName.text isEqualToString:@""]){
        [self alert:@"请输入正确的收货人姓名"];
        return NO;
    } else if ([_detailAddr.text isEqualToString:@""]){
        [self alert:@"请输入正确的详细收货地址"];
        return NO;
    } else if ([ViewUtil valiMobile:_phoneNum.text] == NO){
        [self alert:@"请输入正确的手机号"];
        return NO;
    }
    return YES;
    
}

//保存收货地址
-(void)saveAddrAction{
    if ([self docheck]){
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"country"] = @"1";
    parameters[@"act"] = @"add_address";
    NSDictionary *dict = [UserBean getUserDictionary];
    parameters[@"token"] = dict[@"token"];
    parameters[@"province"] = _provinceArr[[_pick selectedRowInComponent:0]][@"region_id"];
    parameters[@"city"] = _cityArr[[_pick selectedRowInComponent:1]][@"region_id"];
    parameters[@"district"] = _districtArr[[_pick selectedRowInComponent:2]][@"region_id"];
    parameters[@"consignee"] = _userName.text;
    parameters[@"address"] = _detailAddr.text;
    parameters[@"mobile"] = _phoneNum.text;
    parameters[@"sign"] = [ViewUtil getSign:parameters];
    [ZMCHttpTool postWithUrl:FBAddressReceiveUrl parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    }
}

-(void)loadData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"city_version"] = @"1";
    if ([UserBean getCityList]) {
        _provinceArr = [UserBean getCityList];
        NSLog(@"%@",_provinceArr);
        _cityArr =  _provinceArr[0][@"city_list"];
        _districtArr = _cityArr[0][@"district_list"];
    }
    
    else {
        [ZMCHttpTool postWithUrl:FBAddressUrl parameters:parameters success:^(id responseObject) {
            _provinceArr = [[NSArray alloc]init];
            _cityArr = [[NSArray alloc]init];
            _districtArr = [[NSArray alloc]init];
            _provinceArr = responseObject[@"data"][@"province_list"];
            _cityArr =  _provinceArr[0][@"city_list"];
            _districtArr = _cityArr[0][@"district_list"];
            [UserBean setCityList:_provinceArr];
        } failure:^(NSError *error) {
            NSLog(@"");
        }];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [_addrTextFild resignFirstResponder];
     [_userName resignFirstResponder];
     [_detailAddr resignFirstResponder];
     [_phoneNum resignFirstResponder];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 2017) {
        _tipImg.image = [UIImage imageNamed:@"addr_tip_bottom"];
        CGRect frame = _tipImg.frame;
        frame.origin.x = screen_width - 30;
        frame.origin.y = _lineView.frame.origin.y +25;
        frame.size.width = 20;
        frame.size.height = 10;
        _tipImg.frame = frame;
        
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag == 2017) {
        _tipImg.image = [UIImage imageNamed:@"back_tip"];
        CGRect frame = _tipImg.frame;
        
        frame.origin.x = screen_width - 20;
        frame.origin.y = _lineView.frame.origin.y+20;
        frame.size.width = 10;
        frame.size.height = 20;
        _tipImg.frame = frame;
        
    }
    return YES;
}
-(void)okAction{
    _addrTextFild.text = [NSString stringWithFormat:@"%@%@%@",_provinceArr[[_pick selectedRowInComponent:0]][@"region_name"],_cityArr[[_pick selectedRowInComponent:1]][@"region_name"],_districtArr[[_pick selectedRowInComponent:2]][@"region_name"]];
    [_addrTextFild resignFirstResponder];
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return (screen_width - 30) * 0.33;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return  _provinceArr.count;
    } else if (component == 1){
        return _cityArr.count;
    } else {
        return _districtArr.count;
    }
    
   
   
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSDictionary *dict = _provinceArr[row];
        _cityArr = dict[@"city_list"];
        _districtArr = _cityArr[0][@"district_list"];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        [pickerView reloadComponent:1];
    }
   else if (component ==1){
        NSDictionary *cityDict = _cityArr[row];
       _districtArr  = cityDict[@"district_list"];
         [pickerView selectRow:0 inComponent:2 animated:NO];
    }
    [pickerView reloadComponent:2];
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return  _provinceArr[row][@"region_name"];;
    } else if(component == 1){
        return  _cityArr[row][@"region_name"];

    } else {
        return _districtArr[row][@"region_name"];
    }
    return nil;
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
