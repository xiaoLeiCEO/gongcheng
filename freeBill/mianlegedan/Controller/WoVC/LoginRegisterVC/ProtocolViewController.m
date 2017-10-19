//
//  ProtocolViewController.m
//  playboy
//
//  Created by 张梦川 on 16/1/13.
//  Copyright © 2016年 yaoyu. All rights reserved.
//

#import "ProtocolViewController.h"
#import "UILabel+StringFrame.h"
@interface ProtocolViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ProtocolViewController{
    CGSize _size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"用户协议";
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _size.height +20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    UILabel *label= [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14];
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"用户协议" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"%@",str);

    CGSize size = [label boundingRectWithString:str withSize:CGSizeMake(WIDTH - 20, MAXFLOAT)];
    _size = size;
    
    label.frame = CGRectMake(10, 10, WIDTH -20, size.height);
    label.text = str;
    label.numberOfLines = 0;
    
    [cell.contentView addSubview:label];
    return cell;
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
