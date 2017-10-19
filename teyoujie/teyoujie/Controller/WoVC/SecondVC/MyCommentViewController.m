//
//  MyCommentViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/6.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "MyCommentViewController.h"
#import "UIViewAdditions.h"
#import "SMPagerTabView.h"
#import "ViewUtil.h"
//#import "MyCommentListViewController.h"
#import "MyCommentHeadView.h"
#import "MyCommentCellView.h"
#import "MyCommentViewForCellCentent.h"
#import "UILabel+StringFrame.h"
@interface MyCommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyCommentViewController{
    UITableView *_tableView;
    NSInteger _cellHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTableView];
    [self addHeadView];
    
    _cellHeight = 0;
 }
-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}
-(void)addHeadView{
    MyCommentHeadView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"MyCommentHeadView" owner:self options:nil]lastObject];
    [headerView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    headerView.backgroundColor = [UIColor yellowColor];
    headerView.frame = CGRectMake(0, 0, screen_width, 165);
    _tableView.tableHeaderView = headerView;
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
    
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_cellHeight) {
        return _cellHeight;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetif = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetif];
       
    }
    UIView *outView = [[UIView alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyCommentCellView *view = [[[NSBundle mainBundle]loadNibNamed:@"MyCommentCellView" owner:self options:nil]lastObject];
    //view.backgroundColor = [UIColor yellowColor];
    view.frame = CGRectMake(0, 0, screen_width, 100);
    [outView addSubview:view];
//    [cell.contentView addSubview:outView];
    UILabel *contentLabel = [[UILabel alloc]init];
    NSString *content = @"qwgquwdgqiuwdqiuwdquwdgquigdqiu";
    CGSize size = [contentLabel boundingRectWithString:content withSize:CGSizeMake(screen_width-120, 400) withFont:15];
    contentLabel.frame = CGRectMake(view.userName.frame.origin.x, view.frame.origin.y+110, size.width, size.height);
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.text = @"qwgquwdgqiuwdqiuwdquwdgquigdqiu";
    contentLabel.numberOfLines = 0;
    [outView addSubview:contentLabel];
//    [cell.contentView addSubview:contentLabel];
    MyCommentViewForCellCentent *cellContentView = [[[NSBundle mainBundle]loadNibNamed:@"MyCommentViewForCellCentent" owner:self options:nil]lastObject];
    cellContentView.frame = CGRectMake(view.userName.frame.origin.x, contentLabel.frame.origin.y +size.height, screen_width-120, 60);
    [outView addSubview:cellContentView];

//    [cell.contentView addSubview:cellContentView];
    UILabel *seeLabel = [[UILabel alloc]init];
    seeLabel.frame = CGRectMake(view.userName.frame.origin.x, cellContentView.origin.y +70, 120, 20);
    seeLabel.text = @"浏览113";
    [outView addSubview:seeLabel];
    _cellHeight = seeLabel.origin.y +30;
    [cell.contentView addSubview:outView];
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
