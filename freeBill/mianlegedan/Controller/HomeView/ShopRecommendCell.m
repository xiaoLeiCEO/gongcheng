//
//  ShopRecommendCell.m
//  meituan
//
//  Created by jinzelu on 15/7/8.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "ShopRecommendCell.h"
#import "ViewUtil.h"
#import "UIImageView+WebCache.h"
#import "CommonUrl.h"
@interface ShopRecommendCell ()
{
    UIImageView *_shopImageView;
    UILabel *_shopNameLabel;
    UILabel *_shopInfoLabel;
    UILabel *_shopPriceLabel;
    UILabel *_soldsLabel;
    UILabel *_distanceLabel;

}

@end

@implementation ShopRecommendCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //图
        _shopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 96, 96)];
        _shopImageView.layer.masksToBounds = YES;
        _shopImageView.layer.cornerRadius = 4;
        [self addSubview:_shopImageView];
        //标题
        _shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, screen_width-100, 30)];
        _shopNameLabel.textColor = [ViewUtil hexColor:@"#333333"];

        _shopNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_shopNameLabel];
        //详情
//        _shopInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, screen_width-100-10, 50)];
//        _shopInfoLabel.numberOfLines = 2;
//        _shopInfoLabel.font = [UIFont systemFontOfSize:13];
//        _shopInfoLabel.textColor = [ViewUtil hexColor:@"#666666"];
//        _shopInfoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        [self addSubview:_shopInfoLabel];
        //价格
        _shopPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 80, 100, 20)];
        _shopPriceLabel.font = [UIFont systemFontOfSize:17];
        _shopPriceLabel.textColor = [ViewUtil hexColor:@"#ed6d4d"];
        [self addSubview:_shopPriceLabel];
        // 已售
        _soldsLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 100, 82, 90, 20)];
        _soldsLabel.font = [UIFont systemFontOfSize:13];
        _soldsLabel.textColor = [ViewUtil hexColor:@"#999999"];
        [self addSubview:_soldsLabel];
        // 距离
//        _distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 100, 23, 90, 20)];
//        _distanceLabel.font = [UIFont systemFontOfSize:11];
//        _distanceLabel.textColor = [ViewUtil hexColor:@"#999999"];
//        [self addSubview:_distanceLabel];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setShopRecM:(ShopInfoModel *)shopRecM{
    _shopRecM = shopRecM;
    
//    NSString *imgUrl = shopRecM.imgurl;
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString: [IMGURL stringByAppendingString:shopRecM.goods_thumb]] placeholderImage:[UIImage imageNamed:@"热门"]];
    
    _shopNameLabel.text = shopRecM.goods_name;
    
    _shopInfoLabel.text = [NSString stringWithFormat:@"[%@]%@",shopRecM.range,shopRecM.goods_desc];
    _shopPriceLabel.text = [NSString stringWithFormat:@"%.2f元",[shopRecM.shop_price doubleValue]];
    _soldsLabel.text = [NSString stringWithFormat:@"已售: %@",shopRecM.sale_num];
    _distanceLabel.text = shopRecM.distance;
//    _shopInfoLabel.text = shopRecM.goods_desc;
//    _shopInfoLabel.text = @"标题";
    _soldsLabel.textAlignment = NSTextAlignmentRight;
//    _distanceLabel.text = @"150km。。。";
  
    _distanceLabel.textAlignment = NSTextAlignmentRight;
}

@end
