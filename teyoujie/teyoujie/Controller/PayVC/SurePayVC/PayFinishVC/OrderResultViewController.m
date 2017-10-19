//
//  OrderResultViewController.m
//  teyoujie
//
//  Created by 王长磊 on 2017/5/25.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "OrderResultViewController.h"
#import "ZMCHttpTool.h"
#import "CommonUrl.h"
#import "UserBean.h"
#import "UIImageView+WebCache.h"
#import "FreeQuanViewController.h"

@interface OrderResultViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataSource;
}
@property (weak, nonatomic) IBOutlet UIButton *jiFenLb;
@property (weak, nonatomic) IBOutlet UIImageView *goodsThumbImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLb;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImg;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLb;

@end

@implementation OrderResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishAction)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    [self loadData];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"64x1"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)createUI{
    _goodsNameLb.text = _goodsName;
    _orderNumLb.text = _orderNum;
    [_goodsThumbImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,_goodsThumb]]];
}

//获取票券
-(void)loadData{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"token"] = [UserBean getUserDictionary][@"token"];
    parameters[@"order_sn"] = _orderNum;
    
    [ZMCHttpTool postWithUrl:FBGetTicket parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            _dataSource = responseObject[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                _QRCodeImg.image = [self createQRCodeImg:_dataSource size:_QRCodeImg.frame.size];
                [_tableView reloadData];
            });
        }
        else{
            NSLog(@"%@", responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

-(UIImage *)createQRCodeImg:(NSArray *)arr size:(CGSize)size {
    NSString *str = [arr componentsJoinedByString:@"*"];
    UIImage *codeImage = nil;
    NSData *stringData = [str dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    CIImage *qrImage = colorFilter.outputImage;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return codeImage;
}

//完成按钮点击事件
-(void)finishAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//查看我的免单券按钮
- (IBAction)orderDetailBtnClick:(UIButton *)sender {
    FreeQuanViewController *freeQuanVC = [[FreeQuanViewController alloc]init];
    [self.navigationController pushViewController:freeQuanVC animated:YES];
}

//下拉按钮点击事件
- (IBAction)dropDownBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        CGRect tempRect = _tableView.frame;
        tempRect.size.height = 180;
        _tableView.frame = tempRect;
    }
    else {
        CGRect tempRect = _tableView.frame;
        tempRect.size.height = 44;
        _tableView.frame = tempRect;
    }
    [_tableView reloadData];
}

//UITableViewDelegate,UITableDataSource 的协议方法

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.detailTextLabel.text = _dataSource[indexPath.row];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dropDownBtn.selected){
        return _dataSource.count;
    }
    else {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
@end
