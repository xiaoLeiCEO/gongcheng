//
//  OrderResultViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/12.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "OrderResultViewController.h"
#import "ViewUtil.h"
#import "OrderResult_View.h"
//#import "OrderDetailViewController.h"
#import "ZMCHttpTool.h"
#import "CommonUrl.h"
#import "UserBean.h"
#import "UIImageView+WebCache.h"
@interface OrderResultViewController (){
    NSMutableArray *dataArr;
    OrderResult_View *orderView;
}

@end

@implementation OrderResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    orderView = [[[NSBundle mainBundle]loadNibNamed:@"OrderResult_View" owner:self options:nil]lastObject];
    orderView.frame = CGRectMake(0, 0, screen_width, 400);
    [orderView.goodsThumbImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,_goodsThumb]]];
    orderView.goodsNameLb.text = _goodsName;
    [orderView.finish_Btn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
//    [orderView.orderDetailBtn addTarget:self action:@selector(orderDetailAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self.view addSubview:orderView];
}
//获取票券
-(void)loadData{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"token"] = [UserBean getUserDictionary][@"token"];
    parameters[@"order_sn"] = _orderNo;
    [ZMCHttpTool postWithUrl:FBGetTicket parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            dataArr = responseObject[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                orderView.ticketNumLb.text = [dataArr componentsJoinedByString:@","];
                orderView.QRCodeImg.image = [self createQRCodeImg:dataArr size:orderView.QRCodeImg.frame.size];
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

//-(void)orderDetailAction{
//    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc]init];
//    [self.navigationController pushViewController:orderDetailVC animated:YES];
//}

-(void)finishAction{
   
    [self dismissViewControllerAnimated:YES completion:nil];
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
