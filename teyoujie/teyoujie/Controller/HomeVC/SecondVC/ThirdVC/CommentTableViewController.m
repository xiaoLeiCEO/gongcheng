//
//  CommentTableViewController.m
//  freeBill
//
//  Created by 张梦川 on 16/12/18.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "CommentTableViewController.h"
#import "DetailForCommentCell.h"
#import "ViewUtil.h"
#import "UILabel+StringFrame.h"
#import "ZMCHttpTool.h"
@interface CommentTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CommentTableViewController{
    UITableView *_tableView;
    NSInteger _height;
    NSArray *_commentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
     [self setTableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self loadData];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)loadData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"goodsId"] = _goodsId;
    parameters[@"pageNo"] = @"1";
    parameters[@"pageSize"] = @"10";
    
    
    if ([_isShop isEqualToString:@"yes"]) {
        [ZMCHttpTool postForJavaWithUrl:FBShopCommentListUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"=======%@",responseObject);
            _commentArr = responseObject[@"data"][@"pingLun"];
            
            [_tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    } else {
        [ZMCHttpTool postForJavaWithUrl:FBFUWUCommentListUrl parameters:parameters success:^(id responseObject) {
            NSLog(@"=======%@",responseObject);
            _commentArr = responseObject[@"data"][@"pingLun"];
            
            [_tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
    
}
-(void)setTableView{
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _commentArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_height) {
        return _height;
    } else {
        return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentif = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentif];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentif];
    }
    UIView *cellView = [[UIView alloc]init];
    DetailForCommentCell *commentView = [[[NSBundle mainBundle]loadNibNamed:@"DetailForCommentCell" owner:self options:nil]lastObject];
   // NSString *commentPhoto = _commentArr[indexPath.row][@"photo"];
    
    //[commentView.headImgView sd_setImageWithURL:[NSURL URLWithString:commentPhoto] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    //NSNumber *pingfen = _commentArr[indexPath.row][@"comment_rank"];
//    UIImageView *starImg = [[UIImageView alloc]initWithFrame:commentView.starImgView.frame];
//    starImg.contentMode = UIViewContentModeScaleAspectFill;
//    starImg.clipsToBounds = YES;
//    starImg.image = [UIImage imageNamed:@"star"];
//    CGRect starFrame = starImg.frame;
//    starFrame.size.width = starFrame.size.width*(pingfen.doubleValue/5);
//    starImg.frame =starFrame;
//    [commentView addSubview:starImg];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMGURL,_commentArr[indexPath.row][@"touxiang"]];
    [commentView.headImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    
    commentView.timeLabel.text = [ViewUtil timeWithTimeIntervalString:_commentArr[indexPath.row][@"addTime"]];
    
    commentView.frame = CGRectMake(0, 0, screen_width, 60);
    UILabel *nameLabel = [[UILabel alloc]init];
    NSString *nameStr = _commentArr[indexPath.row][@"userName"];
    CGSize size = [nameLabel boundingRectWithString:nameStr withSize:CGSizeMake(screen_width -120, 17) withFont:14];
    nameLabel.text = nameStr;
    nameLabel.frame = CGRectMake(60, 15, size.width +10, 17);
    nameLabel.font = [UIFont systemFontOfSize:13];
    [commentView addSubview:nameLabel];
    
    UIImageView *vipImgView = [[UIImageView alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x +nameLabel.frame.size.width +10, 20, 15, 15)];
    [commentView addSubview: vipImgView];
    [cellView addSubview:commentView];
    
    UILabel *commentLabel = [[UILabel alloc]init];
    NSString *commentStr = _commentArr[indexPath.row][@"content"];
    CGSize size2 = [commentLabel boundingRectWithString: commentStr withSize:CGSizeMake(screen_width - 40, 500) withFont:13];
    commentLabel.frame = CGRectMake(60, 50, screen_width - 60, size2.height);
    commentLabel.font = [UIFont systemFontOfSize:13];
    commentLabel.text = _commentArr[indexPath.row][@"content"];
    [cellView addSubview:commentLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cellView.frame.size.height-1, screen_width, 1)];
    lineView.backgroundColor = [ViewUtil hexColor:@"#d3d3d3"];
    [cellView addSubview:lineView];
    [cell.contentView addSubview:cellView];
    
    _height = commentLabel.frame.origin.y +size2.height +10;

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
