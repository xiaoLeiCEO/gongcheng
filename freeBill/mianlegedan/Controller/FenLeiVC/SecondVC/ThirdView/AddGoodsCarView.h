//
//  AddGoodsCarView.h
//  freeBill
//
//  Created by 张梦川 on 16/12/15.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddGoodsCarViewDelegate;

@interface AddGoodsCarView : UIView 
@property (weak, nonatomic) IBOutlet UIImageView *collectImage;
@property (copy,nonatomic) NSString *goodsId;
@property(weak,nonatomic) id <AddGoodsCarViewDelegate>delegate;
@end


//让ShopDetailViewController弹警告框
@protocol AddGoodsCarViewDelegate <NSObject>
-(void)showAlert: (NSString *)msg;
-(void)showLoginViewController;

@end
