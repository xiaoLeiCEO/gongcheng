//
//  CommentTableViewController.h
//  freeBill
//
//  Created by 张梦川 on 16/12/18.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CommentTableViewController : BaseViewController
@property(nonatomic,copy)NSString *goodsId;
@property(nonatomic,copy)NSString *isShop;
@property(nonatomic,strong)NSArray *commentList;
@end
