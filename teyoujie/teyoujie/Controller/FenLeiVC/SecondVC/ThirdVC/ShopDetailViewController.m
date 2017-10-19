//
//  ShopDetailViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/18.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "AdScrollView.h"
#import "ViewUtil.h"
#import "ShopDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+StringFrame.h"
#import "AddGoodsCarView.h"
#import "GTButtonTagsView.h"
#import "ZMCHttpTool.h"
#import "CommonUrl.h"
#import "SDCycleScrollView.h"
#import "UserBean.h"
#import "CommentTableViewController.h"
#import "LoginViewController.h"
#import "CommonUrl.h"
#import "CommitOrderViewControllerSecond.h"
#import "MJRefresh.h"
#import "CartSubmitOrderViewController.h"
@interface ShopDetailViewController ()<UITableViewDelegate,UITableViewDataSource,GTButtonTagsViewDelegate,SDCycleScrollViewDelegate,AddGoodsCarViewDelegate>
@property (nonatomic, strong)  GTButtonTagsView *labelsView;
@end

@implementation ShopDetailViewController{
    UITableView *_tableView;
    AdScrollView *_imageSliderView;
    NSInteger _height;
    UILabel *_numLabel;
    //合计
    UILabel *totelPriceLb;
    UIView *_backGroundView;
    UIView *_footerViewForDown;
    NSInteger _pageNo;
    NSArray *_shuxingArr;
    NSMutableArray *_dataArr;
    NSMutableArray *_scrollImgUrls;
    NSArray *_commentList;
    UIView *_view;
    UIImageView *_headerImg;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_tipLabel;
    UILabel *_contentLabel;
    //用来存储正则解析完了的图片URL
    NSMutableArray *_imageUrlArr;
    CGFloat cellImageHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageUrlArr = [[NSMutableArray alloc]init];
    
    [self loadData];
    _pageNo = 1;
    self.title = @"商品详情";
    [self loadTabelView];
    [self loadHeaderView];
    _height = 0;
    self.labelsView.delegate = self;
    
    [self loadFooterView];
    
    // Do any additional setup after loading the view.
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)loadFooterView{
    AddGoodsCarView *addGoodsView = [[[NSBundle mainBundle]loadNibNamed:@"AddGoodsCarView" owner:self options:nil]lastObject];
    addGoodsView.frame = CGRectMake(0, screen_height - 50, screen_width, 50);
    addGoodsView.delegate = self;
    //获取goodsId 收藏使用
    addGoodsView.goodsId = [self goodsId];
    
    //加入购物车
    UIButton *add_buyCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[add_buyCarBtn setBackgroundImage:[UIImage imageNamed:@"add_buyCar"] forState:UIControlStateNormal];
    add_buyCarBtn.tag = 229;
    [add_buyCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [add_buyCarBtn setBackgroundColor:[ViewUtil hexColor:@"#ff9420"]];
    [add_buyCarBtn addTarget:self action:@selector(buyOrAddGoodsCarAction:) forControlEvents:UIControlEventTouchUpInside];
    add_buyCarBtn.frame = CGRectMake(100, 0, (screen_width-100)*0.5, 50);
    [add_buyCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //立即购买
    UIButton *lijiBuy = [UIButton buttonWithType:UIButtonTypeCustom];
    // [lijiBuy setBackgroundImage:[UIImage imageNamed:@"lijibuy"] forState:UIControlStateNormal];
    lijiBuy.tag = 230;
    [lijiBuy setBackgroundColor:[ViewUtil hexColor:@"#dd2727"]];
    [lijiBuy setTitle:@"立即购买" forState:UIControlStateNormal];
    [lijiBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lijiBuy addTarget:self action:@selector(buyOrAddGoodsCarAction:) forControlEvents:UIControlEventTouchUpInside];
    lijiBuy.frame = CGRectMake(100+(screen_width-100)*0.5, 0, (screen_width-100)*0.5, 50);
    
    //添加视图
    [addGoodsView addSubview:lijiBuy];
    [addGoodsView addSubview:add_buyCarBtn];
    [self.view addSubview:addGoodsView];
    
    //    _tableView.tableFooterView = footerView;
    
    
}

-(void)buyOrAddGoodsCarAction:(UIButton *)btn{
    if (_dataArr) {
        
        // 图片
        UIView *buyView = [[UIView alloc]initWithFrame:CGRectMake(0,screen_height - 300,screen_width , 300)];
        UIImageView *shopImgView = [[UIImageView alloc]init];
        shopImgView.frame = CGRectMake(10, -10, 100, 100);
        [shopImgView sd_setImageWithURL:[NSURL URLWithString:[IMGURL stringByAppendingString:_dataArr[0][@"goods_thumb"]]]];
        [buyView addSubview:shopImgView];
        // 价格
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 30, 150, 18)];
        priceLabel.textColor = [ViewUtil hexColor:@"#ed6d4d"];
        priceLabel.text = [NSString stringWithFormat:@"￥%@元",_dataArr[0][@"shop_price"]];
        [buyView addSubview:priceLabel];
        // 库存
        //    UILabel *kucunLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 50, 200, 18)];
        //    [buyView addSubview:kucunLabel];
        //    // 选择分类/尺码
        //    UILabel *fenleiLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 70, 200, 18)];
        //    [buyView addSubview:fenleiLabel];
        //    buyView.backgroundColor = [UIColor whiteColor];
        
        //横线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 110, screen_width, 1)];
        lineView.backgroundColor = [ViewUtil hexColor:@"#d3d3d3"];
        [buyView addSubview:lineView];
        // 属性按钮
        //    self.labelsView.frame = CGRectMake(0, lineView.frame.origin.y +10, self.view.frame.size.width, 300);
        //    [buyView addSubview:self.labelsView];
        UILabel *shuXingLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 115, screen_width, 30)];
        shuXingLb.text = @"抱歉，该商品暂无尺码、颜色分类";
        shuXingLb.backgroundColor = [ViewUtil hexColor:@"#d3d3d3"];
        [buyView addSubview:shuXingLb];
        
        //横线2
        //    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.labelsView.frame.origin.y +310, screen_width, 1)];
        //    lineView2.backgroundColor = [ViewUtil hexColor:@"#d3d3d3"];
        //    [buyView addSubview:lineView2];
        
        UILabel *buyNumLabel = [[UILabel alloc]init];
        buyNumLabel.frame = CGRectMake(10, 150, 100, 21);
        buyNumLabel.text = @"购买数量";
        [buyView addSubview:buyNumLabel];
        UIImageView *jiajianView = [[UIImageView alloc]init];
        jiajianView.frame = CGRectMake(screen_width - 126, 150, 106, 32);
        jiajianView.image = [UIImage imageNamed:@"jiajian"];
        [buyView addSubview:jiajianView];
        // 加
        UIButton *jiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jiaBtn.frame = CGRectMake(screen_width -50, 150, 30, 30);
        [jiaBtn addTarget:self action:@selector(jiaBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [buyView addSubview:jiaBtn];
        
        // numLabel
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width -92, 150, 46, 21)];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.text = @"1";
        [buyView addSubview:_numLabel];
        
        // 减
        UIButton *jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jianBtn.frame = CGRectMake(screen_width -126, 150, 30, 30);
        [jianBtn addTarget:self action:@selector(jianBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [buyView addSubview:jianBtn];
        
        //合计
        totelPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 405, 200, 400, 21)];
        totelPriceLb.textAlignment = NSTextAlignmentRight;
        totelPriceLb.textColor = [UIColor orangeColor];
        totelPriceLb.text = [NSString stringWithFormat:@"共计%@件商品 小计:￥%.2f",_numLabel.text,_numLabel.text.floatValue * [NSString stringWithFormat:@"%@",_dataArr[0][@"shop_price"]].floatValue];
        [buyView addSubview:totelPriceLb];
        
        // 确认
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitBtn setBackgroundColor:[ViewUtil hexColor:@"#ed6d4d"]];
        [commitBtn setTitle:@"确认" forState:UIControlStateNormal];
        if (btn.tag == 230){
            //点击立即购买
            [commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (btn.tag == 229) {
            //点击添加购物车
            [commitBtn addTarget:self action:@selector(commitBtnCartClick) forControlEvents:UIControlEventTouchUpInside];
            
        }
        commitBtn.frame = CGRectMake(0,260, screen_width, 40);
        [buyView addSubview:commitBtn];
        
        UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - 300)];
        backGroundView.backgroundColor  = [UIColor blackColor];
        backGroundView.alpha = 0.3;
        buyView.backgroundColor = [UIColor whiteColor];
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackGround:)];
        [backGroundView addGestureRecognizer:gesture];
        _footerViewForDown = buyView;
        _backGroundView = backGroundView;
        [self.view addSubview:_backGroundView];
        [self.view addSubview:_footerViewForDown];
    }
    
}
//减
-(void)jianBtnClick{
    NSInteger num = _numLabel.text.integerValue;
    if (num > 0){
        _numLabel.text = [NSString stringWithFormat:@"%ld",num-1];
    }
    else {
        _numLabel.text = @"0";
    }
    totelPriceLb.text = [NSString stringWithFormat:@"共计%@件商品 小计:￥%.2f",_numLabel.text,_numLabel.text.floatValue * [NSString stringWithFormat:@"%@",_dataArr[0][@"shop_price"]].floatValue];
}
//加
-(void)jiaBtnClick{
    NSInteger num = _numLabel.text.integerValue;
    _numLabel.text = [NSString stringWithFormat:@"%ld",num+1];
    totelPriceLb.text = [NSString stringWithFormat:@"共计%@件商品 小计:￥%.2f",_numLabel.text,_numLabel.text.floatValue * [NSString stringWithFormat:@"%@",_dataArr[0][@"shop_price"]].floatValue];
}
//点立即购买的确认
-(void)commitBtnClick{
    
    if ([UserBean isSignIn]){
        CommitOrderViewControllerSecond *commitOrderVC = [[CommitOrderViewControllerSecond alloc]init];
        commitOrderVC.goodsprice = _dataArr[0][@"shop_price"];
        commitOrderVC.goodsId = self.goodsId;
        commitOrderVC.goodsName = _dataArr[0][@"goods_name"];
        commitOrderVC.goodsThumbUrl = _dataArr[0][@"goods_thumb"];
        commitOrderVC.goodsNum = _numLabel.text;
        [_backGroundView removeFromSuperview];
        [_footerViewForDown removeFromSuperview];
        [self.navigationController pushViewController:commitOrderVC animated:YES];
    }
    else {
        [self showAlert:@"请先登录"];
    }
}
//点击加入购物车的确认
-(void)commitBtnCartClick{
    if ([UserBean isSignIn]){
        NSMutableDictionary *para = [[NSMutableDictionary alloc]init];
        para[@"act"] = @"add_cart";
        para[@"goods_number"] = _numLabel.text;
        para[@"token"] = [UserBean getUserDictionary][@"token"];
        para[@"goods_id"] = self.goodsId;
        [ZMCHttpTool postWithUrl:FBCart parameters:para success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]){
                //加入购物车成功
                [self showHUDmessage:responseObject[@"msg"]];
                [_backGroundView removeFromSuperview];
                [_footerViewForDown removeFromSuperview];
            }
            else {
                //加入购物车失败
                [self showHUDmessage:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else {
        [self showAlert:@"请先登录"];
    }
}

// 点击外面的部分
- (void)tapBackGround:(UITapGestureRecognizer *)paramSender
{
    [_backGroundView removeFromSuperview];
    [_footerViewForDown removeFromSuperview];
    
}

- (void)GTButtonTagsView:(GTButtonTagsView *)view selectIndex:(NSInteger)index selectText:(NSString *)text {
    
    NSLog(@"第: %ld 文本: %@", (long)index, text);
    
}


-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示消息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)showLoginViewController{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    nav.title = @"登录";
    [self presentViewController:nav animated:YES completion:nil];
}



-(void)loadData{
    // 设置幻灯图
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = _goodsId;
    [ZMCHttpTool postWithUrl:FBShopDetailUrl parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]){
            _shuxingArr = [[NSArray alloc]init];
            _shuxingArr = responseObject[@"data"][@"shuxing_list"];
            _dataArr = [[NSMutableArray alloc]init];
            _dataArr = responseObject[@"data"][@"list"];
            [self jieXigoodsDesc:_dataArr[0][@"goods_desc"]];
            
            _scrollImgUrls = [[NSMutableArray alloc]init];
            _scrollImgUrls[0] = [IMGURL stringByAppendingString:_dataArr[0][@"goods_img"]];
            [self getCommentList:_dataArr[0][@"goods_id"]];
            
            NSNotification *notification = [[NSNotification alloc]initWithName:@"isshoucang" object:nil userInfo:_dataArr[0]];
            [[NSNotificationCenter defaultCenter]postNotification:notification];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
}




-(void)getCommentList:(NSNumber *)goodsId{
    // 评论列表FBCommentListUrl
    NSMutableDictionary * commetParameters = [NSMutableDictionary dictionary];
    commetParameters[@"act"] = @"comment_list";
    NSDictionary *dict = [UserBean getUserDictionary];
    commetParameters[@"token"] = dict[@"token"];
    commetParameters[@"id"] = goodsId;
    commetParameters[@"type"] = @"0";
    commetParameters[@"page"] = @"1";
    commetParameters[@"pagesize"] = @"10";
    [ZMCHttpTool postWithUrl:FBCommentListUrl parameters:commetParameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _commentList = responseObject[@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
}
// 幻灯片点击事件
-(void)onSliderViewClick{
    
}
-(void)loadTabelView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [_tableView reloadData];
    }];
    
    _tableView.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
    self.view.backgroundColor = [ViewUtil hexColor:@"#f0f0f0"];
    [self.view addSubview:_tableView];
}
-(void)loadHeaderView{
    CGRect frame = CGRectMake(0, 0, screen_width, screen_width *0.6);
    UIView *headerView = [[UIView alloc]initWithFrame:frame];
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screen_width, screen_width*0.6) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //cycleScrollView.titlesGroup = titles;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [headerView addSubview:cycleScrollView];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup =  _scrollImgUrls;
    });
    
    _tableView.tableHeaderView = headerView;
}
// 创建幻灯片
- (AdScrollView *)createSliderView:(CGRect)frame imageUrls:(NSArray *)imageUrls {
    AdScrollView *scrollView = [[AdScrollView alloc] initWithFrame:frame];
    
    //如果滚动视图的父视图由导航控制器控制,必须要设置该属性(ps,猜测这是为了正常显示,导航控制器内部设置了UIEdgeInsetsMake(64, 0, 0, 0))
    //scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    return scrollView;
}

-(void)commentListAction{
    CommentTableViewController *commentVC = [[CommentTableViewController alloc]init];
    //    NSNumber *goodsId = _dataArr[0][@"goods_id"];
    commentVC.goodsId = _dataArr[0][@"goods_id"];
    commentVC.isShop = @"yes";
    [self.navigationController pushViewController:commentVC animated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        return 120;
    }
    else if(indexPath.row == 1){
        return 44;
    }
    else {
        return cellImageHeight;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        ShopDetailTableViewCell *shopCell = [[[NSBundle mainBundle]loadNibNamed:@"ShopDetailTableViewCell" owner:self options:nil]lastObject];
        shopCell.shopName.text = _dataArr[0][@"goods_name"];
        
        //        NSNumber *kuaidifei = _dataArr[indexPath.row][@"kuaidifei"];
        //        NSNumber *price = _dataArr[indexPath.row][@"shopPrice"];
        //        NSNumber *saleNum = _dataArr[indexPath.row][@"saleNum"];
        
        shopCell.priceLabel.text = _dataArr[0][@"shop_price"];
        //        shopCell.expMoney.text = _dataArr[indexPath.row][@"kuaidifei"];
        
        NSString *saleNum = _dataArr[0][@"sale_num"];
        shopCell.numLabel.text = [NSString stringWithFormat:@"已售：%@",saleNum];
        //发货地址 暂时去掉
        //        shopCell.addressLabel.text = _dataArr[indexPath.row][@"dizhi"];
        shopCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return shopCell;
    } else if (indexPath.row == 1){
        static NSString *cellIndentif = @"detailcell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentif];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentif];
        }
        //        if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"jifen"];
        //            NSNumber *jifen = _dataArr[0][@"jifen"];
        
        cell.textLabel.text = [NSString stringWithFormat:@"可得积分%@分",_dataArr[0][@"give_integral"]];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
        
        //        }
        //        else {
        //            cell.textLabel.text = @"查看图文详情";
        //            CGRect frame = cell.textLabel.frame;
        //            frame.origin.x = 30;
        //            cell.textLabel.frame = frame;
        //            cell.textLabel.textColor = [ViewUtil hexColor:@"#ed6d4d"];
        //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //        }
    }
    //        else if(indexPath.section ==2){
    //
    //        static NSString *commentcellIndentif = @"commentcell1";
    //        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:commentcellIndentif];
    //        if (!cell1) {
    //            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentcellIndentif];
    //        }
    //        if (indexPath.row == 0) {
    //            if (!_view) {
    //                _view = [[UIView alloc]init];
    //            }
    //            if (!_headerImg) {
    //                _headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    //            }
    //
    //            _headerImg.layer.cornerRadius = 15;
    //            _headerImg.layer.masksToBounds =YES;
    //            NSString *commentPhoto = _dataArr[indexPath.row][@"photo"];
    //
    //            [_headerImg sd_setImageWithURL:[NSURL URLWithString:commentPhoto] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    //            [_view addSubview:_headerImg];
    //            if (!_nameLabel) {
    //                _nameLabel = [[UILabel alloc]init];
    //            }
    //
    //            CGSize nameSize = [_nameLabel boundingRectWithString:_dataArr[indexPath.row][@"userName"] withSize:CGSizeMake(200, 20)withFont:12];
    //            _nameLabel.frame = CGRectMake(50, 15, nameSize.width, 15);
    //            _nameLabel.text = _dataArr[indexPath.row][@"userName"];
    //            _nameLabel.font = [UIFont systemFontOfSize:12];
    //            if (!_timeLabel) {
    //                _timeLabel = [[UILabel alloc]init];
    //            }
    //
    //            _timeLabel.frame = CGRectMake(50 + nameSize.width +10, 15, 200, 15);
    //            _timeLabel.font = [UIFont systemFontOfSize:12];
    //            //            NSNumber *time = _dataArr[indexPath.row][@"addTime"];
    //            _timeLabel.textColor = [ViewUtil hexColor:@"#999999"];
    //            _timeLabel.text =[ViewUtil timeWithTimeIntervalString:_dataArr[indexPath.row][@"addTime"]];
    //            if (!_contentLabel) {
    //                _contentLabel = [[UILabel alloc]init];
    //                _contentLabel.font = [UIFont systemFontOfSize:12];
    //                _contentLabel.numberOfLines = 0;
    //
    //            }
    //            _contentLabel.text = _dataArr[indexPath.row][@"GoodsBrief"];
    //
    //            CGSize size = [_contentLabel boundingRectWithString:_contentLabel.text withSize:CGSizeMake(screen_width - 20, 500) withFont:12];
    //            _contentLabel.frame = CGRectMake(50, 50, screen_width - 60, size.height);
    //            if (!_tipLabel) {
    //                _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _contentLabel.frame.origin.y +size.height, screen_width - 20, 20)];
    //            }
    //
    //            [_view addSubview:_tipLabel];
    //            [_view addSubview:_timeLabel];
    //            [_view addSubview:_nameLabel];
    //            [_view addSubview:_contentLabel];
    //            //        if (_commentList) {
    //            //            [cell.contentView addSubview:view];
    //            //
    //            //        }
    //            [cell1.contentView addSubview:_view];
    //            _height =_tipLabel.frame.origin.y +20;
    //
    //              return cell1;
    //        }
    //
    //        if (indexPath.row == 1) {
    //            static NSString *commentcellIndentif = @"commentcell2";
    //            UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:commentcellIndentif];
    //            if (!cell2) {
    //                cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentcellIndentif];
    //            }
    //
    //            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 50)];
    //            //        footerView.backgroundColor = [UIColor yellowColor];
    //            UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //            commentBtn.frame = CGRectMake(10, 10, screen_width -20, 40);
    //            [commentBtn addTarget:self action:@selector(commentListAction) forControlEvents:UIControlEventTouchUpInside];
    //            commentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    //            [commentBtn setTitle: @"查看全部评价" forState:UIControlStateNormal];
    //            //        if (!_commentList) {
    //            //              [commentBtn setTitle: @"暂无评论" forState:UIControlStateNormal];
    //            //              commentBtn.enabled = NO;
    //            //        }
    //            // commentBtn.titleLabel.textColor = [ViewUtil hexColor:@"#666666"];
    //            [commentBtn setTitleColor:[ViewUtil hexColor:@"#666666"] forState:UIControlStateNormal];
    //            [footerView addSubview:commentBtn];
    //            [cell2.contentView addSubview:footerView];
    //
    //            return cell2;
    //        }
    //
    //
    //    }
    else {
        static NSString *cellIndentif = @"detailcell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentif];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentif];
        }
        if (_dataArr){
            NSLog(@"%@", _dataArr);
            CGFloat imageViewY = 0;
            for (int i=0;i<_imageUrlArr.count;i++){
                UIImageView *imageView = [[UIImageView alloc]init];
                [imageView sd_setImageWithURL:_imageUrlArr[i]];
                if (imageView.image){
                    imageView.frame = CGRectMake(0, imageViewY, screen_width, [self uniformScale:imageView.image]);
                    imageViewY += [self uniformScale:imageView.image];
                    [cell.contentView addSubview:imageView];
                    cellImageHeight = imageViewY;
                }
            }
        }
        return  cell;
        
    }
}



//固定宽度等比缩放图片
-(CGFloat)uniformScale:(UIImage *)image{
    CGFloat imageH = image.size.height;
    CGFloat imageW = image.size.width;
    double sacleW = imageW / screen_width;
    CGFloat imageViewH = imageH / sacleW;
    return imageViewH;
}

//利用正则表达是解析URL
-(void)jieXigoodsDesc:(NSString *)goodsDesc{
    NSError *error;
    NSString *regulaStr = @"(i?)<img.*? src=\"?(.*?\\.(jpg|gif|bmp|bnp|png))\".*?/>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:goodsDesc options:0 range:NSMakeRange(0, [goodsDesc length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [goodsDesc substringWithRange:match.range];
        NSArray *tmpArray = nil;
        if ([substringForMatch rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [substringForMatch componentsSeparatedByString:@"src=\""];
        } else if ([substringForMatch rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [substringForMatch componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSMutableString *src = tmpArray[1];
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [[NSMutableString alloc]initWithString:[src substringToIndex:loc]];
                NSLog(@"正确解析出来的SRC为：%@", src);
                if ([src hasSuffix:@"jpg"]||[src hasSuffix:@"gif"]||[src hasSuffix:@"png"]){
                    if (![src hasPrefix:@"http"]){
                        [src insertString:DOMAINURL atIndex:0];
                        
                    }
                    [_imageUrlArr addObject:src];
                    
                }
            }
        }
    }
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
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
