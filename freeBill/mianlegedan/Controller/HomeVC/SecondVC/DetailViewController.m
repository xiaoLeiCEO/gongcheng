    //
//  DetailViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/7.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewUtil.h"
#import "DetailTableHeaderView.h"
#import "DetailCellForaddr.h"
#import "DetailForCommentCell.h"
#import "DetailCommentForHeaderView.h"
#import "UILabel+StringFrame.h"
#import "CommitOrderViewController.h"
#import "AddGoodsCarView.h"
#import "ZMCHttpTool.h"
#import "CommentTableViewController.h"
#import "DetailForH5ViewController.h"
#import "UserBean.h"
@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DetailViewController{
    UILabel *_titleLabel;
    UITableView *_tableView;
    NSInteger _height;
    NSArray *_dataArr;
    NSArray *_taocanArr;
    NSArray *_commentArr;
    NSString *_mobliePhone;
    UIWebView *_webView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setNav];
    [self initViews];
    
    [self loadData];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.

    }


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: YES];
    self.navigationController.navigationBarHidden = YES;
}


-(void)loadData{
  
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
   
    parameters[@"goodsId"] = _goodsId;
    parameters[@"pageNo"] = @"1";
    parameters[@"pageSize"] = @"10";
    parameters[@"shopId"] = _fuwuId;
    [ZMCHttpTool postForJavaWithUrl:FBFuWuDetailUrl parameters:parameters success:^(id responseObject) {
        NSLog(@"=======%@",responseObject);
        _dataArr = responseObject[@"data"][@"list"];
        _taocanArr = responseObject[@"data"][@"taocan"];
        [self initViews];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


-(void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    backView.backgroundColor = RGB(250, 250, 250);
    //并不知道干啥用的
//        //下划线
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, screen_width, 0.5)];
//    lineView.backgroundColor = RGB(192, 192, 192);
//    [backView addSubview:lineView];
    
    //返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 30, 23, 23);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-105, 30, 220, 30)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    //    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"详情";
    [backView addSubview:_titleLabel];
    
//    //收藏
//    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    collectBtn.frame = CGRectMake(screen_width-10-23-10-23, 30, 22, 22);
//    [collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
////    [collectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//    [backView addSubview:collectBtn];
//    
//    //分享
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.frame = CGRectMake(screen_width-10-23, 30, 22, 22);
//    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
////    [shareBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//    [shareBtn addTarget:self action:@selector(OnShareBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:shareBtn];
    [self.view addSubview:backView];
    
}

-(void)initViews{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    
//    _tableView.hidden = YES;
    
    DetailTableHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"DetailTableHeaderView" owner:self options:nil]lastObject];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMGURL,_dataArr[0][@"goodsImg"]];
    [headerView.detailImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"热门"]];
    headerView.priceLabel.text = _dataArr[0][@"shopPrice"];
    
    [headerView.saleNumLabel setTitle: [NSString stringWithFormat:@"已售：%@",_dataArr[0][@"saleNum"]] forState:UIControlStateNormal];
    
//    NSString *marketPrice =  _dataArr[0][@"marketPrice"];
//    [ViewUtil strikeLineForLabel:headerView.menshiPriceLabel];
    
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:marketPrice];
//    [attr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, marketPrice.length)];
//    [attr addAttribute:NSStrikethroughColorAttributeName value:[ViewUtil hexColor:@"#999999"] range:NSMakeRange(0, marketPrice.length)];
//    [headerView.menshiPriceLabel setAttributedText:attr];
//    headerView.menshiPriceLabel.text = marketPrice;
    
    
    headerView.detailName.text = _dataArr[0][@"GoodsName"];
    headerView.titleLabel.text = _dataArr[0][@"GoodsBrief"];
    [headerView.buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableHeaderView = headerView;
    [self.view addSubview:_tableView];
}
-(void)buyAction{
    if ([UserBean isSignIn]) {
        CommitOrderViewController *commitOrderVC = [[CommitOrderViewController alloc]init];
        commitOrderVC.fuwuName = _dataArr[0][@"GoodsName"];
        commitOrderVC.goodsThumb = _goodsThumb;
        commitOrderVC.price = _dataArr[0][@"shopPrice"];
        commitOrderVC.goodsId = _dataArr[0][@"GoodsId"];
        [self.navigationController pushViewController:commitOrderVC animated:YES];
        
    }
    else{
        [self showAlert:@"请登录"];
    }
    

}


-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)OnBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
   // [self.navigationController popToRootViewControllerAnimated:YES];
}
    //分享响应事件
-(void)OnShareBtn:(UIButton *)sender{
    
    
    //    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAPPKEY shareText:@"测试高仿分享" shareImage:[UIImage imageNamed:@"bg_customReview_image_default"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToQzone, nil] delegate:self];
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAPPKEY shareText:@"在美国被禁的网站，请偷偷看" shareImage:[UIImage imageNamed:@"m1.jpg"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatTimeline,UMShareToWechatSession, nil] delegate:self];
    
    
    //1.微信分享
    //1.1使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
    //    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"分享内嵌文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
    //        if (response.responseCode == UMSResponseCodeSuccess) {
    //            NSLog(@"分享成功！");
    //        }
    //    }];
    //1.2设置分享内容跳转
    //    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.fityun.cn/";
    //1.3设置朋友圈跳转title
    //    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"微信朋友圈title";
    //1.4分享类型，分享app
    //    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    
    
    
    
}
    
#pragma tableView 的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    else {
        return 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentif = @"detailcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentif];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailcell"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
             cell.textLabel.text = @"商家信息";
        } else {
            
            UIView *addr_view = [[UIView alloc]init];
            DetailCellForaddr *addrView = [[[NSBundle mainBundle]loadNibNamed:@"DetailCellForaddr" owner:self options:nil]lastObject];
            addrView.shopName.text = _dataArr[0][@"shopName"];
            addrView.addrLabel.text = _dataArr[0][@"address"];
            addrView.locationLabel.text = _location;
            addrView.locationLabel.text = @"8.5km";
            _mobliePhone = _dataArr[0][@"mobilePhone"];
            addrView.frame = CGRectMake(0, 0, screen_width, 80);
            [addr_view addSubview:addrView];
            [cell.contentView addSubview:addr_view];
        }
       
    }
//    else if(indexPath.section == 1){
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"套餐";
//            cell.textLabel.textColor = [ViewUtil hexColor:@"#666666"];
//            cell.textLabel.font = [UIFont systemFontOfSize:15];
//        } else if (indexPath.row == 1){
//            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
//            titleLabel.textAlignment = NSTextAlignmentCenter;
//            titleLabel.font = [UIFont systemFontOfSize:15];
//            [cell.contentView addSubview:titleLabel];
//            if (_taocanArr.count >0) {
//                titleLabel.text = _taocanArr[0][@"tName"];
//            }
//            
//
//            //cell.textLabel.text = _taocanArr[0][@"tName"];
//        } else if (indexPath.row == 2){
//            if (_taocanArr.count >0) {
//                cell.textLabel.text = _taocanArr[0][@"tDesc"];
//            }
//            
//        }
////        else {
////            cell.textLabel.text = @"查看图文详情";
////            cell.textLabel.textColor = [ViewUtil hexColor:@"#ed6d4d"];
////            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
////        }
//    }
    else if(indexPath.section == 1){
//            if (![_dataArr[0][@"addTime"] isEqualToString:@" "]) {
                static NSString *cellIdentif2 = @"commentCell";
                UITableViewCell *commentForCell = [tableView dequeueReusableCellWithIdentifier:cellIdentif2];
                if (!commentForCell) {
                    commentForCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentif2];
                }
                UIView *cellView = [[UIView alloc]init];
                DetailForCommentCell *commentView = [[[NSBundle mainBundle]loadNibNamed:@"DetailForCommentCell" owner:self options:nil]lastObject];
        
//                        commentView.timeLabel.text = _dataArr[0][@"addTime"];
                //commentView.
//                commentView.timeLabel.text = [ViewUtil timeWithTimeIntervalString:_dataArr[0][@"addTime"]];
        
                commentView.frame = CGRectMake(0, 0, screen_width, 60);
                UILabel *nameLabel = [[UILabel alloc]init];
                NSString *nameStr = _dataArr[0][@"userName"];
                CGSize size = [nameLabel boundingRectWithString:nameStr withSize:CGSizeMake(screen_width -120, 17) withFont:14];
                nameLabel.text = _dataArr[0][@"userName"];
                nameLabel.frame = CGRectMake(60, 15, size.width +10, 17);
                nameLabel.font = [UIFont systemFontOfSize:13];
                [commentView addSubview:nameLabel];
                UIImageView *vipImgView = [[UIImageView alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x +nameLabel.frame.size.width +10, 20, 15, 15)];
                [commentView addSubview: vipImgView];
                [cellView addSubview:commentView];
                UILabel *commentLabel = [[UILabel alloc]init];
                NSString *commentStr = _dataArr[0][@"pinglun"];
                CGSize size2 = [commentLabel boundingRectWithString: commentStr withSize:CGSizeMake(screen_width - 40, 500) withFont:13];
                commentLabel.frame = CGRectMake(50, 50, screen_width - 60, size2.height);
                commentLabel.font = [UIFont systemFontOfSize:13];
                commentLabel.text = _dataArr[0][@"pinglun"];
                [cellView addSubview:commentLabel];
                
                [commentForCell.contentView addSubview:cellView];
                
                _height = commentLabel.frame.origin.y +size2.height +10;
                return commentForCell;
 
//            }
    } else if(indexPath.section == 2){
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 500)];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        NSString *urlStr = [NSString stringWithFormat:@"http://mall.dashixian.com/hd/fuwu_goods_xiangqingh5.php?id=%@", _goodsId];
        NSURL *url = [NSURL URLWithString:urlStr];
        
        // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        // 3. 发送请求给服务器
        [_webView loadRequest:request];
        [cell.contentView addSubview:_webView];
    }
    
    return cell;
}
    
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 80;
        }
    } else if(indexPath.section == 1){
        if (_height) {
            return _height;
        } else{
            return 0.1;
        }
        
    }
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
         DetailCommentForHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"DetailCommentForHeaderView" owner:self options:nil ]lastObject];
        //NSNumber *commentNum = _dataArr[0][@"allPinglun"];
        // 此处缺少评分
        headerView.allCommentNum.text =[NSString stringWithFormat:@"查看全部评论%@",_dataArr[0][@"allPinglun"]];
       // NSNumber *pingfen = _dataArr[0][@"pingfen"];
        
        UIImageView *starImg = [[UIImageView alloc]initWithFrame:headerView.star_an_ImgView.frame];
        starImg.contentMode = UIViewContentModeScaleAspectFill;
        starImg.clipsToBounds = YES;
        starImg.image = [UIImage imageNamed:@"star"];
        CGRect starFrame = starImg.frame;
        //starFrame.size.width = starFrame.size.width*(pingfen.doubleValue/5);
        starFrame.size.width = starFrame.size.width*(0.6);
        starImg.frame = starFrame;
        [headerView addSubview:starImg];
        headerView.pingfenLabel.text  = [NSString stringWithFormat:@"%@分",@"3"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height);
        [button addTarget:self action:@selector(commentListAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        return headerView;
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, screen_width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    return lineView;
}
-(void)commentListAction{
    CommentTableViewController *commentVC = [[CommentTableViewController alloc]init];
     commentVC.goodsId=_goodsId;
    [self.navigationController pushViewController:commentVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 44;
    }
    return  1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== 1) {
        // 此处固定，后期修改
        if (indexPath.row ==3) {
            DetailForH5ViewController *H5VC = [[DetailForH5ViewController alloc]init];
            H5VC.goodsId = _goodsId;
            [self.navigationController pushViewController:H5VC animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
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
