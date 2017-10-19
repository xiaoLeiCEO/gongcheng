//
//  ShopInfoModel.h
//  meituan
//
//  Created by jinzelu on 15/7/8.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopInfoModel : NSObject

// 店名
@property(nonatomic, strong) NSString *goods_name;
// 地区
@property(nonatomic, strong) NSString *range;

// 标题
@property(nonatomic, strong) NSString *goods_desc;
// 价格
@property(nonatomic, strong) NSNumber *shop_price;

// 图片地址
@property(nonatomic, strong) NSString *goods_thumb;

// 已售
@property(nonatomic, strong) NSString *sale_num;

// 距离
@property(nonatomic, strong) NSString *distance;


@property(nonatomic, strong) NSString *goods_id;
@property(nonatomic, strong) NSString *shop_id;


@end
