//
//  ReceiveAddressListViewController.m
//  teYouJie
//
//  Created by 王长磊 on 2017/5/6.
//  Copyright © 2017年 mianlegedan. All rights reserved.
//

#import "ReceiveAddressListViewController.h"
#import "CommonUrl.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
#import "AddressViewController.h"
#import "Picker_ForheadView.h"
#import "ViewUtil.h"

@interface ReceiveAddressListViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic,strong) UIPickerView* pick;

@end


@implementation ReceiveAddressListViewController{
    NSArray *_provinceArr;
    NSArray *_cityArr;
    NSArray *_districtArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"编辑收货地址";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAddrAction)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self loadData];
    [self createUI];
}

-(void)createUI {
    _pick = [[UIPickerView alloc]init];
    _pick.dataSource = self;
    _pick.delegate = self;
    _phoneNumTf.keyboardType = UIKeyboardTypeNumberPad;
    Picker_ForheadView *doneToolbar = [[[NSBundle mainBundle]loadNibNamed:@"Picker_ForheadView" owner:self options:nil]lastObject];
    _addressTf.inputAccessoryView = doneToolbar;
    [doneToolbar.OKBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    _addressTf.inputView =_pick;
    
    _consigneeTf.text = _consignee;
    _phoneNumTf.text = _phoneNum;
    _addressTf.text = _address;
    _detailAddressTf.text = _detailAddress;
}
-(void)okAction{
    _addressTf.text = [NSString stringWithFormat:@"%@%@%@",_provinceArr[[_pick selectedRowInComponent:0]][@"region_name"],_cityArr[[_pick selectedRowInComponent:1]][@"region_name"],_districtArr[[_pick selectedRowInComponent:2]][@"region_name"]];
    [_addressTf resignFirstResponder];
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

//编辑并保存收货地址
-(void)saveAddrAction{
    if ([self docheck]){
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"country"] = @"1";
        parameters[@"act"] = @"update";
        parameters[@"token"] = [UserBean getUserDictionary][@"token"];
        parameters[@"province"] = _provinceArr[[_pick selectedRowInComponent:0]][@"region_id"];
        parameters[@"city"] = _cityArr[[_pick selectedRowInComponent:1]][@"region_id"];
        parameters[@"district"] = _districtArr[[_pick selectedRowInComponent:2]][@"region_id"];
        parameters[@"address_id"] = _addressId;
        parameters[@"consignee"] = _consigneeTf.text;
        parameters[@"address"] = _detailAddressTf.text;
        parameters[@"mobile"] = _phoneNumTf.text;
        [ZMCHttpTool postWithUrl:FBAddressReceiveUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]) {
                //成功
                [self showAlert:responseObject[@"msg"]];
            }
            else {
                //失败
                [self showAlert:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

-(BOOL)docheck{
    
    if ([_addressTf.text isEqualToString:@""]) {
        [self showAlert:@"收货地址不能为空"];
        return NO;
    } else if ([_consigneeTf.text isEqualToString:@""]){
        [self showAlert:@"请输入正确的收货人姓名"];
        return NO;
    } else if ([_addressTf.text isEqualToString:@""]){
        [self showAlert:@"详细地址不能为空"];
        return NO;
    } else if ([ViewUtil valiMobile:_phoneNumTf.text] == NO){
        [self showAlert:@"请输入正确的手机号"];
        return NO;
    }
    return YES;
    
}

-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
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

