//
//  UILabel+StringFrame.m
//  kitchen
//
//  Created by 张梦川 on 15/10/13.
//  Copyright © 2015年 fangyp. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)

-(CGSize)boundingRectWithString:(NSString *)str withSize:(CGSize)size{
    CGSize titleSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;

    
    return titleSize;
}
-(CGSize)boundingRectWithString:(NSString *)str withSize:(CGSize)size withFont:(int)font{
    CGSize titleSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    
    
    return titleSize;
}

@end
