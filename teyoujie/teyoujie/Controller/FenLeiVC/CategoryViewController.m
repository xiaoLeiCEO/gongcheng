//
//  CategoryViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/5.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "CategoryViewController.h"
#import "MultilevelMenu.h"
#import "ViewUtil.h"
#import "SecondDetailViewController.h"
#import "ZMCHttpTool.h"
#import "CommonUrl.h"
#import "SearchViewController.h"
#import "MBProgressHUD.h"
@interface CategoryViewController ()
@property(nonatomic ,strong)NSMutableArray *dataArray;
@property(nonatomic, copy)NSString *tempId;
@property(nonatomic, copy)NSString *tempFuId;
@property(nonatomic,strong)MBProgressHUD *proHud;
@end

@implementation CategoryViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    [self loadData];
    
    
    
    /**
     *  适配 ios 7 和ios 8 的 坐标系问题
     */
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    /**
     默认是 选中第一行
     
     :returns: <#return value description#>
     */
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//-(NSMutableArray *)dataArray{
//    if (!_dataArray) {
//        _dataArray = [[NSMutableArray alloc]init];
//        [self loadData];
//    }
//    return _dataArray;
//}

-(MBProgressHUD *)proHud{
    if (!_proHud){
        _proHud = [[MBProgressHUD alloc]initWithView:self.view];
    }
    return _proHud;
}


-(void)loadData{
    NSLog(@"====%@",FBCategoryUrl);
    self.proHud.mode = MBProgressHUDModeIndeterminate;
    self.proHud.label.text = @"正在加载...";
    [self.proHud showAnimated:YES];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [ZMCHttpTool postForJavaWithUrl:FBCategoryUrl parameters:parameter success:^(id responseObject) {
        self.dataArray = responseObject[@"page"][@"list"];
        [self loadshopView];
        [self.proHud hideAnimated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_dataArray){
        [self loadData];
    }
}

-(void)loadshopView{
    
    NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
    NSInteger countMax=_dataArray.count;
    for (int i=0; i<countMax; i++) {
        
        rightMeun * meun=[[rightMeun alloc] init];
        meun.meunName=[NSString stringWithFormat:@"%@",_dataArray[i][@"name"]];
        
        NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
        NSArray *tempArr =_dataArray[i][@"list"];
        for ( int z=0; z <tempArr.count; z++) {
            
            rightMeun * meun2=[[rightMeun alloc] init];
            meun2.meunName=[NSString stringWithFormat:@"%@",tempArr[z][@"name"]];
            meun2.urlName = [NSString stringWithFormat:@"%@%@",IMGFORJAVAURL,tempArr[z][@"imgs"]];
            meun2.ziId = [NSString stringWithFormat:@"%@",tempArr[z][@"ziid"]] ;
            meun2.fuId = [NSString stringWithFormat:@"%@",tempArr[z][@"fuid"]] ;
            [zList addObject:meun2];
            
        }
        
        meun.nextArray=zList;
        [lis addObject:meun];
    }
    MultilevelMenu * view=[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-64) WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMeun* info) {
        SecondDetailViewController *secondVC = [[SecondDetailViewController alloc]init];
        secondVC.catId =info.ziId;
        //        secondVC.secondFuId =info.fuId;
        [self.navigationController pushViewController:secondVC animated:YES];
        NSLog(@"点击的 菜单%@",info.meunName);
    }];
    
    
    view.needToScorllerIndex=0;
    view.isRecordLastScroll=YES;
    [self.view addSubview:view];
}
-(void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"64x1"]];
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    //    label.text = @"全部分类";
    //    label.textColor = [UIColor whiteColor];
    //    label.textAlignment = NSTextAlignmentCenter;
    //搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, screen_width-20, 25)];
    searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"near_search"]];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 12;
    [backView addSubview:searchView];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame =searchView.frame;
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 15, 15)];
    [searchImage setImage:[UIImage imageNamed:@"sousuo"]];
    [searchView addSubview:searchImage];
    
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 25)];
    placeHolderLabel.font = [UIFont boldSystemFontOfSize:13];
    //    placeHolderLabel.text = @"请输入商家、品类、商圈";
    placeHolderLabel.text = @"搜索商品";
    placeHolderLabel.textColor = [ViewUtil hexColor:@"#999999"];
    [searchView addSubview:placeHolderLabel];
    [backView addSubview:searchBtn];
    //    [backView addSubview:label];
    
    [self.view addSubview:backView];
    
    
}
-(void)searchAction{    
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    searchVC.isZhiYing = YES;
    [self presentViewController:searchVC animated:YES completion:nil];
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
