//
//  MallViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/7.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "MallViewController.h"
#import "ViewUtil.h"
#import "MallBtnView.h"
#import "MallViewCell.h"
#import "UILabel+StringFrame.h"
#import "ZMCHttpTool.h"
#import "UserBean.h"
#import "MallShopViewController.h"
#import "MallRuleViewController.h"
#import "MBProgressHUD.h"
@interface MallViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation MallViewController{
    UITableView *_tableView;
    NSArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTableView];
    self.title = @"积分商城";
    self.navigationController.navigationBarHidden = false;
    [self setTableViewHeaderView];
    [self loadData];
}
-(void)loadData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"act"] =@"list";
    [ZMCHttpTool postWithUrl:FBjifenMailListUrl parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        _dataArr = responseObject[@"data"][@"list"];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}
-(void)setTableViewHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 70)];
    // 第一个
    MallBtnView *btn1 = [[[NSBundle mainBundle]loadNibNamed:@"MallBtnView" owner:self options:nil]lastObject];
    btn1.frame = CGRectMake(0, 0, screen_width*0.33-1, 60);
    UILabel *goldLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, btn1.mallLabel.frame.origin.y-5, btn1.frame.size.width-20, 30)];
    btn1.mallLabel.text = @"";
    [btn1.mallLabel removeFromSuperview];
    btn1.mallIamgeView.image = [UIImage imageNamed:@"大积分"];
    goldLabel.textAlignment = NSTextAlignmentCenter;
    goldLabel.font = [UIFont systemFontOfSize:13];
    NSDictionary *dict =  [UserBean getUserInfo];
    NSString *str = [NSString stringWithFormat:@"%@积分",dict[@"jifen"]];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:13.0]
     
                          range:NSMakeRange(0, str.length-2)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(0, str.length -2)];
    
    goldLabel.attributedText = AttributedStr;
    
    [btn1 addSubview:goldLabel];
    [headerView addSubview:btn1];
    // 加一条线
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(btn1.frame.size.width +1, 10, 1, 40)];
    lineView1.backgroundColor = [ViewUtil hexColor:@"#d3d3d3"];
    [headerView addSubview:lineView1];
    // 第二个
    MallBtnView *btn2 = [[[NSBundle mainBundle]loadNibNamed:@"MallBtnView" owner:self options:nil]lastObject];
    btn2.frame = CGRectMake(screen_width*0.33 +2, 0, screen_width*0.33-2, 60);
    btn2.mallIamgeView.image = [UIImage imageNamed:@"兑换记录"];
    btn2.mallLabel.text = @"兑换记录";
    UIButton *btn2ForBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2ForBtn.frame = btn2.frame;
    btn2ForBtn.tag = 501;
    [btn2ForBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:btn2];
    [headerView addSubview:btn2ForBtn];
    // 第二条线
    UIView *lineView2= [[UIView alloc]initWithFrame:CGRectMake(btn2.frame.origin.x + btn2.frame.size.width +1, 10, 1, 40)];
    lineView2.backgroundColor = [ViewUtil hexColor:@"#d3d3d3"];
    [headerView addSubview:lineView2];
    // 第三个
    MallBtnView *btn3 = [[[NSBundle mainBundle]loadNibNamed:@"MallBtnView" owner:self options:nil]lastObject];
    btn3.mallLabel.text = @"积分规则";
    btn3.mallIamgeView.image = [UIImage imageNamed:@"积分规则"];
    btn3.frame = CGRectMake(screen_width*0.33*2 +2, 0, screen_width*0.33-1, 60);
    UIButton *btn3ForBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3ForBtn.frame = btn3.frame;
    btn3ForBtn.tag = 502;
    [btn3ForBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
   
  
    [headerView addSubview:btn3];
    [headerView addSubview:btn3ForBtn];
    UIView *header_fooerView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, screen_width, 10)];
    header_fooerView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:header_fooerView];
    _tableView.tableHeaderView = headerView;
}

-(void)btnAction:(UIButton *)btn {
//    if (btn.tag == 501) {
//        MallShopViewController *mallSHopVC = [[MallShopViewController alloc]init];
//        [self.navigationController pushViewController:mallSHopVC animated:YES];
//        
//    } else {
//        MallRuleViewController *mallRuleVC = [[MallRuleViewController alloc]init];
//        [self.navigationController pushViewController:mallRuleVC animated:YES];
//    }
    
    MBProgressHUD *prohud = [[MBProgressHUD alloc]initWithView:self.view];
    prohud.mode = MBProgressHUDModeText;
    prohud.label.text = @"敬请期待";
    [self.view addSubview:prohud];
    [prohud showAnimated:YES];
    [prohud hideAnimated:YES afterDelay:1];
}

#pragma tableView 的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return screen_height - 200;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      static NSString *cellIndetif = @"Mallcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetif];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetif];
    }
//    UIView *leftView = [[UIView alloc]init];
//     MallViewCell *leftCell = [[[NSBundle mainBundle]loadNibNamed:@"MallViewCell" owner:self options:nil]lastObject];
//    
//    leftCell.frame = CGRectMake(0, 0, screen_width *0.5-1, 150);
//    UILabel *titelabel = [[UILabel alloc]init];
//    NSString *titleStr = @"iphone7 Plus";
//    CGSize size = [titelabel boundingRectWithString:titleStr withSize:CGSizeMake(screen_width *0.5-100, 20) withFont:16];
//    titelabel.frame = CGRectMake(10, 10, size.width+40, size.height);
//    titelabel.text =titleStr;
//    titelabel.font = [UIFont systemFontOfSize:16];
//    [leftCell addSubview:titelabel];
//    UIImageView *leftCellImg = [[UIImageView alloc]init];
//    leftCellImg.frame = CGRectMake(titelabel.frame.size.width +12, 10, 50, 20) ;
//    [leftCell addSubview:leftCellImg];
//    UILabel *goldNumLabel = [[UILabel alloc]init];
//    NSString *goldNumStr =@"1000";
//    CGSize size2 =[goldNumLabel boundingRectWithString:goldNumStr withSize:CGSizeMake(screen_width*0.5-125, 20) withFont:13];
//    
//    goldNumLabel.frame = CGRectMake(screen_width *0.5-size2.width-5, leftCell.mallCellImageView.frame.origin.y +50, size2.width, 20);
//    [leftCell addSubview:goldNumLabel];
//    goldNumLabel.text = goldNumStr;
//    goldNumLabel.font = [UIFont systemFontOfSize:13];
//    goldNumLabel.textColor = [UIColor redColor];
//    UIImageView *tipImg = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width*0.5-size2.width-25, goldNumLabel.frame.origin.y, 20, 20)];
//    [leftCell addSubview:tipImg];
//    [leftView addSubview:leftCell];
//    [cell.contentView addSubview:leftView];
//
//    UIView *cellLineVeiw = [[UIView alloc]initWithFrame:CGRectMake(screen_width*0.5+1, 0, 0.5, 150)];
//    cellLineVeiw.backgroundColor = [UIColor lightGrayColor];
//    [cell.contentView addSubview:cellLineVeiw];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    @"右边有数据，就是说数据条数为奇数的时候"
//    if (true) {
//        UIView *rightView = [[UIView alloc]init];
//        MallViewCell *rightCell = [[[NSBundle mainBundle]loadNibNamed:@"MallViewCell" owner:self options:nil]lastObject];
//        
//        rightCell.frame = CGRectMake(screen_width *0.5+2, 0, screen_width *0.5-2, 150);
//        UILabel *titelabel = [[UILabel alloc]init];
//        NSString *titleStr = @"iphone7 Plus";
//        CGSize size = [titelabel boundingRectWithString:titleStr withSize:CGSizeMake(screen_width *0.5-100, 20) withFont:16];
//        titelabel.frame = CGRectMake(10, 10, size.width+40, size.height);
//        titelabel.text =titleStr;
//        titelabel.font = [UIFont systemFontOfSize:16];
//        [rightCell addSubview:titelabel];
//        UIImageView *rightCellImg = [[UIImageView alloc]init];
//        rightCellImg.frame = CGRectMake(titelabel.frame.size.width +12, 10, 50, 20) ;
//        [rightCell addSubview:leftCellImg];
//        UILabel *goldNumLabel = [[UILabel alloc]init];
//        NSString *goldNumStr =@"1000";
//        CGSize size2 =[goldNumLabel boundingRectWithString:goldNumStr withSize:CGSizeMake(screen_width*0.5-125, 20) withFont:13];
//        
//        goldNumLabel.frame = CGRectMake(screen_width *0.5-size2.width-5, rightCell.mallCellImageView.frame.origin.y +50, size2.width, 20);
//        [rightCell addSubview:goldNumLabel];
//        goldNumLabel.text = goldNumStr;
//        goldNumLabel.font = [UIFont systemFontOfSize:13];
//        goldNumLabel.textColor = [UIColor redColor];
//        UIImageView *tipImg = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width*0.5-size2.width-25, goldNumLabel.frame.origin.y, 20, 20)];
//        [rightCell addSubview:tipImg];
//        [rightView addSubview:rightCell];
//        [cell.contentView addSubview:rightView];
//    }
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    UICollectionView *collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-200) collectionViewLayout:flowLayout];

    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    //注册Cell，必须要有
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [cell.contentView addSubview:collectionView];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
    /**
     *  分割线顶头
     */
-(void)viewDidLayoutSubviews
    {
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
    {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, screen_width-30, 40)];
    label.text = @"积分好礼";
    label.font = [UIFont systemFontOfSize:16];
    [view addSubview:label];
    UIView *cellLineVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 39, screen_width, 1)];
    cellLineVeiw.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:cellLineVeiw];
    return view;

    
}
    //定义每个Cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(screen_width *0.5-1,150);
    return size;
}
    //UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
    {
        UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    //定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
    {
        return _dataArr.count;
    }
    //定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
    {
        return 1;
    }
    
    //每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        static NSString * CellIdentifier = @"UICollectionViewCell";
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
            UIView *leftView = [[UIView alloc]init];
             MallViewCell *leftCell = [[[NSBundle mainBundle]loadNibNamed:@"MallViewCell" owner:self options:nil]lastObject];
        
            leftCell.frame = CGRectMake(0, 0, screen_width *0.5-1, 150);
            UILabel *titelabel = [[UILabel alloc]init];
            NSString *titleStr = _dataArr[indexPath.row][@"goods_name"];
            //CGSize size = [titelabel boundingRectWithString:titleStr withSize:CGSizeMake(screen_width *0.5-100, 20) withFont:16];
            titelabel.frame = CGRectMake(10, 10, screen_width *0.5 -10, 40);
            titelabel.text =titleStr;
            titelabel.font = [UIFont systemFontOfSize:16];
            [leftCell addSubview:titelabel];
        NSString *urlString =[NSString stringWithFormat:@"%@%@",IMGURL,_dataArr[indexPath.row][@"goods_thumb"]];
        [leftCell.mallCellImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeImg"]];
            UILabel *goldNumLabel = [[UILabel alloc]init];
            NSString *goldNumStr =_dataArr[indexPath.row][@"goods_number"];
            CGSize size2 =[goldNumLabel boundingRectWithString:goldNumStr withSize:CGSizeMake(screen_width*0.5-125, 20) withFont:13];
        
            goldNumLabel.frame = CGRectMake(screen_width *0.5-size2.width-5, leftCell.mallCellImageView.frame.origin.y +50, size2.width, 20);
            [leftCell addSubview:goldNumLabel];
            goldNumLabel.text = goldNumStr;
            goldNumLabel.font = [UIFont systemFontOfSize:13];
            goldNumLabel.textColor = [UIColor redColor];
            UIImageView *tipImg = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width*0.5-size2.width-25, goldNumLabel.frame.origin.y, 20, 20)];
            tipImg.image = [UIImage imageNamed:@"小积分"];
            [leftCell addSubview:tipImg];
            [leftView addSubview:leftCell];
            [cell.contentView addSubview:leftView];
        
            UIView *cellLineVeiw = [[UIView alloc]initWithFrame:CGRectMake(screen_width*0.5, 0, 1, screen_width*0.5+1)];
            UIView *cellLineVeiwfooter = [[UIView alloc]initWithFrame:CGRectMake(0, 149, screen_width*0.5, 1)];
            cellLineVeiwfooter.backgroundColor = [ViewUtil hexColor:@"#d3d3d3"];
            cellLineVeiw.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
            [leftCell addSubview:cellLineVeiwfooter];
            [leftCell addSubview:cellLineVeiw];
            [cell.contentView addSubview:leftView];
        cell.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
        return cell;
    }
    //定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
        return UIEdgeInsetsMake(5, 0, 5, 0);//分别为上、左、下、右
    }
    //两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
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
