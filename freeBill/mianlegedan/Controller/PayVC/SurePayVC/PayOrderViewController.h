//
//  PayOrderViewController.h
//  freeBill
//
//  Created by 张梦川 on 16/12/11.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayOrderViewController : UIViewController

//@property (nonatomic,copy) NSString *partnerId;
//@property (nonatomic,copy) NSString *prepayId;
//@property (nonatomic,copy) NSString *package;
//@property (nonatomic,copy) NSString *nonceStr;
//@property (nonatomic,assign) UInt32 timeStamp;
//@property (nonatomic,copy) NSString *sign;


@property (nonatomic,copy) NSString *goodsThumbImgUrl;
@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,copy) NSString *goodsPrice;

@property (nonatomic,copy) NSString *goodsId;
@property (nonatomic,copy) NSString *goodsNum;


@property (nonatomic,assign) BOOL isZhiYing;
@property (nonatomic,copy) NSString *orderNum;



@end
