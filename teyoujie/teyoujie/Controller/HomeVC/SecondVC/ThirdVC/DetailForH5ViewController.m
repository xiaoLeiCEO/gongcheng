//
//  DetailForH5ViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/28.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "DetailForH5ViewController.h"

@interface DetailForH5ViewController ()

@end

@implementation DetailForH5ViewController{
    UIWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden = false;
    self.title = @"图文详情";
    [self loadData];
}
-(void)loadData{
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
     NSString *urlStr = [NSString stringWithFormat:@"http://mall.dashixian.com/hd/fuwu_goods_xiangqingh5.php?id=%@", _goodsId];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
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
